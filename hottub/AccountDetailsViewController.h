//
//  AccountDetailsViewController.h
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@class AccountDetailsViewController;

@protocol AccountDetailsViewControllerDelegate <NSObject>

- (void)accountDetailsViewControllerDidFinish:(AccountDetailsViewController *)controller withFacebook:(NSString *)facebook andTwitter:(NSString *)twitter;

@end

@interface AccountDetailsViewController : UIViewController

@property (nonatomic, weak) id<AccountDetailsViewControllerDelegate> delegate;

@end