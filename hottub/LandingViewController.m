//
//  LandingViewController.m
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "LandingViewController.h"

@interface LandingViewController ()

@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation LandingViewController

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.registerButton.frame = CGRectMake(30.0, 100.0, self.view.bounds.size.width - 60.0, 30.0);
    [self.view addSubview:self.registerButton];
}

#pragma mark Properties

- (UIButton *)registerButton {
    if (!_registerButton) {
        _registerButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_registerButton setTitle:@"Build Your Profile" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_registerButton sizeToFit];
        [_registerButton addTarget:self action:@selector(onRegisterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}

#pragma mark Selectors

- (void)onRegisterButtonTapped:(UIButton *)button {
    [self.delegate landingViewControllerDidFinish:self];
}

@end
