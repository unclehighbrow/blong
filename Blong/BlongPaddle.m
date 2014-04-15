//
//  BlongPaddle.m
//  Blong
//
//  Created by Will Carlough on 9/30/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongPaddle.h"
#import "BlongMyScene.h"
@implementation BlongPaddle

float scale = 1;

static float shrinkage = .03;
static float maxShrinkage = .4;
static float maxGrowage = 1.5;
static float growage = .1;

+(BlongPaddle *) paddle:(NSString *)image {
    BlongPaddle *paddle = [BlongPaddle spriteNodeWithImageNamed:image];
    [paddle makePhysicsBodyWithDynamic:YES];
    paddle.name = image;
    paddle.centerRect = CGRectMake(.5, .25, 0, .5);
    return paddle;
}

-(void)makePhysicsBodyWithDynamic:(BOOL)dynamic {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.calculateAccumulatedFrame.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = .5;
    self.physicsBody.friction = 1;
    self.physicsBody.categoryBitMask = paddleCat;
    
    if (!dynamic) {
        [self getPhysical];
    }
}

-(void)grow {
    if (self.yScale > maxGrowage) {
        return;
    }
    
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue]; // 7.0 doesn't shrink the physics body
    if (osVersion < 7.1) {
        self.yScale = self.yScale + growage;
        [self makePhysicsBodyWithDynamic:NO];
    } else {
        [self runAction:[SKAction scaleXTo:1 y:(self.yScale + growage) duration:1]];
    }
}

-(void)shrink {
    if (self.yScale < maxShrinkage) {
        return;
    }
    
    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue]; // 7.0 doesn't shrink the physics body
    if (osVersion < 7.1) {
        self.yScale = self.yScale - shrinkage;
        [self makePhysicsBodyWithDynamic:NO];
    } else {
        [self runAction:[SKAction scaleXTo:1 y:(self.yScale - shrinkage) duration:1]];
    }
}

-(void) getPhysical {
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 1;
}
@end
