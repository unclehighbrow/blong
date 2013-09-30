//
//  BlongBrick.m
//  Blong
//
//  Created by Will Carlough on 9/30/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongBrick.h"
#import "BlongMyScene.h"

@implementation BlongBrick
+(BlongBrick *)brick {
    BlongBrick *brick = [BlongBrick spriteNodeWithImageNamed:@"brick"];
    brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
    brick.physicsBody.categoryBitMask = brickCat;
    brick.physicsBody.dynamic = NO;
    brick.physicsBody.restitution = 1;
    return brick;
}
@end
