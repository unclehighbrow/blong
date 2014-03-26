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

float baseMaxVelocity = 285;
float maxMaxVelocity = 800;
float incMaxVelocity = 15;
float maxYVelocity;

int bonusCountdown = 10;

// for starting
bool started;
bool touchedLeft;
bool touchedRight;
bool isBonusLevel = NO;

// sounds for preloading
SKAction *makeNoise;
SKAction *bip;
SKAction *bop;
SKAction *explosion;
SKAction *gameOver;
SKAction *ballsComingIn;
SKAction *sound29;

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

int baseCountdown = 30;
int minCountdown = 10;

int bonusLevelEvery = 3;

CGPoint textEnd;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        maxYVelocity = [self levelVelocity] *.7;
        _introduceTappable = 7;

        
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

        _availableBlockSlots = [NSMutableArray array];

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
        bip = [SKAction playSoundFileNamed:@"bip.wav" waitForCompletion:NO];
        bop = [SKAction playSoundFileNamed:@"bop.wav" waitForCompletion:NO];
        makeNoise = [SKAction playSoundFileNamed:@"level_start.wav" waitForCompletion:NO];
        explosion = [SKAction playSoundFileNamed:@"game_over2.wav" waitForCompletion:NO];
        gameOver = [SKAction playSoundFileNamed:@"game_over.wav" waitForCompletion:NO];
        ballsComingIn = [SKAction playSoundFileNamed:@"balls_coming_in.aif" waitForCompletion:NO];
        sound29 = [SKAction playSoundFileNamed:@"29.wav" waitForCompletion:NO];
        
        self.paused = NO;
    }
    return self;
}

-(void) didMoveToView:(SKView *)view {
    if (_skipTutorial) {
        touchedLeft = YES;
        touchedRight = YES;
        started = YES;
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
    } else {
        _rows = MIN(baseRows + _level, maxRows);
        _cols = MIN(baseCols + floor(_level / incCols), maxCols);
    }

    _bricks = [NSMutableArray array]; // this is to stop weirdness coming out of level 2. shouldn't be necessary
    _availableBlockSlots = [NSMutableArray array];
    
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
    
    NSLog(@"new level: %d, %d, %lu", _cols, _rows, (unsigned long)_availableBlockSlots.count);
    
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
    
    // balls
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:1.5],
                                         [SKAction runBlock:^{
                                                                        [BlongBall ballOnLeft:YES withScene:self];
                                                                        [BlongBall ballOnLeft:NO withScene:self];}]
                                         ]]];
    
    
    // steady
    SKLabelNode *steady = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    steady.text = @"STEADY";
    steady.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height + ready.frame.size.height/2);
    steady.zPosition = -1;
    [self addChild:steady];
    [steady runAction:[SKAction sequence:@[[SKAction waitForDuration:2.3], _topToMiddle, _shrinkAway]]];
    
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
        }];
    }
    
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:2.9], moveInBricks, [SKAction waitForDuration:.3]]]];

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

    [blong runAction:[SKAction sequence:@[[SKAction waitForDuration:3.7], startPhysics, makeNoise, fadeIn, _fadeOut]]];
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
                float yVelocity = [self levelVelocity] * relativeIntersectY/secondBody.node.frame.size.height * 2;
                CGVector velocity = [self calculateVelocityFromY:yVelocity];
                BOOL right = ball.node.position.x > CGRectGetMidX(self.frame);
                if (right) {
                    velocity.dx = -velocity.dx;
                }
                ball.velocity = velocity;
            }
            [self runAction:bip];
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
            if (brick.tappable) {
                // TODO: different sound
            } else {
                [self removeBrick:brick];
                [self runAction:bop];
            }
        }
    }
}

-(void)removeBrick:(BlongBrick *)brick {

    [self updateScore:1];
    SKAction *shrink = [SKAction scaleTo:0 duration:.2];
    SKAction *removeFromBricks = [SKAction runBlock:^{
        _lastBlockCleared = brick.blockSlot;
        [_availableBlockSlots addObject:_lastBlockCleared];
        [[_bricks objectAtIndex:brick.col] removeObjectAtIndex:brick.row];
        [self checkBreakthrough];
    }];
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    // also explode it
    SKSpriteNode *explodeBrick = [SKSpriteNode spriteNodeWithImageNamed:@"brick6"];
    explodeBrick.yScale = brick.yScale;
    explodeBrick.position = brick.position;
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
                
                SKLabelNode *breakthrough = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
                breakthrough.text = @"BREAKTHROUGH";
                breakthrough.position = CGPointMake(CGRectGetMidX(self.frame), 0);
                breakthrough.fontColor = [SKColor blueColor];
                breakthrough.zPosition = 1;
                [self addChild:breakthrough];
                [breakthrough runAction:[SKAction sequence:@[[SKAction waitForDuration:.6], _shrinkAway]]];
                CGPoint lastBrickPoint = [BlongBrick calculatePositionFromSlot:_lastBlockCleared withNode:[_balls objectAtIndex:0] withScene:self];
                [BlongBall ballWithX:lastBrickPoint.x withY:lastBrickPoint.y withScene:self];
                [self makeParticleAt:lastBrickPoint];
                _brokenThrough = YES;
                break; // dicks
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
    float xVelocity = sqrtf(powf([self levelVelocity], 2) - powf(yVelocity, 2));
    return CGVectorMake(xVelocity, yVelocity);
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self processTouches:touches withEvent:event];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {    
    [self processTouches:touches withEvent:event];
}

-(void)processTouches:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self processTouch:touch];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        float width = self.frame.size.width/13;
        float height = self.frame.size.height/8;
        CGPoint touchPoint = [touch locationInNode:self];
        CGRect touchRect = CGRectMake(touchPoint.x - width/2, touchPoint.y - height/2, width, height);
//        if (true) { // the actual rect seems bigger than this looks, i'm not sure why
//            SKSpriteNode *touchRectNode = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:touchRect.size];
//            touchRectNode.position = touchPoint;
//            [touchRectNode runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:1], [SKAction removeFromParent]]]];
//            [self addChild:touchRectNode];
//        }
        [self.physicsWorld enumerateBodiesInRect:touchRect usingBlock:^(SKPhysicsBody *body, BOOL *stop) {
            if (body.categoryBitMask & brickCat) {
                BlongBrick *brick = (BlongBrick *)body.node;
                if (brick.tappable) {
                    [self removeBrick:brick];
                }
            }
        }];
    }
}

-(void)processTouch:(UITouch *)touch {
    if (self.paused) {
        return;
    }
    
    CGPoint location = [touch locationInNode:self];
    if (location.x < CGRectGetMidX(self.frame)) {
        CGPoint point = CGPointMake(_leftPaddle.position.x, location.y);
        _leftPaddle.position = point;
        if (!touchedLeft) {
            touchedLeft = YES;
            [BlongBall shootBallAtPoint:point withScene:self];
            [_leftPaddle getPhysical];
        }
    } else {
        CGPoint point = CGPointMake(_rightPaddle.position.x, location.y);
        _rightPaddle.position = point;
        if (!touchedRight) {
            touchedRight = YES;
            [BlongBall shootBallAtPoint:point withScene:self];
            [_rightPaddle getPhysical];
        }
    }
    if (touchedLeft && touchedRight) {
        started = YES;
        _topWall.physicsBody.restitution = 1;
        _bottomWall.physicsBody.restitution = 1;
    }
}

-(void)tabulateBonus {
    long ballsSaved = _balls.count;
    [self runAction:explosion];
    for (BlongBall *ball in _balls) {
        [self makeParticleAt:ball.position];
        [ball removeFromParent];
    }
    SKLabelNode *ballsSavedLabel = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    ballsSavedLabel.text = [NSString stringWithFormat:@"%ld BALLS", ballsSaved];
    ballsSavedLabel.position = CGPointMake(0-ballsSavedLabel.frame.size.width/2, CGRectGetMidY(self.frame));
    [self addChild:ballsSavedLabel];
    
    [ballsSavedLabel runAction:[SKAction sequence:@[[SKAction waitForDuration:1],
                                                    [BlongEasing easeOutElasticFrom:ballsSavedLabel.position to:textEnd for:.5],
                                                    _shrinkAway]]];
    
    NSString *powerUpString;
    if (ballsSaved == 0l) {
        powerUpString = @"NO BONUS";
    }
    
    SKLabelNode *bonusLabel = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    bonusLabel.text = @"DICKS";
    bonusLabel.position = CGPointMake(self.frame.size.width + bonusLabel.frame.size.width/2, CGRectGetMidY(self.frame));
    [self addChild:bonusLabel];
    [bonusLabel runAction:[SKAction sequence:@[[SKAction waitForDuration:2],
                                               [BlongEasing easeOutElasticFrom:bonusLabel.position to:textEnd for:.5],
                                               _shrinkAway]]];
    
}

-(void)newLevel {
    if (isBonusLevel) {
        [self tabulateBonus];
        isBonusLevel = NO;
        _level++;
    } else {
        NSMutableArray *ballSequence = [NSMutableArray array];
        int scorePer = 10;
        for (BlongBall *ball in _balls) {
            [ballSequence addObject:[SKAction waitForDuration:.3]];
            [ballSequence addObject:[SKAction runBlock:^{
                [self makeParticleAt:ball.position];
                [ball removeFromParent];
                [self updateScore:scorePer];
                [self runAction:explosion];
            }]];
        }
        [self runAction:[SKAction sequence:ballSequence]];
        if (_level % bonusLevelEvery == 0) {
            isBonusLevel = YES;
        } else {
            _level++;
        }
    }

    self.physicsWorld.speed = 0;
    [self stopCountdown];

    _nextCockblock = 0;

    _balls = [NSMutableArray array];
    
    SKLabelNode *levelText = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
    NSString *levelTextText = (isBonusLevel? @"BONUS LEVEL" : [NSString stringWithFormat:@"LEVEL %d", _level]);
    levelText.text = levelTextText;
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
    
    [_leftPaddle shrink];
    [_rightPaddle shrink];
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
    [self runAction:gameOver];
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
            } else if (_balls.count == 1 && _level != 1 && _level != _introduceTappable) {
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
            _secondsLeft = MAX((baseCountdown - _level), minCountdown);
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

-(float)levelVelocity {
    return MIN(maxMaxVelocity, baseMaxVelocity + (_level * incMaxVelocity));
}

-(void)didSimulatePhysics {
    
}

@end
