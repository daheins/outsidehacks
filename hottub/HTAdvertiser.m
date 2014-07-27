//
//  HTAdvertiser.m
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTAdvertiser.h"
#import "HTUserManager.h"
#import "HTUser.h"

@interface HTAdvertiser () <CBPeripheralDelegate>

#pragma mark - Service Variables
@property (nonatomic, strong) CBUUID *serviceUUID, *usernameUUID, *userIDUUID;
@property (nonatomic, strong) CBMutableCharacteristic *userIDCharacteristic, *usernameCharacteristic;
@property (nonatomic, strong) CBMutableService *service;

#pragma mark - Peripheral Properties

@property (nonatomic, strong) dispatch_queue_t peripheralQueue;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

#pragma mark - Current State

@property (nonatomic, strong) HTUser *currentUser;
@property (nonatomic, strong) RACDisposable *userSubscription;
@property (nonatomic) RACSubject *capabilitySubject;
@property (nonatomic) HTCapabilityState advertiserState;

@end

@implementation HTAdvertiser

WSM_SINGLETON_WITH_NAME(sharedInstance)

- (instancetype)init {
    if (!(self = [super init])) return nil;
    NSLog(@"Peripheral Manager: %@",self.peripheralManager);
    return self;
}

- (void)subscribeToUser:(RACSubject *)subject {
    self.userSubscription = [subject subscribeNext:^(HTUser *user) {
        NSLog(@"User has changed!");
        self.currentUser = user;
        [self startAdvertising];
    }];
}

- (void)setUserSubscription:(RACDisposable *)userSubscription {
    if (_userSubscription) {
        [_userSubscription dispose];
    }
    _userSubscription = userSubscription;
}

#pragma mark - Lazy Property Instantiation

- (CBPeripheralManager *)peripheralManager {
    return WSM_LAZY(_peripheralManager, ({
        dispatch_queue_t peripheralQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        NSDictionary *info = NSBundle.mainBundle.infoDictionary;
        NSDictionary *options = @{ CBPeripheralManagerOptionShowPowerAlertKey:@1,
                                   CBPeripheralManagerOptionRestoreIdentifierKey:info[@"CFBundleIdentifier"]};
        CBPeripheralManager *manager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                               queue:peripheralQueue
                                                                             options:options];
        manager;
    }));
}

- (RACSubject *) capabilitySubject {
    return WSM_LAZY(_capabilitySubject, [RACSubject subject]);
}

- (dispatch_queue_t)peripheralQueue {
    return WSM_LAZY(_peripheralQueue, dispatch_queue_create("com.wrkstrm.queue.pm", DISPATCH_QUEUE_SERIAL));
}

- (CBUUID *)serviceUUID {
    return WSM_LAZY(_serviceUUID, [CBUUID UUIDWithString:@"9D07C96F-AF59-40C9-80E3-4952173B6588"]);
}

- (CBUUID *)usernameUUID {
    return WSM_LAZY(_usernameUUID, [CBUUID UUIDWithString:@"0D7E8A55-4420-4069-A249-8D8BFE6C460A"]);
}

- (CBUUID *)userIDUUID {
    return WSM_LAZY(_userIDUUID, [CBUUID UUIDWithString:@"B19408E1-2D0D-4650-9E45-2DA006C462F0"]);
}

- (CBMutableCharacteristic *)userIDCharacteristic {
    return WSM_LAZY(_userIDCharacteristic, ({
        [[CBMutableCharacteristic alloc] initWithType:self.usernameUUID
                                           properties:CBCharacteristicPropertyNotify
                                                value:nil
                                          permissions:CBAttributePermissionsReadable];
    }));
}

- (CBMutableCharacteristic *)usernameCharacteristic {
    return WSM_LAZY(_userIDCharacteristic, ({
        [[CBMutableCharacteristic alloc] initWithType:self.usernameUUID
                                           properties:CBCharacteristicPropertyNotify
                                                value:nil
                                          permissions:CBAttributePermissionsReadable];
    }));
}

- (CBMutableService *)service {
    return WSM_LAZY(_service, ({
        CBMutableService *newService = [[CBMutableService alloc] initWithType:self.serviceUUID
                                                                      primary:YES];
        newService.characteristics = @[self.usernameCharacteristic, self.userIDCharacteristic];
        newService;
    }));
}

#pragma mark - CBPeripheralmanager Delegate

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"Manager state did update: %li", peripheral.state);
    HTCapabilityState state = [HTAdvertiser capabilityStateFromPeripheralManager:peripheral];
    [self.capabilitySubject sendNext:[NSNumber numberWithUnsignedInteger:state]];
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn: {
            NSLog(@"Power On!");
            
            if (self.currentUser) {
                [self startAdvertising];
            }
        } break;
        case CBPeripheralManagerStatePoweredOff: {
            DDLogError(@"Turn on Bluetooth! %d", (int)peripheral.state);
            [[[UIAlertView alloc] initWithTitle:@"Bluetooth must be enabled"
                                        message:@"to configure your device as a beacon"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            
            self.advertiserState = kHTCapabilityStateSettings;
            [peripheral stopAdvertising];
        } break;
        default: {
            self.advertiserState = kHTCapabilityStateUnknown;
        } break;
    }
}

- (void)startAdvertising {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.peripheralManager addService:self.service];
        NSDictionary *info = NSBundle.mainBundle.infoDictionary;
        [self.peripheralManager startAdvertising:@{CBAdvertisementDataLocalNameKey:info[@"CFBundleIdentifier"],
                                                   CBAdvertisementDataServiceUUIDsKey:@[self.serviceUUID]}];
    });
}
- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(NSError *)error {
    if (error) {
        DDLogError(@"Error: %@", error);
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSTimer scheduledTimerWithTimeInterval:2.5
                                         target:self
                                       selector:@selector(printAdvertisingState:)
                                       userInfo:nil
                                        repeats:YES];
    });
}

- (void)printAdvertisingState: (NSTimer *) timer {
    NSLog(@"%i", self.peripheralManager.isAdvertising);
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service error:(NSError *)error {
    if (error) {
        DDLogError(@"Error: %@", error);
        return;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"Read request: %@", request);
    if ([request.characteristic.UUID isEqual:self.usernameUUID]) {
        [peripheral respondToRequest:request withResult: CBATTErrorSuccess];
    } else if ([request.characteristic.UUID isEqual:self.userIDUUID]) {
        [peripheral respondToRequest:request withResult: CBATTErrorSuccess];
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
                  central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    
    [[CBLManager sharedInstance] doAsync:^{
        NSLog(@"Did subscribe: %@", characteristic);
        NSData *data;
        CBMutableCharacteristic *service;
        if ([characteristic.UUID isEqual:self.usernameUUID]) {
            data = [self.currentUser.document.documentID dataUsingEncoding:NSUTF8StringEncoding];
            service = self.usernameCharacteristic;
        }
        if (data) {
            [peripheral updateValue:data
                  forCharacteristic:service
               onSubscribedCentrals:nil];
        }
    }];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
         willRestoreState:(NSDictionary *)dict {
    DDLogError(@"Whoaa.");
}

#pragma mark - WSMCapabilityProvider Protocol

+ (HTCapabilityState)capabilityStateFromPeripheralManager: (CBPeripheralManager *)peripheral {
    HTCapabilityState state;
    switch (peripheral.state) {
        case CBPeripheralManagerStatePoweredOn: {
            state = kHTCapabilityStateOn;
        } break;
        case CBPeripheralManagerStatePoweredOff: {
            state = kHTCapabilityStateSettings;
        } break;
        default: {
            state = kHTCapabilityStateUnknown;
        } break;
    }
    return state;
}

+ (NSString *)capabilityDescription {
    return @"Allow other nearby users to find you.";
}

+ (BOOL)requireAuthentication {
    return NO;
}

- (HTCapabilityState)capabilityState {
    return [HTAdvertiser capabilityStateFromPeripheralManager: self.peripheralManager];
}

- (RACSignal *)capabilitySignal {
    return (RACSignal *) self.capabilitySubject;
}

@end
