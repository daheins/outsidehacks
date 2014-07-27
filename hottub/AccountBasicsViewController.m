//
//  AccountBasicsViewController.m
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AccountBasicsViewController.h"

#import "UIImage+Resize.h"

#define kProfilePictureSize 200.0

@interface AccountBasicsViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *profilePictureButton;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UITextField *nameField;
@property (nonatomic, strong) UIButton *backButton;
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
    
    self.titleLabel.center = CGPointMake(self.view.bounds.size.width/2.0, 100.0);
    [self.view addSubview:self.titleLabel];
    
    self.profilePictureButton.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0 + 50.0);
    [self.view addSubview:self.profilePictureButton];
    
    self.nameField.frame = CGRectMake(20.0, self.profilePictureButton.frame.origin.y - 60.0, self.nameField.frame.size.width, self.nameField.frame.size.height);
    [self.view addSubview:self.nameField];

    self.continueButton.frame = CGRectMake(30.0, self.view.bounds.size.height - 100, self.view.bounds.size.width - 60.0, 30.0);
    [self.view addSubview:self.continueButton];
    self.continueButton.enabled = NO;
    
    self.backButton.frame = CGRectMake(10.0, self.view.bounds.size.height - 70, self.view.bounds.size.width - 60.0, 30.0);
    [self.view addSubview:self.backButton];
}

#pragma mark Properties

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"add your picture and your name"];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIButton *)profilePictureButton {
    if (!_profilePictureButton) {
        _profilePictureButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, kProfilePictureSize, kProfilePictureSize)];
        [[_profilePictureButton layer] setCornerRadius:kProfilePictureSize/2.0];
        [[_profilePictureButton layer] setBorderWidth:2.0f];
        [[_profilePictureButton layer] setBorderColor:[UIColor grayColor].CGColor];
        [_profilePictureButton addTarget:self
                                  action:@selector(onProfilePictureButtonTapped:)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    return _profilePictureButton;
}

- (UIImageView *)profileImageView {
    if (!_profileImageView) {
        _profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, kProfilePictureSize, kProfilePictureSize)];
        [[_profileImageView layer] setCornerRadius:kProfilePictureSize/2.0];
        [[_profileImageView layer] setMasksToBounds:YES];
    }
    return _profileImageView;
}

- (UITextField *)nameField {
    if (!_nameField) {
        _nameField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.bounds.size.width - 40.0, 30.0)];
        [_nameField setPlaceholder:@"Your Name"];
        [[_nameField layer] setBorderWidth:2.0f];
        [[_nameField layer] setBorderColor:[UIColor grayColor].CGColor];
        _nameField.delegate = self;
    }
    return _nameField;
}

- (UIButton *)continueButton {
    if (!_continueButton) {
        _continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_continueButton setTitle:@"Next" forState:UIControlStateNormal];
        [_continueButton sizeToFit];
        [_continueButton addTarget:self action:@selector(onContinueButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _continueButton;
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

- (void)updateContinueButton {
    self.continueButton.enabled = [self.nameField hasText] > 0 && self.profileImageView.image;
}

#pragma mark Selectors

- (void)onProfilePictureButtonTapped:(UIButton *)button {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)onBackButtonTapped:(UIButton *)button {
    [self.delegate accountBasicsViewControllerDidGoBack:self];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameField) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self updateContinueButton];
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = [UIImage resizeImage:chosenImage newSize:CGSizeMake(kProfilePictureSize, kProfilePictureSize)];
    
    self.profileImageView.center = CGPointMake(self.profilePictureButton.center.x, self.profilePictureButton.center.y);
    [self.view addSubview:self.profileImageView];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self updateContinueButton];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)onContinueButtonTapped:(UIButton *)button {
    [self.delegate accountBasicsViewControllerDidFinish:self withName:self.nameField.text andImage:self.profileImageView.image];
}

@end
