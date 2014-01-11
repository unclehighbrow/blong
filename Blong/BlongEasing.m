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
    
    SKAction *ret = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat timeElapsed) {
        float ax = xDelta;
        float ay = yDelta;
        float x,y;
        

        if ((timeElapsed/=duration)==1) {
            node.position = CGPointMake(start.x + xDelta,start.y + yDelta);
        } else {
            if (xDelta == 0.0) {
                x = start.x;
            } else {
                float sx;
                if (ax < fabsf(xDelta)) {
                    ax = xDelta;
                    sx = p/4;
                } else {
                    sx = p/(2*M_PI) * asinf(xDelta/ax);
                }
                x = ax*powf(2,-10*timeElapsed) * sinf((timeElapsed*duration-sx)*(2*M_PI)/p) + xDelta + start.x;
            }
            
            if (yDelta == 0.0) {
                y = start.y;
            } else {
                float sy;
                if (ay < fabsf(yDelta)) {
                    ay = yDelta;
                    sy = p/4;
                } else {
                    sy = p/(2*M_PI) * asinf(yDelta/ay);
                }

                y = ay*powf(2,-10*timeElapsed) * sinf((timeElapsed*duration-sy)*(2*M_PI)/p) + yDelta + start.y;
            }
            
            node.position = CGPointMake(x, y);
        }
    }];
    
    return ret;
}

@end
