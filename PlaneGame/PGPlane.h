//
//  PGPlane.h
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGPlane : NSObject

@property(assign,nonatomic)NSInteger planeDirection;
@property(strong,nonatomic)NSArray *planeGraph;

@property(assign,nonatomic)NSInteger atRow;
@property(assign,nonatomic)NSInteger atColumn;
@property(assign,nonatomic)BOOL isDestroy;
-(id)initWithRandomDirection;

@end
