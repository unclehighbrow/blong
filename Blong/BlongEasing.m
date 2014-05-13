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
    
    return [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat timeElapsed) {
        float dicks = powf(2,-10*timeElapsed/duration) * sinf((timeElapsed-s)*(2*M_PI)/p);
        float x = xDelta*dicks + xDelta + start.x;
        float y = yDelta*dicks + yDelta + start.y;
        node.position = CGPointMake(x, y);
    }];
}

+(SKAction *) rotateElasticFrom:(CGFloat)start to:(CGFloat)end for:(CGFloat)duration {
    float delta = end - start;
    float p = duration*.3;
    float s = p*.25;
    
    return [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat timeElapsed) {
        float dicks = powf(2,-10*timeElapsed/duration) * sinf((timeElapsed-s)*(2*M_PI)/p);
        node.zRotation = delta*dicks + delta + start;
    }];
}

+(SKAction *) scaleElastic:(CGFloat)scale for:(CGFloat)duration {
    float scaleDelta = scale - 1;
    float p = duration*.3;
    float s = p*.25;
    
    return [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat timeElapsed) {
        float dicks = powf(2,-10*timeElapsed/duration) * sinf((timeElapsed-s)*(2*M_PI)/p);
        [node setScale:scaleDelta*dicks + scaleDelta + 1];
    }];}



//public static function easeOut (t:Number, b:Number, c:Number, d:Number):Number {
//    if ((t/=d) < (1/2.75)) {
//        return c*(7.5625*t*t) + b;
//    } else if (t < (2/2.75)) {
//        return c*(7.5625*(t-=(1.5/2.75))*t + .75) + b;
//    } else if (t < (2.5/2.75)) {
//        return c*(7.5625*(t-=(2.25/2.75))*t + .9375) + b;
//    } else {
//        return c*(7.5625*(t-=(2.625/2.75))*t + .984375) + b;
//    }
//}


@end
