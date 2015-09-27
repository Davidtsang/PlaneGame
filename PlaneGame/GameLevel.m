//
//  GameLevel.m
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import "GameLevel.h"
#import "PGCell.h"

@implementation GameLevel

- (NSSet *)shuffle {
    return [self createInitialCookies];
}

- (NSSet *)createInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    // 1
    for (NSInteger row = 0; row < kNumRows; row++) {
        for (NSInteger column = 0; column < kNumColumns; column++) {
            
            // 2
            NSUInteger cookieType = 0;
            
            // 3
            PGCell *cookie = [self createCookieAtColumn:column row:row withType:cookieType];
            
            // 4
            [set addObject:cookie];
        }
    }
    return set;
}

- (PGCell *)createCookieAtColumn:(NSInteger)column row:(NSInteger)row withType:(NSUInteger)cookieType {
    PGCell *cookie = [[PGCell alloc] init];
    cookie.cellType = cookieType;
    cookie.column = column;
    cookie.row = row;
    _cookies[column][row] = cookie;
    return cookie;
}

- (PGCell *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < kNumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < kNumRows, @"Invalid row: %ld", (long)row);
    
    return _cookies[column][row];
}

@end
