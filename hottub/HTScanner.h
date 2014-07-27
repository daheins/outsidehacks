//
//  HTScanner.h
//  hottub
//
//  Created by Cristian Monterroza on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "HTUserManager.h"

@interface HTScanner : NSObject <HTCapabilityProvider, CBCentralManagerDelegate, CBPeripheralDelegate>

+ (instancetype)sharedInstance;

@end
