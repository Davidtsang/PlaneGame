//
//  UIColor+HexString.h
//  OKClock
//
//  Created by user on 15/1/5.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;
+ (UIColor *) colorWithHexString: (NSString *) hexString ;

@end
