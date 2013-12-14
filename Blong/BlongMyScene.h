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
#import "BlongGameOverScene.h"
#import "Score.h"
#import "BlongThumbHole.h"

@interface BlongMyScene : SKScene <SKPhysicsContactDelegate> {
    
}

@property BlongPaddle *leftPaddle;
@property BlongPaddle *rightPaddle;
@property NSMutableArray *balls;
@property NSMutableArray *bricks;
@property SKLabelNode *scoreLabel;
@property NSMutableArray *availableBlockSlots;
@property NSString *lastBlockCleared;
@property BOOL brokenThrough;
@property int score;
@property int rows;
@property int cols;
@property int level;
@property CGSize brickSize;
@property NSTimeInterval nextCockBlock;
@property NSTimer *countdownTimer;
@property SKAction *topToMiddle;
@property SKAction *wait;
@property SKAction *shrinkAway;
@property int secondsLeft;

extern const uint32_t ballCat;
extern const uint32_t paddleCat;
extern const uint32_t wallCat;
extern const uint32_t brickCat;

@end
