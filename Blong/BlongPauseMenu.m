//
//  BlongPauseMenu.m
//  Blong
//
//  Created by Will Carlough on 10/1/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongPauseMenu.h"
#import "BlongMainMenu.h"
@class BlongMyScene;

@implementation BlongPauseMenu
+(BlongPauseMenu *) pauseMenuWithScene:(BlongMyScene *)scene {
    BlongPauseMenu *pauseMenu = [BlongPauseMenu new];
    pauseMenu.userInteractionEnabled = YES;
    [scene addChild:pauseMenu];
    
    SKSpriteNode *continueButton = [SKSpriteNode spriteNodeWithImageNamed:@"continue"];
    continueButton.name = @"continue";
    continueButton.position = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame) + continueButton.size.height);
    [pauseMenu addChild:continueButton];
    
    SKSpriteNode *mainMenuButton = [SKSpriteNode spriteNodeWithImageNamed:@"main_menu"];
    mainMenuButton.name = @"main_menu";
    mainMenuButton.position = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame) - mainMenuButton.size.height);
    [pauseMenu addChild:mainMenuButton];
    
    
    return pauseMenu;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *) [touches anyObject];
    NSString *action =  [self nodeAtPoint:[touch locationInNode:self]].name;
    if (action != nil) {
        if ([action isEqualToString:@"continue"]) {
            self.scene.paused = NO;
            [self removeFromParent];
        } else if ([action isEqualToString:@"main_menu"]) {
            SKScene *menuScene = [[BlongMainMenu alloc] initWithSize:self.scene.size];
            SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
            [self.scene.view presentScene:menuScene transition:transition];
        }
    }
}
@end
