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
#import "BlongThumbHole.h"
#import <GameKit/GameKit.h>
#import "BlongEasing.h"

@interface BlongMyScene : SKScene <SKPhysicsContactDelegate>

-(CGPoint) getRandomOffScreenPointForNode:(SKNode * )node;
-(CGPoint) topLeft;
-(void)removeBrick:(BlongBrick *)brick;
-(BOOL)powerupActive:(NSString *)name;


@property BOOL skipTutorial;

@property BlongPaddle *leftPaddle;
@property BlongPaddle *rightPaddle;
@property SKNode *topWall;
@property SKNode *bottomWall;
@property NSMutableArray *balls;
@property NSMutableArray *bricks;
@property SKLabelNode *scoreLabel;
@property NSMutableOrderedSet *availableBlockSlots;
@property NSNumber *lastBlockCleared;
@property BOOL brokenThrough;
@property int score;
@property int rows;
@property int cols;
@property int level;
@property CGSize brickSize;
@property NSTimer *countdownTimer;
@property NSTimer *cockblockTimer;
@property SKAction *topToMiddle;
@property SKAction *shrinkAway;
@property SKAction *fadeOut;
@property float secondsLeft;
@property int nextCockblock;
@property SKLabelNode *countdownClock;
@property int introduceTappable;

// powerups
@property NSMutableDictionary *threeBallPowerups;
@property NSString *wreckingBall;
@property NSString *doubleBreakthrough;
@property NSString *coolPerson;
@property NSString *goldBricks;
@property NSString *noCountdown;

@property float slowDown;

extern const uint32_t ballCat;
extern const uint32_t paddleCat;
extern const uint32_t wallCat;
extern const uint32_t brickCat;
extern const uint32_t tappableBrickCat;

@end
