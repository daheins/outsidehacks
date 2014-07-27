//
//  RegistrationViewController.m
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "RegistrationViewController.h"

#import "AccountBasicsViewController.h"
#import "AccountDetailsViewController.h"
#import "LandingViewController.h"

@interface RegistrationViewController () <LandingViewControllerDelegate, AccountBasicsViewControllerDelegate, AccountDetailsViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) UIImage *profileImage;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;

    LandingViewController *landingVC = [[LandingViewController alloc] init];
    landingVC.delegate = self;

    [self pushViewController:landingVC animated:NO];
}

#pragma mark LandingViewControllerDelegate

- (void)landingViewControllerDidFinish:(LandingViewController *)controller {
    AccountBasicsViewController *abvc = [[AccountBasicsViewController alloc] init];
    abvc.delegate = self;
    [self pushViewController:abvc animated:YES];
}

#pragma mark AccountBasicsViewControllerDelegate

- (void)accountBasicsViewControllerDidFinish:(AccountBasicsViewController *)controller withName:(NSString *)name andImage:(UIImage *)image {
    [self.userInfo setValue:name forKey:@"name"];
    self.profileImage = image;
    
    AccountDetailsViewController *advc = [[AccountDetailsViewController alloc] init];
    advc.delegate = self;
    [self pushViewController:advc animated:YES];
}

#pragma mark AccountDetailsViewControllerDelegate

- (void)accountDetailsViewControllerDelegateDidFinish:(AccountDetailsViewController *)controller {
    return;
}

@end
