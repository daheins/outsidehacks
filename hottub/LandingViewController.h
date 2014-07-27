//
//  LandingViewController.h
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LandingViewController;

@protocol LandingViewControllerDelegate <NSObject>

- (void)landingViewControllerDidFinish:(LandingViewController *)controller;

@end

@interface LandingViewController : UIViewController

@property (nonatomic, weak) id<LandingViewControllerDelegate> delegate;

@end
