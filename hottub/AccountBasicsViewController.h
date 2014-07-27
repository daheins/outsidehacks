//
//  AccountBasicsViewController.h
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountBasicsViewController;

@protocol AccountBasicsViewControllerDelegate <NSObject>

- (void)accountBasicsViewControllerDidFinish:(AccountBasicsViewController *)controller withName:(NSString *)name andImage: (UIImage *)image;
- (void)accountBasicsViewControllerDidGoBack:(AccountBasicsViewController *)controller;

@end

@interface AccountBasicsViewController : UIViewController

@property (nonatomic, weak) id<AccountBasicsViewControllerDelegate> delegate;

@end
