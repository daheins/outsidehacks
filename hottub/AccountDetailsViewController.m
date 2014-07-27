//
//  AccountDetailsViewController.m
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "AccountDetailsViewController.h"

@interface AccountDetailsViewController ()

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
    ACAccountStore *account = [[ACAccountStore alloc] init];
    
    ACAccountType *twitterType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError *error) {
        NSLog(@"%@", [[[account accounts] lastObject] username]);
    }];

    ACAccountType *facebookType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [account requestAccessToAccountsWithType:facebookType options:nil completion:^(BOOL granted, NSError *error) {
        NSLog(@"%@", [[[account accounts] lastObject] username]);
    }];

    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
