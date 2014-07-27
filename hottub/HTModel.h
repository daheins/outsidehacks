//
//  HTModel.h
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <CouchbaseLite/CouchbaseLite.h>

@interface HTModel : CBLModel

@property (nonatomic, strong) NSString *type;

- (NSString *) docID;

@end