//
//  HTAdvertiser.m
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTAdvertiser.h"

@interface HTAdvertiser () <CBPeripheralDelegate>

#pragma mark - Service Variables
@property (nonatomic, strong) CBUUID *serviceUUID, *usernameUUID, *userIDUUID;
@property (nonatomic, strong) CBMutableCharacteristic *userIDCharacteristic, *usernameCharacteristic;
@property (nonatomic, strong) CBMutableService *service;

#pragma mark - Peripheral Properties

@property (nonatomic, strong) dispatch_queue_t peripheralQueue;
@property (nonatomic, strong) CBPeripheralManager *peripheralManager;

#pragma mark - Current State

@end

@implementation HTAdvertiser


@end
