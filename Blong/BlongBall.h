//
//  BlongBall.h
//  Blong
//
//  Created by Will Carlough on 7/13/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BlongEasing.h"
@class BlongMyScene;

@interface BlongBall : SKSpriteNode 
+(BlongBall *) ballOnLeft:(BOOL) left withScene:(BlongMyScene *) scene;
+(BlongBall *) ballWithX:(int)X withY:(int)y withScene:(BlongMyScene *) scene;
+(void) shootBallAtPoint:(CGPoint)point withScene:(BlongMyScene *)scene;
@end
