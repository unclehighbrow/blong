//
//  BlongEasing.m
//  Blong
//
//  Created by Will Carlough on 1/11/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import "BlongEasing.h"

@implementation BlongEasing

+(SKAction *) easeOutElasticFrom:(CGPoint)start to:(CGPoint)end for:(CGFloat)duration {
    float xDelta = end.x - start.x;
    float yDelta = end.y - start.y;
    float p = duration*.3;
    float s = p*.25;
    
    SKAction *ret = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat timeElapsed) {
        float dicks = powf(2,-10*timeElapsed/duration) * sinf((timeElapsed-s)*(2*M_PI)/p);
        float x = xDelta*dicks + xDelta + start.x;
        float y = yDelta*dicks + yDelta + start.y;
        node.position = CGPointMake(x, y);
    }];
    
    return ret;
}

@end
