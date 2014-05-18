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
@property BOOL tappable;
@property BOOL tapped;
@property NSNumber *blockSlot;
@property int col;
@property int row;

+(BlongBrick *)brickWithScene:(BlongMyScene * )scene fromRandom:(BOOL)random withMotion:(BOOL) motion;
+(CGPoint) calculatePositionFromSlot:(NSNumber *)slot withNode:(SKNode *)node withScene:(BlongMyScene *)scene;
+(BlongBrick *)centeredTappableBrickWithScene:(BlongMyScene *)scene;
-(void)makeTappable;



@end
