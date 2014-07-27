//
//  AccountDetailsViewController.m
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "AccountDetailsViewController.h"

@interface AccountDetailsViewController ()

@property (nonatomic, strong) UILabel *infoLabel;

@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *facebookButton;
@property (nonatomic, strong) UILabel *facebookLabel;

@property (nonatomic, strong) UIButton *twitterButton;
@property (nonatomic, strong) UILabel *twitterLabel;

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
    // Do any additional setup after loading the view.

    self.infoLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 50);
    [self.view addSubview:self.infoLabel];

    self.facebookButton.frame = CGRectMake(self.view.bounds.size.width/2.0, 100, 200, 30);
    self.facebookButton.center = CGPointMake(self.view.bounds.size.width/2.0, 100);
    [self.view addSubview:self.facebookButton];
    self.facebookLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 100);
    self.facebookLabel.hidden = YES;
    [self.view addSubview:self.facebookLabel];

    self.twitterButton.frame = CGRectMake(self.view.bounds.size.width/2.0, 200, 200, 30);
    self.twitterButton.center = CGPointMake(self.view.bounds.size.width/2.0, 150);
    [self.view addSubview:self.twitterButton];
    self.twitterLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 150);
    self.twitterLabel.hidden = YES;
    [self.view addSubview:self.twitterLabel];

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

- (UILabel *)facebookLabel {
    if (!_facebookLabel) {
        _facebookLabel = [[UILabel alloc] init];
        [_facebookLabel setText:@"Facebook Username"];
        [_facebookLabel setTextColor:[UIColor blackColor]];
        [_facebookLabel sizeToFit];
    }
    return _facebookLabel;
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

#pragma mark Selectors

- (void)onFacebookButtonTapped:(UIButton *)button {
    self.facebookButton.hidden = YES;
    self.facebookLabel.hidden = NO;
    self.facebookLabel.text = @"Loading Facebook username...";
    [self.facebookLabel sizeToFit];

    ACAccountStore *facebookAccount = [[ACAccountStore alloc] init];

    ACAccountType *facebookType = [facebookAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];

    NSDictionary *options = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"903614916334450", ACFacebookAppIdKey,
                             [NSArray arrayWithObject:@"email"], ACFacebookPermissionsKey,
                             nil];
    
    [facebookAccount requestAccessToAccountsWithType:facebookType options:options completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSString *username = [[[facebookAccount accounts] lastObject] username];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.facebookLabel.text = [NSString stringWithFormat:@"FB Username: %@", username];
                [self.facebookLabel sizeToFit];
                self.facebookLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 100);
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)onTwitterButtonTapped:(UIButton *)button {
    self.twitterButton.hidden = YES;
    self.twitterLabel.hidden = NO;
    self.twitterLabel.text = @"Loading Twitter username...";
    [self.twitterLabel sizeToFit];

    ACAccountStore *twitterAccount = [[ACAccountStore alloc] init];

    ACAccountType *twitterType = [twitterAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [twitterAccount requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted) {
            NSString *username = [[[twitterAccount accounts] lastObject] username];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.twitterLabel.text = [NSString stringWithFormat:@"Twitter Username: %@", username];
                [self.twitterLabel sizeToFit];
                self.twitterLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 150);
            });
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
