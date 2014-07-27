//
//  AccountDetailsViewController.m
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "AccountDetailsViewController.h"

#define kNumberCenterY 150
#define kFacebookCenterY 200
#define kTwitterCenterY 250

@interface AccountDetailsViewController ()

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UILabel *facebookLabel;
@property (nonatomic, strong) UIActivityIndicatorView *facebookSpinner;
@property (nonatomic, strong) NSString *facebookUsername;

@property (nonatomic, strong) UIButton *twitterButton;
@property (nonatomic, strong) UILabel *twitterLabel;
@property (nonatomic, strong) UIActivityIndicatorView *twitterSpinner;
@property (nonatomic, strong) NSString *twitterUsername;

@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation AccountDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat screenMid = self.view.bounds.size.width/2.0;

    self.infoLabel.center = CGPointMake(screenMid, 100);
    [self.view addSubview:self.infoLabel];

    self.numberButton.frame = CGRectMake(screenMid, kNumberCenterY, 200, 30);
    self.numberButton.center = CGPointMake(screenMid, kNumberCenterY);
    [self.view addSubview:self.numberButton];
    self.numberLabel.center = CGPointMake(screenMid, kNumberCenterY);
    self.numberLabel.hidden = YES;
    [self.view addSubview:self.numberLabel];

    self.facebookButton.frame = CGRectMake(screenMid, kFacebookCenterY, 200, 30);
    self.facebookButton.center = CGPointMake(screenMid, kFacebookCenterY);
    [self.view addSubview:self.facebookButton];
    self.facebookLabel.center = CGPointMake(screenMid, kFacebookCenterY);
    self.facebookLabel.hidden = YES;
    [self.view addSubview:self.facebookLabel];

    self.twitterButton.frame = CGRectMake(screenMid, kTwitterCenterY, 200, 30);
    self.twitterButton.center = CGPointMake(screenMid, kTwitterCenterY);
    [self.view addSubview:self.twitterButton];
    self.twitterLabel.center = CGPointMake(screenMid, kTwitterCenterY);
    self.twitterLabel.hidden = YES;
    [self.view addSubview:self.twitterLabel];

    self.facebookSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.facebookSpinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.facebookSpinner setHidesWhenStopped:YES];
    self.facebookSpinner.center = CGPointMake(screenMid, kFacebookCenterY);
    [self.view addSubview:self.facebookSpinner];

    self.twitterSpinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.twitterSpinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.twitterSpinner setHidesWhenStopped:YES];
    self.twitterSpinner.center = CGPointMake(screenMid, kTwitterCenterY);
    [self.view addSubview:self.twitterSpinner];

    self.finishButton.frame = CGRectMake(screenMid + 20.0, 400, 100, 30);
    [self.view addSubview:self.finishButton];
    
    self.backButton.frame = CGRectMake(screenMid + 20.0, 440, 100, 30);
    [self.view addSubview:self.backButton];
}

#pragma mark Properties

- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        [_infoLabel setText:@"Add your contact info:"];
        [_infoLabel setTextColor:[UIColor blackColor]];
        [_infoLabel sizeToFit];
    }
    return _infoLabel;
}

- (UIButton *)numberButton {
    if (!_numberButton) {
        _numberButton = [[UIButton alloc] init];
        [_numberButton setTitle:@"Add Phone Number" forState:UIControlStateNormal];
        [_numberButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_numberButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_numberButton sizeToFit];

        _numberButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _numberButton.layer.borderWidth = 1.0f;

        [_numberButton addTarget:self action:@selector(onNumberButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _numberButton;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setText:@"Phone Number: 999-999-9999"];
        [_numberLabel setTextColor:[UIColor blackColor]];
        [_numberLabel sizeToFit];
    }
    return _numberLabel;
}

- (UIButton *)facebookButton {
    if (!_facebookButton) {
        _facebookButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_facebookButton setTitle:@"Add Facebook Profile" forState:UIControlStateNormal];
        [_facebookButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_facebookButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_facebookButton sizeToFit];

        _facebookButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _facebookButton.layer.borderWidth = 1.0f;

        [_facebookButton addTarget:self action:@selector(onFacebookButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _facebookButton;
}

- (UILabel *)facebookLabel {
    if (!_facebookLabel) {
        _facebookLabel = [[UILabel alloc] init];
        [_facebookLabel setText:@"Facebook Username"];
        [_facebookLabel setTextColor:[UIColor blackColor]];
        [_facebookLabel sizeToFit];
    }
    return _facebookLabel;
}

- (UIButton *)twitterButton {
    if (!_twitterButton) {
        _twitterButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_twitterButton setTitle:@"Add Twitter Profile" forState:UIControlStateNormal];
        [_twitterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_twitterButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_twitterButton sizeToFit];

        _twitterButton.layer.borderColor = [[UIColor blackColor] CGColor];
        _twitterButton.layer.borderWidth = 1.0f;

        [_twitterButton addTarget:self action:@selector(onTwitterButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twitterButton;
}

- (UILabel *)twitterLabel {
    if (!_twitterLabel) {
        _twitterLabel = [[UILabel alloc] init];
        [_twitterLabel setText:@"Twitter Username"];
        [_twitterLabel setTextColor:[UIColor blackColor]];
        [_twitterLabel sizeToFit];
    }
    return _twitterLabel;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_finishButton setTitle:@"All done!" forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_finishButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_finishButton sizeToFit];
        [_finishButton addTarget:self action:@selector(onFinishButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_backButton setTitle:@"Back" forState:UIControlStateNormal];
        [_backButton sizeToFit];
        [_backButton addTarget:self action:@selector(onBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

#pragma mark Selectors

- (void)onFacebookButtonTapped:(UIButton *)button {
    self.facebookButton.hidden = YES;
    [self.facebookSpinner startAnimating];

    ACAccountStore *facebookAccount = [[ACAccountStore alloc] init];

    ACAccountType *facebookType = [facebookAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"903614916334450", ACFacebookAppIdKey,
                             [NSArray arrayWithObject:@"email"], ACFacebookPermissionsKey,
                             nil];
    
    [facebookAccount requestAccessToAccountsWithType:facebookType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSString *username = [[[facebookAccount accountsWithAccountType:facebookType] lastObject] username];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.facebookLabel.hidden = NO;
                self.facebookLabel.text = [NSString stringWithFormat:@"FB Username: %@", username];
                self.facebookUsername = username;
                [self.facebookLabel sizeToFit];
                self.facebookLabel.center = CGPointMake(self.view.bounds.size.width/2.0, kFacebookCenterY);
                [self.facebookSpinner stopAnimating];
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)onBackButtonTapped:(UIButton *)button {
    [self.delegate accountDetailsViewControllerDidGoBack:self];
}

- (void)onTwitterButtonTapped:(UIButton *)button {
    self.twitterButton.hidden = YES;
    [self.twitterSpinner startAnimating];

    ACAccountStore *twitterAccount = [[ACAccountStore alloc] init];

    ACAccountType *twitterType = [twitterAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [twitterAccount requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSString *username = [[[twitterAccount accountsWithAccountType:twitterType] lastObject] username];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.twitterLabel.hidden = NO;
                self.twitterLabel.text = [NSString stringWithFormat:@"Twitter Username: %@", username];
                self.twitterUsername = username;
                [self.twitterLabel sizeToFit];
                self.twitterLabel.center = CGPointMake(self.view.bounds.size.width/2.0, kTwitterCenterY);
                [self.twitterSpinner stopAnimating];
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)onNumberButtonTapped:(UIButton *)button {
    self.numberButton.hidden = YES;
    self.numberLabel.hidden = NO;
}

- (void)onFinishButtonTapped:(UIButton *)button {
    [self.delegate accountDetailsViewControllerDidFinish:self withFacebook:self.facebookUsername andTwitter:self.twitterUsername];
}

@end
