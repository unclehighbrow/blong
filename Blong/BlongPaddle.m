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

+(BlongPaddle *) paddle:(NSString *)image {
    BlongPaddle *paddle = [BlongPaddle spriteNodeWithImageNamed:image];
    [paddle makePhysicsBody];
    paddle.name = image;
    paddle.centerRect = CGRectMake(.5, .25, 0, .5);
    return paddle;
}

-(void)makePhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 1;
    self.physicsBody.friction = 0;
    self.physicsBody.categoryBitMask = paddleCat;
}

-(void)shrink:(float)shrinkage {
    SKAction *shrink = [SKAction scaleXBy:1 y:shrinkage duration:1];
    SKAction *remakeBody = [SKAction runBlock:^{[self makePhysicsBody];}];
    [self runAction:[SKAction sequence:@[shrink, remakeBody]]];
}
@end
