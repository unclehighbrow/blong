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
+(BlongBall *)ballOnLeft:(BOOL) left withScene:(BlongMyScene *) scene {
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    int endX,endY,startX,startY;
    BOOL top = arc4random() % 2;
    if (top) {
        startY = 0 - (ball.frame.size.height/2);
        endY = scene.frame.size.height - (ball.frame.size.height * 2);
    } else {
        startY = scene.frame.size.height + (ball.frame.size.height/2);
        endY = ball.frame.size.height*2;
    }
    if (left) {
        startX = scene.frame.size.width - (ball.frame.size.width * 10);
        endX = ball.frame.size.width * 10;
    } else {
        startX = ball.frame.size.width * 10;
        endX = scene.frame.size.width - (ball.frame.size.width * 10);
    }
    
    ball.position = CGPointMake(startX, startY);
    [ball prepareWithScene:scene];
    SKAction *moveIn = [SKAction moveTo:CGPointMake(endX, endY) duration:.3];
    moveIn.timingMode = SKActionTimingEaseIn;
    [ball runAction:moveIn];
    return ball;
}

+(BlongBall *) ballWithX:(int)x withY:(int)y withScene:(BlongMyScene *) scene {
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    ball.position = CGPointMake(x, y);
    [ball prepareWithScene:scene];
    return ball;
}

-(void)prepareWithScene:(BlongMyScene *)scene {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height/2];
    self.physicsBody.dynamic = YES;
    self.physicsBody.restitution = 1;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.categoryBitMask = ballCat;
    self.physicsBody.contactTestBitMask = paddleCat|wallCat|brickCat;
    self.physicsBody.collisionBitMask = ballCat|paddleCat|brickCat|wallCat;
    self.physicsBody.velocity = CGVectorMake(150, 150); // 212
    
    [scene addChild:self];
    [scene.balls addObject:self];
}



@end
