//
//  HTUserManager.m
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTUserManager.h"
#import "HTUser.h"

@interface HTUserManager ()

#pragma mark - Propery Declarations

@property (nonatomic, strong) NSMutableArray *capabilityProviders;

#pragma mark - State
@property (nonatomic, strong, readwrite) HTUser *currentUser;
@property (nonatomic, strong) RACSubject *userSubject;
@property (nonatomic, readwrite) HTUserManagerState managerState;
@property (nonatomic, strong, readwrite) RACSignal *currentStateSignal;

@end

@implementation HTUserManager

@synthesize currentUser = _currentUser;

WSM_SINGLETON_WITH_NAME(sharedInstance)

- (instancetype)init {
    if ((self = [super init])) {}
    return self;
}

+ (BOOL) authenticated {
    HTUserManager *manager = [HTUserManager sharedInstance];
    return manager.currentUser && manager.authorized;
}

- (NSArray *) authenticationDelegates {
    return [NSArray arrayWithArray: self.capabilityProviders];
}

- (NSArray *) shouldDisplayPermissionControllers {
    return nil;
}

- (void) registerCapabilities:(NSArray *)capabilities {
    NSMutableArray *signals = @[].mutableCopy;
    for (id<HTCapabilityProvider> provider in capabilities) {
        [self subscribeToProvderStateSubject:provider]; //Subscribe to provider states.
        [provider subscribeToUser:self.userSubject]; //Supply the provider with user notifications.
        NSLog(@"Provider Class: %@", provider.class);
        [signals addObject:provider.capabilitySignal]; //Gather up the provider state subjects.
        [self.capabilityProviders addObject:provider]; //Add to list of known Providers
    }
    //Combine the subjects for a global state.
    [self deriveGlobalState: signals];
}

- (void) subscribeToProvderStateSubject: (id<HTCapabilityProvider>) provider {
    [provider.capabilitySignal subscribeNext:^(NSNumber *state) {
        NSLog(@"Provider auth state changed!");
    }];
}

- (void) deriveGlobalState:(NSArray *)signals {
    NSAssert(signals.count == 2, @"This is a hackathon.");
    self.currentStateSignal = [RACSignal combineLatest:signals];
    
    RAC(self, managerState) = [self.currentStateSignal reduceEach:^(NSNumber *state1, NSNumber *state2) {
        NSLog(@"Latest!");
        return @0;
    }];
}

- (BOOL) authorized {
    for (id<HTCapabilityProvider> provider in self.capabilityProviders) {
        HTCapabilityState state =[provider capabilityState];
        NSLog(@"Provider: %@ State: %lu", provider.class, state);
        if (state != kHTCapabilityStateOn) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - Lazy Property Instantiation

- (NSMutableArray *) capabilityProviders {
    return WSM_LAZY(_capabilityProviders, @[].mutableCopy);
}

- (RACSubject *) userSubject {
    return WSM_LAZY(_userSubject, [RACSubject subject]);
}

/**
 Checks to see if there is current user
 */

- (HTUser *)currentUser {
    return WSM_LAZY(_currentUser, ({
        HTUser *user = [HTUser defaultUser];
        if (user) {
            [self.userSubject sendNext:user];
        }
        user;
    }));
}

- (void) createDefaultUserWithParams:(NSDictionary *)params {
    self.currentUser = [HTUser createDefaultUserWithProperties:params];
}

- (void) setCurrentUser:(HTUser *)currentUser {
    [HTUser setDefaultUser:currentUser];
    [self.userSubject sendNext:currentUser];
}

@end
