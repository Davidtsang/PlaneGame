//
//  GameCookie.h
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SpiritView.h"

@interface PGCell : NSObject

@property (assign, nonatomic) NSInteger column;
@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSUInteger cellType;
@property (strong, nonatomic) SpiritView *view;



@end
