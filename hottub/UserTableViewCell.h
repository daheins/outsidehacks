//
//  UserTableViewCell.h
//  hottub
//
//  Created by Daniel Heins on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTUser.h"

@interface UserTableViewCell : UITableViewCell

- (id)initWithFrame:(CGRect)frame andUser:(HTUser *)user;

@property (nonatomic, strong) HTUser *user;

@property (nonatomic, strong) UILabel *name;

@end
