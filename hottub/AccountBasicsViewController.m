//
//  AccountBasicsViewController.m
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "AccountBasicsViewController.h"

@interface AccountBasicsViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *continueButton;

@end

@implementation AccountBasicsViewController

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
    
    self.titleLabel.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    [self.view addSubview:self.titleLabel];

    self.continueButton.frame = CGRectMake(30.0, self.view.bounds.size.height - 100, self.view.bounds.size.width - 60.0, 30.0);
    [self.view addSubview:self.continueButton];
}

#pragma mark Properties

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"Account Basics View"];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_continueButton setTitle:@"Add account details" forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_continueButton sizeToFit];
        [_continueButton addTarget:self action:@selector(onContinueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueButton;
}

#pragma mark Selectors

- (void)onContinueButtonTapped:(UIButton *)button {
    [self.delegate accountBasicsViewControllerDelegateDidFinish:self];
}

@end
