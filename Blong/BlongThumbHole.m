//
//  BlongThumbHole.m
//  Blong
//
//  Created by Will Carlough on 10/3/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongThumbHole.h"

@implementation BlongThumbHole
+(BlongThumbHole *) thumbHoleOnLeft:(BOOL)left WithScene:(BlongMyScene *)scene {
    BlongThumbHole* thumbHole = [BlongThumbHole spriteNodeWithImageNamed:@"spark"];
    int x;
    if (left) {
        x = thumbHole.frame.size.width;
    } else {
        x = scene.frame.size.width - thumbHole.frame.size.width;
    }
    thumbHole.position = CGPointMake(x, CGRectGetMidY(scene.frame));
    [scene addChild:thumbHole];
    SKAction *grow = [SKAction scaleBy:2 duration:.5];
    SKAction *shrink = [grow reversedAction];
    SKAction *pulse = [SKAction sequence:@[grow, shrink]];
    [thumbHole runAction:[SKAction repeatActionForever:pulse] withKey:@"vamp"];
    return thumbHole;
}

-(void)explode {
    SKAction *fadeOut = [SKAction fadeAlphaTo:0 duration:.5];
    SKAction *grow = [SKAction scaleBy:4 duration:.5];
    SKAction *fadeOutAndGrow = [SKAction group:@[fadeOut, grow]];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *fadeOutGrowAndRemove = [SKAction sequence:@[fadeOutAndGrow, remove]];
    [self runAction:fadeOutGrowAndRemove withKey:@"vamp"];
}

@end
