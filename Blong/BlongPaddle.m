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

static float shrinkage = .9;
static float maxShrinkage = .35;

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
    if (scale < maxShrinkage) {
        return;
    }
    scale *= shrinkage;
    SKAction *shrink = [SKAction scaleXBy:1 y:shrinkage duration:1];
    SKAction *remakeBody = [SKAction runBlock:^{[self makePhysicsBodyWithDynamic:NO];}];
    [self runAction:[SKAction sequence:@[shrink, remakeBody]]];
}

-(void) getPhysical {
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 1;
}
@end
