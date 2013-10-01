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
+(BlongBall *)ballOnLeft:(BOOL) left withScene:(BlongMyScene *) scene{
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.height/2];
    ball.physicsBody.dynamic = YES;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.angularDamping = 0;
    ball.physicsBody.categoryBitMask = ballCat;
    ball.physicsBody.contactTestBitMask = paddleCat|wallCat|brickCat;
    ball.physicsBody.collisionBitMask = ballCat|paddleCat|brickCat|wallCat;
    BOOL top = arc4random() % 2 == 0;
    int x,y;
    if (top) {
        y = scene.frame.size.height - (ball.frame.size.height * 2);
    } else {
        y = ball.frame.size.height*2;
    }
    if (left) {
        x = ball.frame.size.width * 10;
    } else {
        x = scene.frame.size.width - (ball.frame.size.width * 10);
    }
    ball.position = CGPointMake(x, y);
    ball.physicsBody.velocity = CGVectorMake(150, 150);
    
    [scene addChild:ball];
    [scene.balls addObject:ball];

    return ball;
}
@end
