//
//  BlongBrick.h
//  Blong
//
//  Created by Will Carlough on 9/30/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class BlongMyScene;


@interface BlongBrick : SKSpriteNode
+(BlongBrick *)brickWithScene:(BlongMyScene * )scene fromRandom:(BOOL)random withMotion:(BOOL) motion;
+(CGPoint) calculatePositionFromSlot:(NSString *)slot withNode:(SKNode *)node withScene:(BlongMyScene *)scene;


@end
