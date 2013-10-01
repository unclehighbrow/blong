//
//  BlongPauseButton.m
//  Blong
//
//  Created by Will Carlough on 10/1/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongPauseButton.h"
#import "BlongPauseMenu.h"
@class BlongMyScene;

@implementation BlongPauseButton

+(BlongPauseButton *) pauseButtonWithScene:(BlongMyScene *)scene {
    BlongPauseButton *pauseButton = [BlongPauseButton spriteNodeWithImageNamed:@"ball"];
    pauseButton.userInteractionEnabled = YES;
    pauseButton.position = CGPointMake(scene.size.width - pauseButton.size.width, pauseButton.size.height/2);
    [scene addChild:pauseButton];
    return pauseButton;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"pausing");
    self.scene.paused = YES;
    [BlongPauseMenu pauseMenuWithScene:(BlongMyScene *)self.scene];
}

@end
