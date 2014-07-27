//
//  RegistrationViewController.m
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "RegistrationViewController.h"

#import "AccountBasicsViewController.h"
#import "LandingViewController.h"

@interface RegistrationViewController () <LandingViewControllerDelegate>

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation RegistrationViewController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark LandingViewControllerDelegate

- (void)landingViewControllerDidFinish:(LandingViewController *)controller {
    AccountBasicsViewController *abvc = [[AccountBasicsViewController alloc] init];
    [self pushViewController:abvc animated:YES];
}

@end
