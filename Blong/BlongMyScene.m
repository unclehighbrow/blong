//
//  BlongMyScene.m
//  Blong
//
//  Created by Will Carlough on 7/7/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongMyScene.h"
#import "BlongGameCenterHelper.h"


@implementation BlongMyScene

const uint32_t ballCat = 0x1 << 1;
const uint32_t paddleCat = 0x1 << 2;
const uint32_t wallCat = 0x1 << 3;
const uint32_t brickCat = 0x1 << 4;
const uint32_t tappableBrickCat = 0x1 << 5;

static int minTappable = 1;
static int incTappable = 2;
static int maxTappable = 10;

float baseMaxVelocity = 285;
float maxMaxVelocity = 600;
float incMaxVelocity = 7;
float maxYVelocity;
float levelVelocity;

int bonusCountdown = 10;

// for starting
bool started;
bool touchedLeft;
bool touchedRight;
bool isBonusLevel = NO;

// sounds for preloading
SKAction *explosion;
SKAction *breakthrough;
SKAction *readySound;
SKAction *steadySound;
SKAction *blongSound;
SKAction *ballsSound;
SKAction *bricksSound;


SKAction *addOne;

int scoreToAdd;

// leveling
// bigger
int baseRows = 5;
int maxRows = 10;

int baseCols = 3;
int maxCols = 5;
int incCols = 5;

// smaller
int baseCockBlock = 10;
int minCockBlock = 5;
int incCockBlock = 4;

int baseCountdown = 60;
int minCountdown = 10;
int incCountdown = 2;

int bonusLevelEvery = 3;

NSArray *bips;
NSArray *bops;
NSMutableArray *threeBallPowerups;

CGPoint textEnd;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        levelVelocity = [self calcLevelVelocity];
        maxYVelocity = levelVelocity *.7;
        _introduceTappable = 4;
        _slowDown = 0;
        _doubleBreakthrough = NO;
        _wreckingBall = NO;
        _goldBricksMakeBalls = NO;
        _noCountdown = NO;
        threeBallPowerups = [NSMutableArray arrayWithArray:@[@"wrecking_ball", @"double_breakthrough", @"cool_person", @"gold_bricks", @"no_countdown"]];
        
        // score
        _score = 0;
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"]; // "MICR Encoding"
        _scoreLabel.text = @"00000";
        _scoreLabel.fontSize = 25;
        _scoreLabel.fontColor = [SKColor whiteColor];
        _scoreLabel.position = CGPointMake(0, 0);
        _scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:_scoreLabel];
        scoreToAdd = 0;

        _availableBlockSlots = [NSMutableOrderedSet orderedSet];

        self.backgroundColor = [SKColor blackColor];
        
        // paddles
        _leftPaddle = [BlongPaddle paddle:@"left_paddle"];
        _leftPaddle.position = CGPointMake(3.5 * _leftPaddle.frame.size.width, self.frame.size.height); // CGRectGetMidY(self.frame)
        [self addChild:_leftPaddle];
        _rightPaddle = [BlongPaddle paddle:@"right_paddle"];
        _rightPaddle.position = CGPointMake(self.frame.size.width - 3.5*_rightPaddle.frame.size.width, 1);
        [self addChild:_rightPaddle];
        
        // bricks and balls holders
        _bricks = [NSMutableArray array];
        _balls = [NSMutableArray array];
        _level = 1;
        

        // physics and walls
        _topWall = [SKNode node];
        _topWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0,0) toPoint:CGPointMake(self.frame.size.width,0)];
        _topWall.physicsBody.restitution = .5;
        _topWall.physicsBody.categoryBitMask = wallCat;
        _topWall.physicsBody.friction = 0;
        _topWall.position = CGPointMake(0, self.frame.size.height);
        [self addChild:_topWall];
        
        _bottomWall = [SKNode node];
        _bottomWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0,0) toPoint:CGPointMake(self.frame.size.width,0)];
        _bottomWall.physicsBody.restitution = .5;
        _bottomWall.physicsBody.categoryBitMask = wallCat;
        _bottomWall.physicsBody.friction = NO;
        _bottomWall.position = CGPointMake(0,0);
        [self addChild:_bottomWall];
        
        BOOL invincible = NO;
        if (invincible) {
            SKNode *leftWall = [SKNode node];
            leftWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0,0) toPoint:CGPointMake(0,self.frame.size.height)];
            leftWall.physicsBody.restitution = .5;
            leftWall.physicsBody.categoryBitMask = wallCat;
            leftWall.physicsBody.friction = 0;
            leftWall.position = CGPointMake(0, 0);
            [self addChild:leftWall];
            
            SKNode *rightWall = [SKNode node];
            rightWall.physicsBody = [SKPhysicsBody bodyWithEdgeFromPoint:CGPointMake(0,0) toPoint:CGPointMake(0,self.frame.size.height)];
            rightWall.physicsBody.restitution = .5;
            rightWall.physicsBody.categoryBitMask = wallCat;
            rightWall.physicsBody.friction = 0;
            rightWall.position = CGPointMake(self.frame.size.width, 0);
            [self addChild:rightWall];
        }
        
        
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.speed = 1;
        
        // pause button
        [BlongPauseButton pauseButtonWithScene:self];
        
        // SKActions
        CGPoint topStart = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height);
        textEnd = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        _topToMiddle = [BlongEasing easeOutElasticFrom:topStart to:textEnd for:.5];
        _shrinkAway = [SKAction scaleTo:0 duration:.3];
        _fadeOut = [SKAction fadeOutWithDuration:2];
        addOne = [SKAction sequence:@[[SKAction runBlock:^{
            _scoreLabel.text = [NSString stringWithFormat:@"%05d", _score];
        }], [SKAction waitForDuration:.01]]];
        
        // sounds
        bips = @[
                          [SKAction playSoundFileNamed:@"bip1.wav" waitForCompletion:NO],
                          [SKAction playSoundFileNamed:@"bip2.wav" waitForCompletion:NO],
                          [SKAction playSoundFileNamed:@"bip3.wav" waitForCompletion:NO],
                          [SKAction playSoundFileNamed:@"bip4.wav" waitForCompletion:NO],
                          [SKAction playSoundFileNamed:@"bip5.wav" waitForCompletion:NO]
                          ];
        bops = @[
                         [SKAction playSoundFileNamed:@"bop1.wav" waitForCompletion:NO],
                         [SKAction playSoundFileNamed:@"bop2.wav" waitForCompletion:NO],
                         [SKAction playSoundFileNamed:@"bop3.wav" waitForCompletion:NO],
                         [SKAction playSoundFileNamed:@"bop4.wav" waitForCompletion:NO],
                         [SKAction playSoundFileNamed:@"bop5.wav" waitForCompletion:NO]
                 ];
        explosion = [SKAction playSoundFileNamed:@"explode.wav" waitForCompletion:NO];
        breakthrough = [SKAction playSoundFileNamed:@"breakthrough.wav" waitForCompletion:NO];
        readySound = [SKAction playSoundFileNamed:@"ready.wav" waitForCompletion:NO];
        steadySound = [SKAction playSoundFileNamed:@"steady.wav" waitForCompletion:NO];
        blongSound = [SKAction playSoundFileNamed:@"blong.wav" waitForCompletion:NO];
        ballsSound = [SKAction playSoundFileNamed:@"balls.wav" waitForCompletion:NO];
        bricksSound = [SKAction playSoundFileNamed:@"bricks.wav" waitForCompletion:NO];
        
        self.paused = NO;
    }
    return self;
}

-(void) bip {
    [self runAction:[bips objectAtIndex:(arc4random() % [bips count])]];
}

-(void) bop {
    [self runAction:[bops objectAtIndex:(arc4random() % [bops count])]];
}


-(void) didMoveToView:(SKView *)view {
    BOOL skipTutorial = NO;
    if (skipTutorial) {
        touchedLeft = YES;
        touchedRight = YES;
        started = YES;
        [_leftPaddle getPhysical];
        [_rightPaddle getPhysical];
        self.physicsWorld.speed = 0;
        //[self bonusLevel];
        _level = 3;
    } else {
        touchedLeft = NO;
        touchedRight = NO;
        started = NO;
        self.paused = NO;
    }
    [self throwInPaddles];
    [self startLevel];

}

-(void)throwInPaddles {
    [self runAction:[SKAction sequence:@[
                                         [SKAction waitForDuration:.5],
                                         [SKAction runBlock:^{
                                            CGVector leftVector = CGVectorMake(0, -5000);
                                            [[_leftPaddle physicsBody] applyForce:leftVector];
                                            CGVector rightVector = CGVectorMake(0, 5000);
                                            [[_rightPaddle physicsBody] applyForce:rightVector];
                                            }]
                                         ]]];
}

-(void)startLevel {
    _brokenThrough = NO;
    if (_level == _introduceTappable) {
        _rows = 1;
        _cols = 1;
    } else if (_level == 1) {
        _rows = baseRows + 1;
        _cols = baseCols - 1;
    } else {
        _rows = MIN(baseRows + _level, maxRows);
        _cols = MIN(baseCols + floor(_level / incCols), maxCols);
    }

    _bricks = [NSMutableArray array]; // this is to stop weirdness coming out of level 2. shouldn't be necessary
    _availableBlockSlots = [NSMutableOrderedSet orderedSet];
    
    for (int i = 0; i < _rows*_cols; i++) {
        [_availableBlockSlots addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < _cols; i++) {
        NSMutableArray *col = [NSMutableArray arrayWithCapacity:_rows];
        for (int j = 0; j < _rows; j++) {
            [col addObject:[NSNull null]];
        }
        [_bricks addObject:col];
    }
    
    if (_level == 1) {
        for (int i = 0; i<_rows; i++) {
            for (int j = 0; j<_cols; j++) {
                [BlongBrick brickWithScene:self fromRandom:NO withMotion:NO];
            }
        }
        return;
    }
    if (_level == _introduceTappable) {
        [BlongBrick centeredTappableBrickWithScene:self];
        _brokenThrough = YES; // the breakthrough thing accesses uninitialized arrays        
        return;
    }

    // ready
    SKLabelNode *ready = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    ready.text = @"READY";
    ready.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height + ready.frame.size.height/2);
    [self addChild:ready];
    [ready runAction:[SKAction sequence:@[[SKAction waitForDuration:1], _topToMiddle, _shrinkAway]]];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1.1], readySound]]];
    
    // balls
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1.5],
                                         [SKAction runBlock:^{
                                                                        [BlongBall ballOnLeft:YES withScene:self];
                                                                        [BlongBall ballOnLeft:NO withScene:self];}]
                                         ]]];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1.6], ballsSound]]];
    
    
    // steady
    SKLabelNode *steady = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    steady.text = @"STEADY";
    steady.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height + ready.frame.size.height/2);
    steady.zPosition = -1;
    [self addChild:steady];
    [steady runAction:[SKAction sequence:@[[SKAction waitForDuration:2.1], _topToMiddle, _shrinkAway]]];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:2.2], steadySound]]];

    
    // bricks
    SKAction *moveInBricks;
    if (isBonusLevel) {
        moveInBricks = [SKAction runBlock:^{
            for (int i = 0; i < 20; i++) {
                [BlongBall ballToRandomPointWithScene:self];
            }
        }];
    } else {
        moveInBricks = [SKAction runBlock:^{
            for (int i = 0; i<_rows; i++) {
                for (int j = 0; j<_cols; j++) {
                    [BlongBrick brickWithScene:self fromRandom:YES withMotion:YES];
                }
            }
            if (_level > _introduceTappable) {
                int tappableNum = MIN(minTappable + floor((_level - _introduceTappable) / incTappable), maxTappable);
                for (int i = 0; i < tappableNum; i++) {
                    BlongBrick *brick = (BlongBrick *) [[_bricks objectAtIndex:arc4random() % _cols] objectAtIndex:arc4random() % _rows];
                    [brick makeTappable];
                }
            }            
            [_leftPaddle shrink];
            [_rightPaddle shrink];
        }];
    }
    
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:2.6], moveInBricks, [SKAction waitForDuration:.3]]]];
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:2.7], bricksSound]]];


    // blong
    SKSpriteNode *blong = [SKSpriteNode spriteNodeWithImageNamed:@"blong_background"];
    SKAction *startPhysics = [SKAction runBlock:^{
        self.physicsWorld.speed = 1;
        if (isBonusLevel) {
            [self startCountdown];
        }
    }];
    [blong setAlpha:0];
    SKAction *fadeIn = [SKAction fadeAlphaTo:.2 duration:0];

    [blong runAction:[SKAction sequence:@[[SKAction waitForDuration:3.3], startPhysics, blongSound, fadeIn, _fadeOut]]];
    blong.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:blong];
    
    if (_cockblockTimer.isValid) {
        [_cockblockTimer invalidate];
    }
    if (!isBonusLevel) {
        _cockblockTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(incrementCockblock:) userInfo:nil repeats:YES];
    }

}

-(void)incrementCockblock:(NSTimer *)timer {
    if (!self.paused) {
        _nextCockblock++;
        if (_nextCockblock >= MAX(baseCockBlock + floor(_level / incCockBlock), minCockBlock)) {
            _nextCockblock = 0;
            [BlongBrick brickWithScene:self fromRandom:NO withMotion:YES];
        }
    }
}

-(void)updateScore:(int) pointsAdded {
    scoreToAdd += pointsAdded;
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    if (self.physicsWorld.speed > 0) {
        SKPhysicsBody *ball, *secondBody;
        if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
            ball = contact.bodyA;
            secondBody = contact.bodyB;
        } else {
            ball = contact.bodyB;
            secondBody = contact.bodyA;
        }
        
        // TODO: make this less shitty
        if (secondBody.categoryBitMask & paddleCat) {
            float relativeIntersectY = ball.node.position.y - secondBody.node.position.y;
            
            if ([secondBody.node.name isEqual:@"left_paddle"]) { // hitting the back doesn't count
                if (contact.contactPoint.x < secondBody.node.frame.origin.x) {
                    return;
                }
            } else {
                if (contact.contactPoint.x > secondBody.node.frame.origin.x) {
                    return;
                }
            }

            
    //        this should be cooler and preserve momentum, but doesn't and ends up with nans
    //        NSLog(@"relative intersect: %f", relativeIntersectY);
    //        float newY = 200 * relativeIntersectY/secondBody.node.frame.size.height;
    //        float totalVelocity = sqrtf((ball.velocity.dx * ball.velocity.dx) + (ball.velocity.dy * ball.velocity.dy));
    //        NSLog(@"old total: %f, x,y: %f,%f", totalVelocity, ball.velocity.dx, ball.velocity.dy);
    //        float newX = sqrtf((totalVelocity * totalVelocity) - (newY * newY));
    //        if (ball.velocity.dx > 0) {
    //            newX = -newX;
    //        }
    //        ball.velocity = CGVectorMake(newX, newY);
    //        float newTotalVelocity = sqrtf((ball.velocity.dx * ball.velocity.dx) + (ball.velocity.dy * ball.velocity.dy));
    //        NSLog(@"new total: %f, x,y: %f,%f", newTotalVelocity, newX, newY);

            if (fabsf(ball.velocity.dy) < 500) {
                float yVelocity = levelVelocity * relativeIntersectY/secondBody.node.frame.size.height * 2;
                CGVector velocity = [self calculateVelocityFromY:yVelocity];
                BOOL right = ball.node.position.x > CGRectGetMidX(self.frame);
                if (right) {
                    velocity.dx = -velocity.dx;
                }
                ball.velocity = velocity;
            }
            [self bip];
        }
        
        // this is a check to see if it's moving too slowly horizontally, and give it a little push
        if (secondBody.categoryBitMask & wallCat) {
            if (fabsf(ball.velocity.dx) < 30) {
                if (ball.velocity.dx < 0) {
                    [ball applyImpulse:CGVectorMake(-1, 0)];
                } else {
                    [ball applyImpulse:CGVectorMake(1, 0)];
                }
            }
            
        }
        
        if (secondBody.categoryBitMask & brickCat) {
            BlongBrick *brick = (BlongBrick *)secondBody.node;
            [self removeBrick:brick];
            [self bop];
        }
        
        if (secondBody.categoryBitMask & tappableBrickCat) {
            // TODO: make cool sound and animation
            //BlongBrick *brick = (BlongBrick *)secondBody.node;
            
        }
    }
}

-(void)removeBrick:(BlongBrick *)brick {

    [self updateScore:1];
    SKAction *shrink = [SKAction scaleTo:0 duration:.2];
    SKAction *removeFromBricks = [SKAction runBlock:^{
        _lastBlockCleared = brick.blockSlot;
        [_availableBlockSlots addObject:_lastBlockCleared];
        [[_bricks objectAtIndex:brick.col] replaceObjectAtIndex:brick.row withObject:[NSNull null]];
        [self checkBreakthrough];
    }];
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    // also explode it
    SKSpriteNode *explodeBrick = [SKSpriteNode spriteNodeWithImageNamed:@"brick6"];
    explodeBrick.yScale = brick.yScale;
    explodeBrick.position = brick.position;
    explodeBrick.color = [brick color];
    [self addChild:explodeBrick];
    SKAction *explode = [SKAction sequence:@[[SKAction group:@[[SKAction scaleTo:1.5 duration:.2], [SKAction fadeAlphaTo:0 duration:.2]]], removeFromParent]];
    [explodeBrick runAction:explode];
    
    [brick runAction: [SKAction sequence: @[shrink, removeFromBricks, removeFromParent]]];
    
}

-(void)checkBreakthrough {
    if (_level == _introduceTappable) {
        [self newLevel];
    }
    if (!_brokenThrough) {
        for (int i = 0; i < _rows; i++) {
            bool justBrokeThrough = YES;
            for (int j = 0; j < _cols; j++) {
                if (![_availableBlockSlots containsObject:[NSNumber numberWithInt:i*_cols + j]]) {
                    justBrokeThrough = NO;
                    break;
                }
            }
            if (justBrokeThrough) {
                // if they haven't touched the other paddle yet, we need to make them static
                [_leftPaddle getPhysical];
                [_rightPaddle getPhysical];
                
                SKLabelNode *breakthroughLabel = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
                breakthroughLabel.text = @"BREAKTHROUGH";
                breakthroughLabel.position = CGPointMake(CGRectGetMidX(self.frame), 0);
                breakthroughLabel.fontColor = [SKColor blueColor];
                breakthroughLabel.zPosition = 1;
                [self addChild:breakthroughLabel];
                [breakthroughLabel runAction:[SKAction sequence:@[[SKAction waitForDuration:.6], _shrinkAway]]];
                [self runAction:breakthrough];
                CGPoint lastBrickPoint = [BlongBrick calculatePositionFromSlot:_lastBlockCleared withNode:[_balls objectAtIndex:0] withScene:self];
                BlongBall *newBall = [BlongBall ballWithX:lastBrickPoint.x withY:lastBrickPoint.y withScene:self];
                if (_doubleBreakthrough) {
                    [BlongBall ballWithX:(lastBrickPoint.x + newBall.frame.size.width) withY:lastBrickPoint.y withScene:self];
                }
                [self makeParticleAt:lastBrickPoint];
                _brokenThrough = YES;
                break;
            }
        }
    }
}

-(void)removeBall:(BlongBall *)ball {
    [_balls removeObject:ball];
    [ball runAction:[SKAction removeFromParent]];
}

-(CGVector)calculateVelocityFromY:(float) yVelocity {
    if (yVelocity >= maxYVelocity) {
        yVelocity = maxYVelocity;
    }
    if (yVelocity <= -maxYVelocity) {
        yVelocity = -maxYVelocity;
    }
    float xVelocity = sqrtf(powf(levelVelocity, 2) - powf(yVelocity, 2));
    return CGVectorMake(xVelocity, yVelocity);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touches moved %d", touches.count);
    [self processTouches:touches withEvent:event];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touches began %d", touches.count);
    [self processTouches:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //NSLog(@"touches ended %d", touches.count);
    [self processTouches:touches withEvent:event];
}

-(void)processTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self processTouch:touch];
    }
}

-(void)processTouch:(UITouch *)touch {
    if (self.paused) {
        return;
    }
    
    CGPoint location = [touch locationInNode:self];
    if (location.x < CGRectGetMidX(self.frame) - (_brickSize.width * maxCols / 2)) {
        CGPoint point = CGPointMake(_leftPaddle.position.x, location.y);
        _leftPaddle.position = point;
        if (!touchedLeft) {
            touchedLeft = YES;
            [BlongBall shootBallAtPoint:point withScene:self];
            [_leftPaddle getPhysical];
        }
    } else if (location.x > CGRectGetMidX(self.frame) + (_brickSize.width * maxCols / 2)) {
        CGPoint point = CGPointMake(_rightPaddle.position.x, location.y);
        _rightPaddle.position = point;
        if (!touchedRight) {
            touchedRight = YES;
            [BlongBall shootBallAtPoint:point withScene:self];
            [_rightPaddle getPhysical];
        }
    } else if (_level >= _introduceTappable) {
        float width = self.frame.size.width/10;
        float height = self.frame.size.height/5;
        CGPoint touchPoint = [touch locationInNode:self];
        CGRect touchRect = CGRectMake(touchPoint.x - width/2, touchPoint.y - height/2, width, height);
        BOOL debugTappable = NO;
        if (debugTappable) { // the actual rect seems bigger than this looks, i'm not sure why
            SKSpriteNode *touchRectNode = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:touchRect.size];
            touchRectNode.position = touchPoint;
            [touchRectNode runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:1], [SKAction removeFromParent]]]];
            [self addChild:touchRectNode];
        }
        [self.physicsWorld enumerateBodiesInRect:touchRect usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
            if (body.categoryBitMask & tappableBrickCat) {
                BlongBrick *brick = (BlongBrick *)body.node;
                CGPoint brickPoint = brick.frame.origin;
                [self removeBrick:brick];
                if (_level != _introduceTappable && _goldBricksMakeBalls && !brick.tapped) {
                    [BlongBall ballWithX:brickPoint.x withY:brickPoint.y withScene:self];
                }
                brick.tapped = YES;
            }
        }];
    }
    
    if (touchedLeft && touchedRight) {
        started = YES;
        _topWall.physicsBody.restitution = 1;
        _bottomWall.physicsBody.restitution = 1;
    }
}

-(void)newLevel {
    NSMutableArray *ballSequence = [NSMutableArray array];
    int scorePer = 10;
    long ballsSaved = _balls.count;
    for (BlongBall *ball in _balls) {
        if (!isBonusLevel) {
            [ballSequence addObject:[SKAction waitForDuration:.3]];
            [ballSequence addObject:[SKAction runBlock:^{
                [self makeParticleAt:ball.position];
                [ball removeFromParent];
                [self updateScore:scorePer];
                [self runAction:explosion];
            }]];
        } else {
            [ballSequence addObject:[SKAction runBlock:^{
                [self makeParticleAt:ball.position];
                [ball removeFromParent];
                [self updateScore:scorePer];
            }]];
        }

    }
    [self runAction:[SKAction sequence:ballSequence]];
    if (isBonusLevel) {
        [self runAction:explosion];
    }
    
    if (!isBonusLevel) {
        if (ballsSaved >= 2 && _level > 1) {
            SKLabelNode *ballsSavedLabel = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
            ballsSavedLabel.text = [NSString stringWithFormat:@"%ld BALLS", ballsSaved];
            ballsSavedLabel.fontSize = 25;
            ballsSavedLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + ballsSavedLabel.frame.size.height);
            [ballsSavedLabel setAlpha:0];
            [self addChild:ballsSavedLabel];
            SKAction *waitFadeIn_fadeOut = [SKAction sequence:@[
                                                                          [SKAction waitForDuration:.5],
                                                                          [SKAction fadeInWithDuration:1],
                                                                          [SKAction waitForDuration:.5],
                                                                          [SKAction fadeOutWithDuration:1],
                                                                          ]];
            
            [ballsSavedLabel runAction:waitFadeIn_fadeOut];
            
            
            NSString *powerUpString;
            if (ballsSaved == 2) {
                int randomPowerup = arc4random() % 3;
                switch (randomPowerup) {
                    case 0:
                        powerUpString = @"BIGGER PADDLES";
                        [_leftPaddle grow];
                        [_rightPaddle grow];
                        break;
                    case 1:
                        powerUpString = @"HERE'S 50 POINTS";
                        [self updateScore:50];
                        break;
                    case 2:
                        powerUpString = @"SLOW DOWN";
                        _slowDown += 50;
                        break;
                }
            } else {
                NSString *powerup = [threeBallPowerups objectAtIndex:(arc4random() % [threeBallPowerups count])];
                if ([powerup isEqualToString:@"wrecking_ball"])  {
                    powerUpString = @"WRECKING BALLS";
                    _wreckingBall = YES;
                    [threeBallPowerups removeObject:@"wrecking_ball"];
                } else if ([powerup isEqualToString:@"gold_bricks"] && _level > _introduceTappable) {
                    powerUpString = @"GOLD BRICKS MAKE BALLS";
                    _goldBricksMakeBalls = YES;
                    [threeBallPowerups removeObject:@"gold_bricks"];
                } else if ([powerup isEqualToString:@"no_countdown"]) {
                    powerUpString = @"NO COUNTDOWN";
                    _noCountdown = YES;
                    [threeBallPowerups removeObject:@"no_countdown"];
                } else if ([powerup isEqualToString:@"double_breakthrough"]) {
                    powerUpString = @"DOUBLE BREAKTHROUGH";
                    _doubleBreakthrough = YES;
                    [threeBallPowerups removeObject:@"double_breakthrough"];
                } else {
                    powerUpString = @"YOU ARE A COOL PERSON";
                }
            }

            
            SKLabelNode *bonusLabel = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
            bonusLabel.text = powerUpString;
            bonusLabel.fontSize = 25;
            bonusLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) - bonusLabel.frame.size.height);
            [bonusLabel setAlpha:0];
            [self addChild:bonusLabel];
            [bonusLabel runAction:waitFadeIn_fadeOut];
        }
    }
    
    if (isBonusLevel) {
        isBonusLevel = NO;
        _level++;
    } else if (_level % bonusLevelEvery == 0) {
        isBonusLevel = YES;
    } else {
        _level++;
    }
    
    self.physicsWorld.speed = 0;
    [self stopCountdown];

    _nextCockblock = 0;

    _balls = [NSMutableArray array];
    
    SKLabelNode *levelText = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    NSString *levelTextText = (isBonusLevel? @"BONUS LEVEL" : [NSString stringWithFormat:@"LEVEL %d", _level]);
    levelText.text = levelTextText;
    levelText.fontSize = 25;
    levelText.position = CGPointMake(CGRectGetMidX(self.frame), levelText.frame.size.height * 2);
    [levelText setAlpha:0];
    [self addChild:levelText];
    SKAction *waitFadeIn_fadeOutStartLevel = [SKAction sequence:@[
          [SKAction waitForDuration:(_level % bonusLevelEvery == 1 ? 2.5 :.5)], // after bonus level
          [SKAction fadeInWithDuration:1],
          [SKAction waitForDuration:.5],
          [SKAction fadeOutWithDuration:1],
          [SKAction runBlock:^{[self startLevel];}]
    ]];

    [levelText runAction:waitFadeIn_fadeOutStartLevel];
    
    levelVelocity = [self calcLevelVelocity];
    maxYVelocity = levelVelocity *.7;
}

-(void)gameOver {
    if (scoreToAdd > 0) {
        _score+= scoreToAdd;
        scoreToAdd = 0;
        _scoreLabel.text = [NSString stringWithFormat:@"%05d", _score];
    }
    [BlongGameCenterHelper reportScore:_score];
    BlongGameOverScene *gameOverScene = [[BlongGameOverScene alloc] initWithSize:self.size andScore:_score];
    SKTransition *transition = [SKTransition fadeWithDuration:2];
    [self.view presentScene:gameOverScene transition:transition];
}

-(void)update:(NSTimeInterval)currentTime {
    
    if (scoreToAdd > 0) {
        if (![self actionForKey:@"scoreAdd"]) {
            _score++;
            scoreToAdd--;
            [self runAction:addOne withKey:@"scoreAdd"];
        }
    }
    
    if (self.physicsWorld.speed > 0 && !self.paused && started) {
        if (isBonusLevel) {
            if (_balls.count == 0) {
                [self newLevel];
            }
        } else {
            if (_balls.count == 0) {
                self.physicsWorld.speed = 0;
                [self gameOver];
            } else if (_balls.count == 1 && _level != 1 && _level != _introduceTappable && !_noCountdown) {
                [self startCountdown];
            } else if (_balls.count > 1 && _countdownTimer.isValid) {
                [self stopCountdown];
            }
            
            if (_availableBlockSlots.count == _rows*_cols) { // bricks gone
                [self newLevel];
            }
        }
        
        // sometimes balls stick around forever and i don't know why
        for (BlongBall *ball in _balls) {
            if (ball.physicsBody.isResting) {
                [ball.physicsBody applyImpulse:CGVectorMake(1, 0)];
            }
            if (ball.position.x < 0 || ball.position.x > self.frame.size.width ||
                ball.position.y < 0 || ball.position.y > self.frame.size.height) {
                [self removeBall:ball];
                break;
            }
        }
    }
}

-(void)stopCountdown {
    [_countdownTimer invalidate];
    [_countdownClock removeFromParent];
}

-(void)startCountdown {
    if (!_countdownTimer || !_countdownTimer.isValid) {
        _countdownTimer = [NSTimer scheduledTimerWithTimeInterval:.01f target:self selector:@selector(updateCountdown:) userInfo:nil repeats:YES];
        _countdownClock = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        if (isBonusLevel) {
            _secondsLeft = bonusCountdown;
            _countdownClock.fontColor = [SKColor blueColor];
        } else {
            _secondsLeft = MAX((baseCountdown - floor(_level/incCountdown)), minCountdown);
            _countdownClock.fontColor = [SKColor redColor];
        }
        _countdownClock.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _countdownClock.text = [NSString stringWithFormat:@"%.02f", _secondsLeft];
        _countdownClock.position = CGPointMake(CGRectGetMidX(self.frame) - _countdownClock.frame.size.width/2, 0);
        _countdownClock.zPosition = 1;
        [self addChild:_countdownClock];
    }
}

-(void) updateCountdown:(NSTimer *)timer {
    if (!self.paused) {
        _secondsLeft -= .01;
        _countdownClock.text = [NSString stringWithFormat:@"%.02f", _secondsLeft];
        if (_secondsLeft <= 0.0) {
            [_countdownTimer invalidate];
            _countdownClock.text = @"0.00";
            if (isBonusLevel) {
                [self newLevel];
            } else {
                self.paused = YES;
                [self gameOver];
            }
        }
    }
}

-(void)bonusLevel {
    isBonusLevel = YES;
    [self startLevel];
}

-(void)makeParticleAt:(CGPoint) point {
    NSString *particlePath = [[NSBundle mainBundle] pathForResource:@"MyParticle" ofType:@"sks"];
    SKEmitterNode *particle = [NSKeyedUnarchiver unarchiveObjectWithFile:particlePath];
    particle.position = point;
    SKAction *stop = [SKAction runBlock:^{
        particle.particleBirthRate = 0;
    }];
    [particle runAction:[SKAction sequence:@[[SKAction waitForDuration:.3], stop, [SKAction waitForDuration:2], [SKAction removeFromParent]]]];
    [self addChild:particle];
}

-(CGPoint) getRandomOffScreenPointForNode:(SKNode * )node {
    float x = arc4random() % (int) self.scene.frame.size.width;
    float y;
    BOOL top = arc4random() % 2;
    if (top) {
        y = self.scene.frame.size.height + node.frame.size.height;
    } else {
        y = -node.frame.size.height;
    }
    
    return CGPointMake(x,y);
}

-(CGPoint) topLeft {
    return CGPointMake(CGRectGetMidX(self.frame) - ((((float)self.cols)/2.0)*self.brickSize.width) + self.brickSize.width/2.0, self.frame.size.height - self.brickSize.height/2.0);
}

-(float)calcLevelVelocity {
    return MIN(maxMaxVelocity, baseMaxVelocity + (_level * incMaxVelocity)) - _slowDown;
}

-(void)didSimulatePhysics {
    
}

@end
