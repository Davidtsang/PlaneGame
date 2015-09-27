//
//  GameLevel.h
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kNumColumns 10
#define kNumRows 10

@class PGCell;

@interface GameLevel : NSObject
{
    PGCell *_cookies[kNumColumns][kNumRows];
}

@end
