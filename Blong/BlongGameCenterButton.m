//
//  BlongGameCenterButton.m
//  Blong
//
//  Created by Will Carlough on 1/18/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import "BlongGameCenterButton.h"

@implementation BlongGameCenterButton
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [(BlongViewController *)self.scene.view.window.rootViewController showGameCenter];
}
+(BlongGameCenterButton *)gameCenterButtonWithScene:(SKScene *)scene {
    BlongGameCenterButton *gameCenterButton = [BlongGameCenterButton spriteNodeWithImageNamed:@"game_center_button"];
    gameCenterButton.position = CGPointMake(gameCenterButton.frame.size.width/2, gameCenterButton.frame.size.height/2);
    gameCenterButton.userInteractionEnabled = YES;
    [scene addChild:gameCenterButton];
    return gameCenterButton;
}
@end
