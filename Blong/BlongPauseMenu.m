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

NSString *pauseMenuString = @"pause_menu";
NSString *continueString = @"continue";
NSString *mainMenuString = @"main_menu";

@implementation BlongPauseMenu
+(BlongPauseMenu *) pauseMenuWithScene:(BlongMyScene *)scene {
    if ([scene childNodeWithName:pauseMenuString] != nil) {
        scene.paused = YES;
        return nil;
    }
    if (!scene.paused) {
        BlongPauseMenu *pauseMenu = [BlongPauseMenu new];
        pauseMenu.name = pauseMenuString;
        pauseMenu.userInteractionEnabled = YES;
        [scene addChild:pauseMenu];
        
        SKLabelNode *continueButton = [SKLabelNode labelNodeWithFontNamed:headFont];
        continueButton.text = @"CONTINUE";
        continueButton.name = continueString;
        continueButton.fontColor = tintColor;
        continueButton.position = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame) + continueButton.frame.size.height);
        [pauseMenu addChild:continueButton];
        
        SKLabelNode *mainMenuButton = [SKLabelNode labelNodeWithFontNamed:headFont];
        mainMenuButton.text = @"MAIN MENU";
        mainMenuButton.name = mainMenuString;
        mainMenuButton.fontColor = tintColor;
        mainMenuButton.position = CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame) - mainMenuButton.frame.size.height);
        [pauseMenu addChild:mainMenuButton];

        scene.paused = YES;
        
        return pauseMenu;
    }
    return nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *) [touches anyObject];
    NSString *action =  [self nodeAtPoint:[touch locationInNode:self]].name;
    if (action != nil) {
        if ([action isEqualToString:continueString]) {
            self.scene.paused = NO;
            [self removeFromParent];
        } else if ([action isEqualToString:mainMenuString]) {
            SKScene *menuScene = [[BlongMainMenu alloc] initWithSize:self.scene.size];
            SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
            [self.scene.view presentScene:menuScene transition:transition];
        }
    }
}
@end
