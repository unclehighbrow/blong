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

BlongMyScene *blongScene;

@implementation BlongPauseMenu
+(BlongPauseMenu *) pauseMenuWithScene:(BlongMyScene *)incoming {
    if (!incoming.paused) {
        BlongPauseMenu *pauseMenu = [[BlongPauseMenu alloc] initWithSize:incoming.size];
        [incoming.view presentScene:pauseMenu];
        blongScene = incoming;
        
        pauseMenu.backgroundColor = darknessColor;
        /*
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(CGRectGetMidX(pauseMenu.frame), CGRectGetMidY(pauseMenu.frame));
        [pauseMenu addChild:background];
        */
        
        SKLabelNode *continueButton = [SKLabelNode labelNodeWithFontNamed:headFont];
        continueButton.text = @"CONTINUE";
        continueButton.name = continueString;

        continueButton.fontColor = tintColor;
        continueButton.position = CGPointMake(CGRectGetMidX(incoming.frame), CGRectGetMidY(incoming.frame) + continueButton.frame.size.height);
        [pauseMenu addChild:continueButton];
        
        SKLabelNode *mainMenuButton = [SKLabelNode labelNodeWithFontNamed:headFont];
        mainMenuButton.text = @"MAIN MENU";
        mainMenuButton.name = mainMenuString;

        mainMenuButton.fontColor = tintColor;
        mainMenuButton.position = CGPointMake(CGRectGetMidX(incoming.frame), CGRectGetMidY(incoming.frame) - mainMenuButton.frame.size.height);
        [pauseMenu addChild:mainMenuButton];

        incoming.paused = YES;
        
        return pauseMenu;
    }
    return nil;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = (UITouch *) [touches anyObject];
    NSString *action =  [self nodeAtPoint:[touch locationInNode:self]].name;
    if (action != nil) {
        if ([action isEqualToString:continueString]) {
//            SKTransition *transition = [SKTransition flipHorizontalWithDuration:.3];
            [self.scene.view presentScene:blongScene]; //  transition:transition
        } else if ([action isEqualToString:mainMenuString]) {
            SKScene *menuScene = [[BlongMainMenu alloc] initWithSize:self.scene.size];
            SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
            [self.scene.view presentScene:menuScene transition:transition];
        }
    }
}
@end
