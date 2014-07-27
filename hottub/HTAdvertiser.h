//
//  HTAdvertiser.h
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTAdvertiser : NSObject <CBPeripheralManagerDelegate>

@property (nonatomic, strong) CBMutableCharacteristic *userIDCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *usernameCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *twitterCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *facebookCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *emailCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *phoneCharacteristic;
@property (nonatomic, strong) CBMutableCharacteristic *avatarCharacteristic;

+ (instancetype)sharedInstance;

@end
