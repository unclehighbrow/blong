//
//  BlongMainMenu.m
//  Blong
//
//  Created by Will Carlough on 10/1/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongMainMenu.h"
#import "BlongMyScene.h"
#import "BlongGameCenterButton.h"
#import "BlongGameCenterHelper.h"

@implementation BlongMainMenu

SKLabelNode *go;
BlongGameCenterButton *gameCenterButton;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"title"];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:title];
        
        go = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
        go.color = [SKColor whiteColor];
        go.text = @"Let's do this.";
        go.fontSize = 20;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/6);
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [go runAction:fadeIn];
        [self addChild:go];
        
        gameCenterButton = [BlongGameCenterButton spriteNodeWithImageNamed:@"game_center_button"];
        gameCenterButton.position = CGPointMake(gameCenterButton.frame.size.width/2, gameCenterButton.frame.size.height/2);
        gameCenterButton.userInteractionEnabled = YES;
        [self addChild:gameCenterButton];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    go.color = [SKColor blackColor];
    SKScene *gameScene = [[BlongMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
    transition.pausesIncomingScene = NO;
    [self.view presentScene:gameScene transition:transition];
}

@end
