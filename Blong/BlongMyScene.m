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
float maxYVelocity;

int rows = 5;
int cols = 5;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        maxYVelocity = maxVelocity*.7;
        _availableBlockSlots = [NSMutableArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",
                                                            @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                                                            @"20", @"21", @"22", @"23", @"24", nil];
        self.backgroundColor = [SKColor blackColor];
        _leftPaddle = [BlongPaddle paddle:@"left_paddle"];
        _leftPaddle.position = CGPointMake(_leftPaddle.frame.size.width/2, CGRectGetMidY(self.frame));
        [self addChild:_leftPaddle];
        _rightPaddle = [BlongPaddle paddle:@"right_paddle"];
        _rightPaddle.position = CGPointMake(self.frame.size.width - _rightPaddle.frame.size.width/2, CGRectGetMidY(self.frame));
        [self addChild:_rightPaddle];
        
        BlongBall *ball1 = [BlongBall ball:YES withFrame:self.frame];
        [self addChild:ball1];
        [_balls addObject:ball1];
        
        BlongBall *ball2 = [BlongBall ball:NO withFrame:self.frame];
        [self addChild:ball2];
        [_balls addObject:ball2];
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsBody.restitution = 1;
        self.physicsBody.categoryBitMask = wallCat;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
       
        _score = 0;
        _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        [self updateScore:0];
        _scoreLabel.color = [SKColor whiteColor];
        _scoreLabel.position = CGPointMake(_scoreLabel.frame.size.width/2, 0);
        [self addChild:_scoreLabel];
        
        _bricks = [NSMutableArray array];
        for (int i = 0; i<rows; i++) {
            for (int j = 0; j<cols; j++) {
                [self newBrick];
            }
        }
    }
    return self;
}

-(void)newBrick {
    if ([_availableBlockSlots count] == 0) {
        return;
    }
    BlongBrick *brick = [BlongBrick brick];
    [_bricks addObject:brick];
    NSString *blockSlot = [_availableBlockSlots objectAtIndex:(arc4random() % [_availableBlockSlots count])];
    [_availableBlockSlots removeObject:blockSlot];
    int blockSlotNum = [blockSlot intValue];
    CGPoint topLeft = CGPointMake(CGRectGetMidX(self.frame) - 1.5*brick.frame.size.width, CGRectGetMidY(self.frame) + 1.5*brick.frame.size.height);
    int row = blockSlotNum % rows;
    int col = blockSlotNum / cols;
    CGPoint endPoint = brick.position = CGPointMake(topLeft.x + (row * brick.frame.size.width), topLeft.y - (col * brick.frame.size.height));
    if (col > cols/2) {
        brick.position = CGPointMake(topLeft.x + (row * brick.frame.size.width), 0-self.frame.size.height/2);
    } else {
        brick.position = CGPointMake(topLeft.x + (row * brick.frame.size.width), self.frame.size.height + brick.frame.size.height/2);
    }
    [brick.userData setObject:blockSlot forKey:@"blockSlot"];
    [self addChild:brick];
    
    
    SKAction *moveIn = [SKAction moveTo:endPoint duration:.5];
    moveIn.timingMode = SKActionTimingEaseInEaseOut;
    [brick runAction:moveIn];
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
    
    if (secondBody.categoryBitMask & paddleCat) {
        float relativeIntersectY = ball.node.position.y - secondBody.node.position.y;
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
            //[self removeBall:(BlongBall *)ball.node];
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
    CGPoint location = [touch locationInNode:self];
    if (location.x < CGRectGetMidX(self.frame)) {
        _leftPaddle.position = CGPointMake(_leftPaddle.position.x, location.y);
    } else {
        _rightPaddle.position = CGPointMake(_rightPaddle.position.x, location.y);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    if (_bricks.count == 0) {
        [self newBrick];
    }
}

-(void)didSimulatePhysics {
    
}

@end