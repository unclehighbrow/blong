//
//  BlongMyScene.h
//  Blong
//

//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BlongBall.h"
#import "BlongBrick.h"
#import "BlongPaddle.h"
#import "BlongPauseButton.h"

@interface BlongMyScene : SKScene <SKPhysicsContactDelegate> {
    
}

@property BlongPaddle *leftPaddle;
@property BlongPaddle *rightPaddle;
@property NSMutableArray *balls;
@property NSMutableArray *bricks;
@property SKLabelNode *scoreLabel;
@property NSMutableArray *availableBlockSlots;
@property int score;
@property int rows;
@property int cols;
@property int level;
@property NSTimeInterval nextCockBlock;

extern const uint32_t ballCat;
extern const uint32_t paddleCat;
extern const uint32_t wallCat;
extern const uint32_t brickCat;

@end
