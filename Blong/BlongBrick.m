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
+(BlongBrick *)brickWithScene:(BlongMyScene *) scene fromRandom:(BOOL)random {
    return [BlongBrick brickWithScene: scene fromRandom:random atSlot:nil];
}

+(BlongBrick *)brickWithScene:(BlongMyScene *) scene fromRandom:(BOOL)random atSlot:(NSString *) slot {
    if ([scene.availableBlockSlots count] == 0) {
        return nil;
    }
    BlongBrick *brick = [BlongBrick spriteNodeWithImageNamed:[NSString stringWithFormat:@"brick%d", scene.rows]];
    scene.brickSize = brick.frame.size;

    brick.userData = [NSMutableDictionary dictionaryWithCapacity:10];
    [scene.bricks addObject:brick];
    int blockSlotNum;
    if (!slot) {
        slot = [scene.availableBlockSlots objectAtIndex:(arc4random() % [scene.availableBlockSlots count])];
    }
    [scene.availableBlockSlots removeObject:slot];
    blockSlotNum = [slot intValue];

    
    CGPoint topLeft = CGPointMake(CGRectGetMidX(scene.frame) - ((((float)scene.cols)/2.0)*brick.frame.size.width) - brick.frame.size.width/2.0, scene.frame.size.height - brick.frame.size.height/2.0);
    int col = blockSlotNum % scene.cols;
    int row = blockSlotNum / scene.cols;

    CGPoint endPoint = [BlongBrick calculatePositionFromSlot:slot withNode:brick withScene:scene];
    float startX, startY;
    NSMutableArray *moveInSequence = [NSMutableArray array];
    SKAction *moveIn = [SKAction moveTo:endPoint duration:.3];
    moveIn.timingMode = SKActionTimingEaseIn;

    if (random) {
        startX = arc4random() % (int)scene.frame.size.width;
        brick.zRotation = ((float) (arc4random() % ((unsigned)M_PI + 1)) / M_PI) * M_PI;
        SKAction *rotateIn = [SKAction rotateToAngle:0 duration:.3];
        rotateIn.timingMode = SKActionTimingEaseIn;
        [moveInSequence addObject:[SKAction group:@[moveIn, rotateIn]]];
        [moveInSequence addObject:[SKAction runBlock:^{ // don't let initial bricks interact with anything on the way in
            [brick getPhysical];
        }]];
    } else {
        startX = topLeft.x + (col * brick.frame.size.width);
        [moveInSequence addObject:moveIn];
        [brick getPhysical];
    }
    if (row + 1 > scene.rows/2) {
        startY = -brick.frame.size.height/2;
    } else {
        startY = scene.frame.size.height + brick.frame.size.height/2;
    }
    brick.position = (CGPointMake(startX, startY));
    [brick.userData setObject:slot forKey:@"blockSlot"];
    
    [scene addChild:brick];
    
    [brick runAction:[SKAction sequence:moveInSequence]];
    
    return brick;
}

+(CGPoint) calculatePositionFromSlot:(NSString *)slot withNode:(SKNode *)node withScene:(BlongMyScene *)scene {
    int blockSlotNum = [slot intValue];
    
    CGPoint topLeft = CGPointMake(CGRectGetMidX(scene.frame) - ((((float)scene.cols)/2.0)*scene.brickSize.width) - scene.brickSize.width/2.0, scene.frame.size.height - scene.brickSize.height/2.0);
    int col = blockSlotNum % scene.cols;
    int row = blockSlotNum / scene.cols;
    
    return CGPointMake(topLeft.x + (col * scene.brickSize.width), topLeft.y - (row * scene.brickSize.height));
}

-(void)getPhysical {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.categoryBitMask = brickCat;
    self.physicsBody.dynamic = NO;
    self.physicsBody.restitution = 1;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.angularDamping = 0;
    self.physicsBody.friction = 0;
}
@end
