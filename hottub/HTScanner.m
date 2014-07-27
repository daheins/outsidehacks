//
//  HTScanner.m
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTScanner.h"
#import "HTUserManager.h"
#import "HTUser.h"

@interface HTScanner () 

#pragma mark - Service Variables
@property (nonatomic, strong) CBUUID *serviceUUID;

#pragma mark - Central Properties

@property (nonatomic, strong) CBCentralManager *centralManager;
@property (nonatomic, strong) NSMutableSet *stagedDevices, *connectedDevices;

#pragma mark - Current State

@property (nonatomic, strong) NSMutableArray *knownDevicesArray;

@property (nonatomic, strong) HTUser *currentUser;
@property (nonatomic, strong) RACDisposable *userSubscription;
@property (nonatomic, strong) RACSubject *capabilitySubject;

@end

@implementation HTScanner

WSM_SINGLETON_WITH_NAME(sharedInstance)

- (instancetype) init {
    if (!(self = [super init])) return nil;
    NSLog(@"Scanner: %@", self.centralManager);
    return self;
}

- (CBCentralManager *)centralManager {
    return WSM_LAZY(_centralManager, ({
        dispatch_queue_t centralQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        [[CBCentralManager alloc] initWithDelegate:self
                                             queue:centralQueue
                                           options:@{}];
    }));
}

- (void) start {
    [self startScan];
    
}

- (void) stop {
    for (CBPeripheral *staged in [self.stagedDevices setByAddingObjectsFromSet: self.connectedDevices].objectEnumerator) {
        [self.centralManager cancelPeripheralConnection:staged];
    }
    [self.centralManager stopScan];
}

#pragma mark - Lazy Properties

- (RACSubject *) capabilitySubject {
    return WSM_LAZY(_capabilitySubject, [RACSubject subject]);
}

- (NSMutableSet *) stagedDevices {
    return WSM_LAZY(_stagedDevices, [NSMutableSet new]);
}

- (NSMutableSet *) connectedDevices {
    return WSM_LAZY(_connectedDevices, [NSMutableSet new]);
}

- (NSMutableArray *) knownDevicesArray {
    return WSM_LAZY(_knownDevicesArray, @[].mutableCopy);
}

- (CBUUID *)serviceUUID {
    return WSM_LAZY(_serviceUUID, [CBUUID UUIDWithString:@"9D07C96F-AF59-40C9-80E3-4952173B6589"]);
}

#pragma mark - CBCentralManagerDelegate

- (void) centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"Manager state did update: %li", central.state);
    HTCapabilityState state = [HTScanner capabilityStateFromCentralManager: central];
    [self.capabilitySubject sendNext:[NSNumber numberWithUnsignedInteger:state]];
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: {
            if (self.currentUser) {
                [self startScan];
            }
        } break;
        case CBCentralManagerStatePoweredOff: {
        } break;
        default: {
        } break;
    }
}

- (void) startScan {
    [self.centralManager scanForPeripheralsWithServices:@[self.serviceUUID]
                                                options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES}];
}


- (void) centralManager:(CBCentralManager *)central
  didDiscoverPeripheral:(CBPeripheral *)peripheral
      advertisementData:(NSDictionary *)advertisementData
                   RSSI:(NSNumber *)RSSI {
    if ([self deviceUnknown:peripheral]) {
        NSLog(@"%@", peripheral);
        [self.stagedDevices addObject: peripheral];
        
        [central connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                                        CBConnectPeripheralOptionNotifyOnNotificationKey:@YES,
                                                        CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES
                                                        }];
    }
}

- (BOOL) deviceUnknown: (CBPeripheral *) peripheral {
    for (CBPeripheral *staged in [self.stagedDevices setByAddingObjectsFromSet: self.connectedDevices].objectEnumerator) {
        if ([staged.identifier.UUIDString isEqualToString:peripheral.identifier.UUIDString]) {
            return NO;
        }
    }
    return YES;
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self.connectedDevices addObject:peripheral];
    [self.stagedDevices removeObject:peripheral];
    
    peripheral.delegate = self;
    [peripheral discoverServices:@[self.serviceUUID]];
    NSLog(@"Connected to People: %@", self.connectedDevices);
}

/** An attempt to cleanup when things go wrong - usually 1309 error. or you're done with the connection.
 *  This cancels any subscriptions if there are any, or straight disconnects if not.
 *  (didUpdateNotificationStateForCharacteristic will cancel the connection if a subscription is involved)
 */

- (void) centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral
                  error:(NSError *)error {
    NSLog(@"Failed to connect to person: %@", error);
    
    [self.centralManager stopScan];
    
    [self cancelConnection:peripheral];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startScan];
    });
}

- (void) cancelConnection: (CBPeripheral *)peripheral {
    NSLog(@"It has come to this.");
    [self.stagedDevices removeObject:peripheral];
    [self.connectedDevices removeObject:peripheral];
    
    // See if we are subscribed to a characteristic on the peripheral
    for (CBService *service in peripheral.services) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        }
    }
    
    // If we've got this far, we're connected, but we're not subscribed, so we just disconnect
    [self.centralManager cancelPeripheralConnection:peripheral];
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral
                  error:(NSError *)error {
    NSLog(@"This person just left: %@", peripheral);
    [self.connectedDevices removeObject:peripheral];
}

#pragma mark - Peripheral Delegate

/** The Transfer Service was discovered
 */

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cancelConnection:peripheral];
    } else {
        for (CBService *service in peripheral.services) {
            NSLog(@"Discovering characteristics for service %@", service);
            [peripheral discoverCharacteristics:nil forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service
             error:(NSError *)error {
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cancelConnection:peripheral];
    } else {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            NSLog(@"Notified about characteristic %@", characteristic);
        }
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic
            error:(NSError *)error {
    NSLog(@"Characteristic: %@ Error: %@", characteristic, error);
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
             error:(NSError *)error {
    NSLog(@"Wow the characteristic has changed: %@", characteristic);
}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices {
    NSLog(@"This service left: %@", invalidatedServices);
}

#pragma mark - HTCapabilityProvider

+ (HTCapabilityState)capabilityStateFromCentralManager: (CBCentralManager *)central {
    NSLog(@"Central State: %@", central);
    HTCapabilityState state;
    switch (central.state) {
        case CBCentralManagerStatePoweredOn: {
            state = kHTCapabilityStateOn;
        } break;
        case CBCentralManagerStatePoweredOff: {
            state = kHTCapabilityStateSettings;
        } break;
        default: {
            state = kHTCapabilityStateUnknown;
        } break;
    }
    return state;
}

+ (NSString *)capabilityDescription {
    return @"Look for other people around you!";
}

- (void) subscribeToUser:(RACSubject *)subject {
    NSLog(@"Subscribe!");
    self.userSubscription = [subject subscribeNext:^(HTUser *user) {
        NSLog(@"User has changed!");
        self.currentUser = user;
        [self startScan];
    }];
}

- (void) setUserSubscription:(RACDisposable *)userSubscription {
    if (_userSubscription) {
        [_userSubscription dispose];
    }
    _userSubscription = userSubscription;
}

- (HTCapabilityState)capabilityState {
    return [HTScanner capabilityStateFromCentralManager: self.centralManager];
}

+ (BOOL) requireAuthentication {
    return NO;
}

- (RACSignal *)capabilitySignal {
    return (RACSignal *) self.capabilitySubject;
}
@end
