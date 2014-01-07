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
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.size];
    paddle.physicsBody.dynamic = NO;
    paddle.physicsBody.restitution = 1;
    paddle.physicsBody.friction = 0;
    paddle.name = image;
    paddle.physicsBody.categoryBitMask = paddleCat;
    paddle.centerRect = CGRectMake(.5, .25, 0, .5);
    
    return paddle;
}
@end
