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
    [ball prepareWithScene:scene withVelocity:CGVectorMake(150, 150)]; // TODO: change direction depending on left?
    SKAction *moveIn = [BlongEasing easeOutElasticFrom:ball.position to:CGPointMake(endX, endY) for:.5];
    [ball runAction:moveIn];
    return ball;
}

+(BlongBall *) ballToRandomPointWithScene:(BlongMyScene *) scene {
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    BOOL startTop = arc4random() % 2;
    int endX,endY,startX,startY;
    if (startTop) {
        startY = scene.frame.size.height + (ball.frame.size.height/2);
    } else {
        startY = 0 - (ball.frame.size.height/2);
    }
    startX = arc4random() % (int)floor(scene.frame.size.width);
    
    int minX = scene.leftPaddle.frame.origin.x + scene.leftPaddle.frame.size.width*2;
    int maxX = scene.rightPaddle.frame.origin.x - scene.rightPaddle.frame.size.width*2;
    int minY = (ball.frame.size.height/2);
    int maxY = scene.frame.size.height - (ball.frame.size.height/2);
    
    endX = minX + arc4random() % (maxX - minX);
    endY = minY + arc4random() % (maxY - minY);
    
    int xVelocity = 150;
    if (endX < scene.frame.size.width/2) {
        xVelocity *= -1;
    }
    
    ball.position = CGPointMake(startX, startY);
    [ball prepareWithScene:scene withVelocity:CGVectorMake(xVelocity, 150)];
    SKAction *moveIn = [BlongEasing easeOutElasticFrom:ball.position to:CGPointMake(endX, endY) for:.5];
    [ball runAction:moveIn];    
    return ball;
}

+(BlongBall *) ballWithX:(int)x withY:(int)y withScene:(BlongMyScene *) scene {
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    ball.position = CGPointMake(x, y);
    [ball prepareWithScene:scene withVelocity:CGVectorMake(150, 150)]; // TODO: somehow make this go the other way?
    return ball;
}

-(void)prepareWithScene:(BlongMyScene *)scene withVelocity:(CGVector)velocity {
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.height/2];
    self.physicsBody.dynamic = YES;
    self.physicsBody.restitution = 1;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.categoryBitMask = ballCat;
    if (scene.wreckingBall) {
        self.physicsBody.contactTestBitMask = paddleCat|wallCat;
    } else {
        self.physicsBody.contactTestBitMask = paddleCat|wallCat|brickCat;
    }
    self.physicsBody.collisionBitMask = ballCat|paddleCat|brickCat|wallCat;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.velocity = velocity;
    
    [scene addChild:self];
    [scene.balls addObject:self];
}

+(void)shootBallAtPoint:(CGPoint)point withScene:(BlongMyScene *)scene {
    BlongBall *ball = [BlongBall spriteNodeWithImageNamed:@"ball"];
    BOOL left = point.x < scene.frame.size.width / 2;
    CGPoint topLeft = [scene topLeft];
    CGVector velocity;
    if (left) {
        ball.position = CGPointMake(topLeft.x - (ball.frame.size.width*2), point.y);
        velocity = CGVectorMake(-212, 20);
    } else {
        ball.position = CGPointMake(topLeft.x + (scene.brickSize.width*scene.cols) + (ball.frame.size.width*2), point.y);
        velocity = CGVectorMake(212, 20);
    }
    
    [ball prepareWithScene:scene withVelocity:velocity];
    
}



@end
