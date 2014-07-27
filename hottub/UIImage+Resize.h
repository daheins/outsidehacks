//
//  UIImage+Resize.h
//  hottub
//
//  Created by Wei-Wei Lu on 7/26/14.
//  Copyright (c) 2014 daheins. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)resizeImage:(UIImage*)image newSize:(CGSize)newSize;

@end
