//
//  UserTableViewCell.m
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import "UserTableViewCell.h"
#import "HTUser.h"

@implementation UserTableViewCell

- (id)initWithFrame:(CGRect)frame andUser:(HTUser *)user {
    if (self = [super initWithFrame:frame]) {
        self.user = user;

        self.name.center = CGPointMake(70, 20);
        [self addSubview:self.name];
    }
    return self;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        [_name setText:[self.user name]];
        [_name sizeToFit];
    }
    return _name;
}

@end
