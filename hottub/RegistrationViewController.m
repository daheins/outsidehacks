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
#import "HTUser.h"
#import "LandingViewController.h"

@interface RegistrationViewController () <LandingViewControllerDelegate, AccountBasicsViewControllerDelegate, AccountDetailsViewControllerDelegate>

@property (nonatomic, strong) NSMutableDictionary *userInfo;
@property (nonatomic, strong) UIImage *profileImage;

@end

@implementation RegistrationViewController

- (id)init {
    self = [super init];
    if (self) {
        self.userInfo = [[NSMutableDictionary alloc] init];
    }
    return self;
}

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
    [self.userInfo setObject:name forKey:@"name"];
    self.profileImage = image;
    
    AccountDetailsViewController *advc = [[AccountDetailsViewController alloc] init];
    advc.delegate = self;
    [self pushViewController:advc animated:YES];
}

#pragma mark AccountDetailsViewControllerDelegate

- (void)accountDetailsViewControllerDidFinish:(AccountDetailsViewController *)controller withFacebook:(NSString *)facebook andTwitter:(NSString *)twitter {
    NSNumber *random = [NSNumber numberWithInt:arc4random()];
    [self.userInfo setObject:random forKey:@"id"];
    [self.userInfo setObject:facebook forKey:@"facebook"];
    [self.userInfo setObject:twitter forKey:@"twitter"];
    
    NSLog(@"These are the properties: %@", self.userInfo);
    
    HTUser *user = [HTUser createDefaultUserWithProperties:self.userInfo];
    NSData *imageData = UIImageJPEGRepresentation(self.profileImage, 0.7);
    
    // get MIME type
    NSString *mimeType;
    uint8_t c;
    [imageData getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            mimeType = @"image/jpeg";
        case 0x89:
            mimeType = @"image/png";
        case 0x47:
            mimeType = @"image/gif";
        case 0x49:
        case 0x4D:
            mimeType = @"image/tiff";
    }
    
    [user setAttachmentNamed:@"profilepic" withContentType:mimeType content:imageData];
    [user save:nil];
    
    [self.registrationDelegate registrationViewControllerDidFinish:self];
}

@end
