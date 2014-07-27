//
//  HTUser.h
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>
#import "HTModel.h"

@interface HTUser : HTModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *facebook;
@property (nonatomic, strong) NSString *twitter;

+ (HTUser *) defaultUser;

+ (void) setDefaultUser:(HTUser *)user;

+ (HTUser *) createDefaultUserWithProperties:(NSDictionary *)properties;

+ (HTUser *) existingUserWithID:(NSString *)userID;

- (void) addParams:(NSDictionary *)params;

- (NSString*) localDatabaseName;

@end
