//
//  HTUser.m
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTUser.h"

@implementation HTUser

#define localUsersDB @"local_users"
#define defaultUserDocument @"default_user"
#define defaultUserProperty @"userID"

+ (HTUser *) defaultUser {
    NSError *error;
    CBLDatabase *db = [[CBLManager sharedInstance] databaseNamed:localUsersDB error:&error];
    CBLDocument *doc = [db documentWithID:defaultUserDocument];
    HTUser *user = [HTUser modelForDocument: [db documentWithID:doc[defaultUserProperty]]];
    
    return doc[defaultUserProperty] ? ({
        [user registerLocalDatabaseViews];
        user;
    }) : nil;
}

+ (HTUser *) createDefaultUserWithProperties: (NSDictionary *) properties {
    NSMutableDictionary *mutableProperties = properties.mutableCopy;
    NSLog(@"Creating a user with these properties: %@", mutableProperties);
    NSString *userID = [mutableProperties[@"id"] stringValue];
    NSAssert(userID, @"ID Property is necessary!");
    //Create a brand new Default User
    CBLDatabase *usersDB = [[CBLManager sharedInstance] databaseNamed:localUsersDB
                                                                error:nil];
    CBLDocument *userDocument = [usersDB documentWithID:userID];
    
    [mutableProperties removeObjectForKey:@"id"];
    [userDocument putProperties:mutableProperties error:nil];
    
    HTUser *newDefaultUser = [[HTUser alloc] initWithDocument:userDocument];
    [newDefaultUser save:nil];
    
    [HTUser setDefaultUser:newDefaultUser];
    
    return newDefaultUser;
}

+ (HTUser *) existingUserWithID: (NSString *)userID {
    NSError *error;
    CBLManager *sharedCBLManager = [CBLManager sharedInstance];
    CBLDatabase *allUserDatabases = [sharedCBLManager databaseNamed:localUsersDB
                                                              error:&error];
    NSAssert(!error, @"Must provide a local_users database");
    CBLDocument *userDocument = [allUserDatabases existingDocumentWithID:userID];
    return userDocument ? [HTUser modelForDocument: userDocument]: nil;
}

+ (void) setDefaultUser:(HTUser *)user {
    NSError *error;
    CBLManager *sharedCBLManager = [CBLManager sharedInstance];
    CBLDatabase *db = [sharedCBLManager databaseNamed:localUsersDB
                                                error:&error];
    
    CBLUnsavedRevision *doc = [[db documentWithID:defaultUserDocument] newRevision];
    
    doc[defaultUserProperty] = user.docID;
    [doc save: &error];
    
    NSAssert(!error, @"Default user not saved!");
    
    [user registerLocalDatabaseViews];
    
}

- (void) registerLocalDatabaseViews {
    CBLDatabase *database = [[CBLManager sharedInstance] databaseNamed:self.localDatabaseName
                                                                 error:nil];
    // Register stuff...
}

- (NSString *) localDatabaseName {
    return [NSString stringWithFormat:@"u_%@", self.document.documentID.lowercaseString];
}

- (void) addParams: (NSDictionary *)params {
    CBLUnsavedRevision *newRev = self.document.newRevision;
    [newRev setProperties:params.mutableCopy];
    [newRev save:nil];
}


@end
