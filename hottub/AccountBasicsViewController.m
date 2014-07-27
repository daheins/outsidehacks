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
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setText:@"Account Basics View"];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

@end
