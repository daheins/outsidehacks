//
//  HTUserManager.h
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTAdvertiser.h"
#import "HTUser.h"

#pragma mark - Enum, Option, block and Global String declarations.

typedef NS_ENUM(NSUInteger, HTCapabilityState) {
    kHTCapabilityStateUnknown,
    kHTCapabilityStateSettings,
    kHTCapabilityStateOn
};

typedef NS_OPTIONS(NSUInteger, HTUserManagerState) {
    /** Initial status, while the manager tries to register capabilities. */
    HTUserManagerStateInitialized  = 1UL << 0,
    /** Session status indicating everything is authorized and ready to go! */
    HTUserManagerStateAuthorized   = 1UL << 1,
    /** Session status indicating an auth screen needs to be presented. */
    HTUserManagerStateUnauthorized = 1UL << 2
};


@interface HTUserManager : NSObject

@property (nonatomic, strong, readonly) HTUser *currentUser;

@property (nonatomic, strong, readonly) RACSignal *currentStateSignal;

@property (nonatomic, readonly) HTUserManagerState managerState;

/**
 Returns or creates a HTUserManager instance which loads the default user.
 If a default user is not specified, a user is a created and made the dafault user.
 */

+ (instancetype) sharedInstance;

- (void) createDefaultUserWithParams: (NSDictionary *) params;

/**
 Register user capabilites. Must be done after setting the current user.
 */

- (void) registerCapabilities: (NSArray *) capabilities;

/**
 Returns a list of authentication delegates (the capability providers).
 */

- (NSDictionary *) authenticationDelegates;

/**
 Returns NO if there is no currentUser and any registered capability is not authorized.
 */

+ (BOOL)authenticated;

/**
 Returns YES if all capabilities are authorized and the user is authenticated.
 */

- (BOOL)authorized;

- (NSArray *) nearbyUsers; 

@end


/**
 * Manager responsible for handling the capabilities, and CBL database for locals users.
 */

@protocol HTCapabilityProvider <NSObject>

@required

/**
 The singleton responsible for the capability.
 */

+ (instancetype)sharedInstance;

/**
 A required property to store the current user.
 */

- (HTUser *)currentUser;

- (void) setCurrentUser:(HTUser *)currentUser;

- (void)subscribeToUser: (RACSubject *)subject;

- (RACDisposable *)userSubscription;

- (HTCapabilityState)capabilityState;

+ (NSString *)capabilityDescription;

+ (BOOL) requireAuthentication;

/**
 A method which should return the current state of the capability.
 */
- (RACSubject *)capabilitySignal;

- (void) start;

- (void) stop;

@optional

- (NSArray *) nearbyUsers;

@end