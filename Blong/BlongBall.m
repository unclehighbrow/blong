//
//  BlongBall.m
//  Blong
//
//  Created by Will Carlough on 7/13/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongBall.h"
#import "BlongMyScene.h"

@implementation BlongBall
+(BlongBall *)ball {
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height/2];
    ball.physicsBody.dynamic = YES;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.angularDamping = 0;
    ball.physicsBody.categoryBitMask = ballCat;
    ball.physicsBody.contactTestBitMask = ballCat|paddleCat|wallCat|brickCat;
    ball.physicsBody.collisionBitMask = ballCat|paddleCat|wallCat|brickCat;
    ball.position = CGPointMake(50, 50);
    ball.physicsBody.velocity = CGVectorMake(2, 2);
    return ball;
}
@end
