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
+(BlongBrick *)brickWithScene:(BlongMyScene *) scene fromRandom:(BOOL)random withMotion:(BOOL)motion {
    if ([scene.availableBlockSlots count] == 0) {
        return nil;
    }
    BlongBrick *brick = [BlongBrick spriteNodeWithImageNamed:@"brick6"];
    if (arc4random() % 7 == 1 && scene.level != 1) {
        brick.color = [SKColor colorWithRed:255 green:215 blue:0 alpha:1];
        brick.colorBlendFactor = 1.0;
        brick.userInteractionEnabled = YES;
        brick.tappable = YES;
    }
    
    [brick setYScale:6.0/(float)scene.rows];
    scene.brickSize = brick.frame.size;

    int blockSlotNum;
    NSNumber *slot = [scene.availableBlockSlots objectAtIndex:(arc4random() % [scene.availableBlockSlots count])];
    [scene.availableBlockSlots removeObject:slot];
    blockSlotNum = [slot intValue];
    
    CGPoint topLeft = [scene topLeft];
    int col = blockSlotNum % scene.cols;
    int row = blockSlotNum / scene.cols;
    
    NSMutableArray *rowArray = [scene.bricks objectAtIndex:col];
    [rowArray insertObject:brick atIndex:row];


    CGPoint endPoint = [BlongBrick calculatePositionFromSlot:slot withNode:brick withScene:scene];
    if (motion) {
        float startX, startY;
        NSMutableArray *moveInSequence = [NSMutableArray array];
        SKAction *moveIn = [SKAction moveTo:endPoint duration:.3];
        moveIn.timingMode = SKActionTimingEaseIn;

        if (random) {
            startX = arc4random() % (int)scene.frame.size.width;
            brick.zRotation = ((float) (arc4random() % ((unsigned)M_PI + 1)) / M_PI) * M_PI;
            SKAction *rotateIn = [SKAction rotateToAngle:0 duration:.3];
            rotateIn.timingMode = SKActionTimingEaseIn;
            [moveInSequence addObject:[SKAction group:@[moveIn,rotateIn]]];
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
        [scene addChild:brick];
        [brick runAction:[SKAction sequence:moveInSequence]];
    } else {
        brick.position = endPoint;
        [brick getPhysical];
        [scene addChild:brick];
    }
    brick.blockSlot = slot;
    brick.col = col;
    brick.row = row;

    
    return brick;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [(BlongMyScene *)self.scene removeBrick:self];
}

+(CGPoint) calculatePositionFromSlot:(NSNumber *)slot withNode:(SKNode *)node withScene:(BlongMyScene *)scene {
    int blockSlotNum = [slot intValue];
    
    CGPoint topLeft = [scene topLeft];
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
