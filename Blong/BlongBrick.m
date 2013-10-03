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
    if ([scene.availableBlockSlots count] == 0) {
        return nil;
    }
    BlongBrick *brick = [BlongBrick spriteNodeWithImageNamed:@"brick"];
    brick.userData = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [scene.bricks addObject:brick];
    NSString *blockSlot = [scene.availableBlockSlots objectAtIndex:(arc4random() % [scene.availableBlockSlots count])];
    [scene.availableBlockSlots removeObject:blockSlot];
    int blockSlotNum = [blockSlot intValue];
    CGPoint topLeft = CGPointMake(CGRectGetMidX(scene.frame) - ((scene.rows/2)*brick.frame.size.width) - brick.frame.size.width/2, scene.frame.size.height - brick.frame.size.height/2);
    int row = blockSlotNum % scene.rows;
    int col = blockSlotNum / scene.rows;

    CGPoint endPoint = brick.position = CGPointMake(topLeft.x + (col * brick.frame.size.width), topLeft.y - (row * brick.frame.size.height));
    int startX, startY;
    NSMutableArray *moveInSequence = [NSMutableArray array];
    SKAction *moveIn = [SKAction moveTo:endPoint duration:.3];
    moveIn.timingMode = SKActionTimingEaseOut;

    [moveInSequence addObject:moveIn];
    if (random) {
        startX = arc4random() % (int)scene.frame.size.width;
        [moveInSequence addObject:[SKAction runBlock:^{ // don't let initial bricks interact with anything on the way in
            [brick getPhysical];
        }]];
    } else {
        startX = topLeft.x + (col * brick.frame.size.width);
        [brick getPhysical];
    }
    if (row + 1> scene.rows/2) {
        startY = -brick.frame.size.height/2;
    } else {
        startY = scene.frame.size.height + brick.frame.size.height/2;
    }
    brick.position = (CGPointMake(startX, startY));
    [brick.userData setObject:blockSlot forKey:@"blockSlot"];
    
    [scene addChild:brick];
    
    [brick runAction:[SKAction sequence:moveInSequence]];
    
    return brick;
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
