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

static float shrinkage = .007;
static float maxShrinkage = .4;

+(BlongPaddle *) paddle:(NSString *)image {
    BlongPaddle *paddle = [BlongPaddle spriteNodeWithImageNamed:image];
    [paddle makePhysicsBodyWithDynamic:YES];
    paddle.name = image;
    paddle.centerRect = CGRectMake(.5, .25, 0, .5);
    return paddle;
}

-(void)makePhysicsBodyWithDynamic:(BOOL)dynamic {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.restitution = .5;
    self.physicsBody.friction = 1;
    self.physicsBody.categoryBitMask = paddleCat;
    
    if (!dynamic) {
        [self getPhysical];
    }
}

-(void)shrink {
    NSLog(@"y scale: %f", self.yScale);
    if (self.yScale < maxShrinkage) {
        return;
    }
    [self runAction:[SKAction scaleXBy:1 y:self.yScale-shrinkage duration:1]];
}

-(void) getPhysical {
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 1;
}
@end
