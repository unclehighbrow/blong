//
//  BlongMyScene.m
//  Blong
//
//  Created by Will Carlough on 7/7/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongMyScene.h"

@implementation BlongMyScene

const uint32_t ballCat = 0x1 << 1;
const uint32_t paddleCat = 0x1 << 2;
const uint32_t wallCat = 0x1 << 3;
const uint32_t brickCat = 0x1 << 4;

float maxVelocity = 300;
int cockBlockInterval = 10;
float maxYVelocity;

// for starting
bool touchedLeft = false;
bool touchedRight = false;
bool started = false;
BlongThumbHole *leftThumbHole;
BlongThumbHole *rightThumbHole;


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        maxYVelocity = maxVelocity*.7;
        
        // score
        _score = 0;
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
        [self updateScore:0];
        _scoreLabel.color = [SKColor whiteColor];
        _scoreLabel.position = CGPointMake(_scoreLabel.frame.size.width/2, 0);
        [self addChild:_scoreLabel];

        _availableBlockSlots = [NSMutableArray array];

        self.backgroundColor = [SKColor blackColor];
        
        // paddles
        _leftPaddle = [BlongPaddle paddle:@"left_paddle"];
        _leftPaddle.position = CGPointMake(_leftPaddle.frame.size.width/2, CGRectGetMidY(self.frame));
        [self addChild:_leftPaddle];
        _rightPaddle = [BlongPaddle paddle:@"right_paddle"];
        _rightPaddle.position = CGPointMake(self.frame.size.width - _rightPaddle.frame.size.width/2, CGRectGetMidY(self.frame));
        [self addChild:_rightPaddle];
        
        // bricks and balls
        _bricks = [NSMutableArray array];
        _balls = [NSMutableArray array];
        _level = 1;
        
        // physics and walls
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.restitution = 1;
        self.physicsBody.categoryBitMask = wallCat;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.speed = 0;
        
        leftThumbHole = [BlongThumbHole thumbHoleOnLeft:YES WithScene:self];
        rightThumbHole = [BlongThumbHole thumbHoleOnLeft:NO WithScene:self];
        
        //[self startLevel];
    }
    return self;
}

-(void)startLevel {
    _nextCockBlock = 0;
    
    _rows = 5;
    _cols = 5;
    for (int i = 0; i < _rows*_cols; i++) {
        [_availableBlockSlots addObject:[NSString stringWithFormat:@"%d", i]];
    }
    // balls
    [BlongBall ballOnLeft:YES withScene:self];
    [BlongBall ballOnLeft:NO withScene:self];
    
    SKAction *topToMiddle = [SKAction moveTo:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)) duration:.3];
    topToMiddle.timingMode = SKActionTimingEaseIn;
    SKAction *wait = [SKAction waitForDuration: .3];
    SKAction *shrinkAway = [SKAction scaleTo:0 duration:.3];
    
    SKLabelNode *ready = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
    ready.text = @"READY";
    ready.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height + ready.frame.size.height/2);
    [self addChild:ready];
    [ready runAction:[SKAction sequence:@[wait, wait, topToMiddle, wait, wait, shrinkAway]]];
    
    SKLabelNode *steady = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
    steady.text = @"STEADY";
    steady.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height + ready.frame.size.height/2);
    [self addChild:steady];
    [steady runAction:[SKAction sequence:@[wait, wait, wait, wait, wait, wait, topToMiddle, wait, wait, shrinkAway]]];
    
    SKLabelNode *blong = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
    blong.text = @"BLONG";
    blong.fontSize = 250;
    [blong setAlpha:0];
    SKAction *fadeIn = [SKAction fadeAlphaTo:.2 duration:.3];
    SKAction *moveInBricks = [SKAction runBlock:^{
        for (int i = 0; i<_rows; i++) {
            for (int j = 0; j<_cols; j++) {
                [BlongBrick brickWithScene:self fromRandom:YES];
            }
        }
    }];
    SKAction *startPhysics = [SKAction runBlock:^{
        self.physicsWorld.speed = 1;
        //_levelStart = [CFTimeInterval
    }];
    SKAction *fadeInAndMoveInBricks = [SKAction group:@[fadeIn, moveInBricks]];
    SKAction *fadeOut = [SKAction fadeOutWithDuration:2];
    [blong runAction:[SKAction sequence:@[wait, wait, wait, wait, wait, wait, wait, wait, wait, wait, fadeInAndMoveInBricks, startPhysics, fadeOut]]];
    blong.position = CGPointMake(CGRectGetMidX(self.frame), 0);
    [self addChild:blong];
    
    // pause button
    [BlongPauseButton pauseButtonWithScene:self];
}

-(void)updateScore:(int) pointsAdded {
    _score = _score + pointsAdded;
    _scoreLabel.text = [NSString stringWithFormat:@"%06d", _score];
}

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *ball, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        ball = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        ball = contact.bodyB;
        secondBody = contact.bodyA;
    }
    // float totalVelocity = sqrtf((ball.velocity.dx * ball.velocity.dx) + (ball.velocity.dy * ball.velocity.dy));
    // NSLog(@"total vel: %f", totalVelocity);
    
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
            float yVelocity = maxVelocity * relativeIntersectY/secondBody.node.frame.size.height * 2;
            CGVector velocity = [self calculateVelocityFromY:yVelocity];
            BOOL right = ball.node.position.x > CGRectGetMidX(self.frame);
            if (right) {
                velocity.dx = -velocity.dx;
            }
            ball.velocity = velocity;
        }
    }
    
    // this is a check to see if it's moving to slowly horizontally, and give it a little push
    if (secondBody.categoryBitMask & wallCat) {
        if (contact.contactPoint.x < 3 || contact.contactPoint.x > self.frame.size.width - 3) {
            [self removeBall:(BlongBall *)ball.node];
        } else if (fabsf(ball.velocity.dx) < 30) {
            if (ball.velocity.dx < 0) {
                [ball applyImpulse:CGVectorMake(-1, 0)];
            } else {
                [ball applyImpulse:CGVectorMake(1, 0)];
            }
        }
        
    }
    
    if (secondBody.categoryBitMask & brickCat) {
        [self removeBrick:(BlongBrick *)secondBody.node];
    }
}

-(void)removeBrick:(BlongBrick *)brick {
    [self updateScore:1];
    SKAction *shrink = [SKAction scaleTo:0 duration:.1];
    SKAction *removeFromBricks = [SKAction runBlock:^{
        [_availableBlockSlots addObject:[brick.userData objectForKey:@"blockSlot"]];
        [_bricks removeObject:brick];
    }];
    SKAction *removeFromParent = [SKAction removeFromParent];
    
    [brick runAction: [SKAction sequence: @[shrink, removeFromBricks, removeFromParent]]];
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
    float xVelocity = sqrtf(powf(maxVelocity, 2) - powf(yVelocity, 2));
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

-(void)processTouch:(UITouch *)touch {
    if (self.paused) {
        return;
    }
    
    CGPoint location = [touch locationInNode:self];
    if (location.x < CGRectGetMidX(self.frame)) {
        if (!touchedLeft) {
            touchedLeft = YES;
            [leftThumbHole explode];
        }
        _leftPaddle.position = CGPointMake(_leftPaddle.position.x, location.y);
    } else {
        if (!touchedRight) {
            touchedRight = YES;
            [rightThumbHole explode];
        }
        _rightPaddle.position = CGPointMake(_rightPaddle.position.x, location.y);
    }
    if (!started && touchedRight && touchedLeft) {
        started = YES;
        [self startLevel];
    }
}

-(void)newLevel {
    _level++;
    self.physicsWorld.speed = 0;
    for (BlongBall *ball in _balls) {
        [ball removeFromParent];
    }
    _balls = [NSMutableArray array];
    
    SKLabelNode *levelText = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
    levelText.text = [NSString stringWithFormat:@"Level %d", _level];
    levelText.position = CGPointMake(CGRectGetMidX(self.frame), levelText.frame.size.height * 2);
    [levelText setAlpha:0];
    [self addChild:levelText];
    SKAction *waitFadeInFadeOutStartLevel = [SKAction sequence:@[
          [SKAction waitForDuration:.5],
          [SKAction fadeInWithDuration:1],
          [SKAction waitForDuration:.5],
          [SKAction fadeOutWithDuration:1],
          [SKAction runBlock:^{[self startLevel];}]
    ]];
    [levelText runAction:waitFadeInFadeOutStartLevel];
}

-(void)gameOver {
    // save high score
    
    SKScene *gameOverScene = [[BlongGameOverScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition fadeWithDuration:2];
    [self.view presentScene:gameOverScene transition:transition];
}

// TODO: PAUSING BREAKS COCKBLOCK COUNT
-(void)update:(NSTimeInterval)currentTime {
    if (self.physicsWorld.speed > 0) {
        if (_bricks.count == 0) {
            [self newLevel];
        }
        if (_nextCockBlock == 0) {
            _nextCockBlock = currentTime + (cockBlockInterval / _level);
        } else if (currentTime > _nextCockBlock) {
            [BlongBrick brickWithScene:self fromRandom:NO];
            _nextCockBlock = 0;
        }
        
        if (_balls.count == 0) {
            self.physicsWorld.speed = 0;
            [self gameOver];
        }
    }
}

-(void)didSimulatePhysics {
    
}

@end
