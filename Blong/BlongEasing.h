//
//  BlongEasing.h
//  Blong
//
//  Created by Will Carlough on 1/11/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface BlongEasing : NSObject

+(SKAction *) easeOutElasticFrom:(CGPoint)start to:(CGPoint)end for:(CGFloat)duration;
+(SKAction *) scaleElastic:(CGFloat)scale for:(CGFloat)duration;
+(SKAction *) rotateElasticFrom:(CGFloat)start to:(CGFloat)end for:(CGFloat)duration;


@end
