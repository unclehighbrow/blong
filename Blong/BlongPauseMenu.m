//
//  BlongPauseMenu.m
//  Blong
//
//  Created by Will Carlough on 10/1/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongPauseMenu.h"
@class BlongMyScene;

@implementation BlongPauseMenu
+(BlongPauseMenu *) pauseMenuWithScene:(BlongMyScene *)scene {
    BlongPauseMenu *pauseMenu = [BlongPauseMenu new];
    [scene addChild:pauseMenu];
    
    SKLabelNode *ret = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    ret.color = [SKColor redColor];
    ret.text = @"whatever";
    ret.name = @"whatever";
    ret.fontSize = 20;
    ret.position = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame));
    ret.userInteractionEnabled = YES;
    pauseMenu.userInteractionEnabled = YES;
    [pauseMenu addChild:ret];
    
    return pauseMenu;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"lol");
}
@end
