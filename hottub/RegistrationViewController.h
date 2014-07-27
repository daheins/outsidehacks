//
//  RegistrationViewController.h
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistrationViewController;

@protocol RegistrationViewControllerDelegate <NSObject>

- (void)registrationViewControllerDidFinish:(RegistrationViewController *)controller;

@end

@interface RegistrationViewController : UINavigationController

@property (nonatomic, weak) id<RegistrationViewControllerDelegate> registrationDelegate;

@end
