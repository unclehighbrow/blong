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

+(BlongBrick *)brickWithScene:(BlongMyScene *) scene {
    if ([scene.availableBlockSlots count] == 0) {
        return nil;
    }
    BlongBrick *brick = [BlongBrick spriteNodeWithImageNamed:@"brick"];
    brick.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:brick.frame.size];
    brick.physicsBody.categoryBitMask = brickCat;
    brick.physicsBody.dynamic = NO;
    brick.physicsBody.restitution = 1;
    brick.userData = [NSMutableDictionary dictionaryWithCapacity:10];
    
    [scene.bricks addObject:brick];
    NSString *blockSlot = [scene.availableBlockSlots objectAtIndex:(arc4random() % [scene.availableBlockSlots count])];
    [scene.availableBlockSlots removeObject:blockSlot];
    int blockSlotNum = [blockSlot intValue];
    CGPoint topLeft = CGPointMake(CGRectGetMidX(scene.frame) - 1.5*brick.frame.size.width, CGRectGetMidY(scene.frame) + 1.5*brick.frame.size.height);
    int row = blockSlotNum % rows;
    int col = blockSlotNum / cols;
    CGPoint endPoint = brick.position = CGPointMake(topLeft.x + (row * brick.frame.size.width), topLeft.y - (col * brick.frame.size.height));
    if (col > cols/2) {
        brick.position = CGPointMake(topLeft.x + (row * brick.frame.size.width), 0-scene.frame.size.height/2);
    } else {
        brick.position = CGPointMake(topLeft.x + (row * brick.frame.size.width), scene.frame.size.height + brick.frame.size.height/2);
    }
    [brick.userData setObject:blockSlot forKey:@"blockSlot"];
    [scene addChild:brick];
    
    
    SKAction *moveIn = [SKAction moveTo:endPoint duration:.5];
    moveIn.timingMode = SKActionTimingEaseInEaseOut;
    [brick runAction:moveIn];
    
    return brick;
}
@end
