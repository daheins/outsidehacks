//
//  ListFriendsViewController.m
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "ListFriendsViewController.h"
#import "FriendTableViewCell.h"

@interface ListFriendsViewController ()

@property (nonatomic, strong) UITableView *friendsList;

@end

@implementation ListFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view addSubview:self.friendsList];
    [self updateFriendsList];

}

- (void)updateFriendsList {
    FriendTableViewCell *cell = [[FriendTableViewCell alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];

    [_friendsList insertSubview:cell atIndex:0];
}

#pragma mark Properties

- (UITableView *)friendsList {
    if (!_friendsList) {
        _friendsList = [[UITableView alloc] init];
    }
    return _friendsList;
}

@end
