//
//  PGPlane.m
//  PlaneGame
//
//  Created by user on 15/2/11.
//  Copyright (c) 2015年 Figapps Studios. All rights reserved.
//

#import "PGPlane.h"

@implementation PGPlane

-(id)initWithRandomDirection
{
    if (self = [super init]) {
        //self.request  = request;
        NSArray *plane;
        
        NSInteger direction = arc4random_uniform(3);
        
        self.planeDirection  = direction    ;
        
        
        if (direction == 0) {
            //left
            
            plane =@[
                     @[@0,@1,@0,@0],
                     @[@0,@1,@0,@1],
                     @[@2,@1,@1,@1],
                     @[@0,@1,@0,@1],
                     @[@0,@1,@0,@0]
                     ];
            
        }else if (direction  == 1) {
            // UP
            
            plane = @[
                      @[@0,@0,@2,@0,@0],
                      @[@1,@1,@1,@1,@1],
                      @[@0,@0,@1,@0,@0],
                      @[@0,@1,@1,@1,@0]
                      ];
            
            
        }else if (direction  == 2) {
            // RIGHT
            
            plane =@[
                     @[@0,@0,@1,@0],
                     @[@1,@0,@1,@0],
                     @[@1,@1,@1,@2],
                     @[@1,@0,@1,@0],
                     @[@0,@0,@1,@0]
                     ];
            
        }else {
            // DOWN
            
            plane =@[
                     
                     @[@0,@1,@1,@1,@0],
                     @[@0,@0,@1,@0,@0],
                     @[@1,@1,@1,@1,@1],
                     @[@0,@0,@2,@0,@0]
                     ];
            
        }
        
        
        self.planeGraph = plane ;
        self.isDestroy =  NO;
        
    }
    
    return self;
    
}
@end
