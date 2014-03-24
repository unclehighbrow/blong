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
AVAudioPlayer *backgroundAudioPlayer;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        SKSpriteNode *title = [SKSpriteNode spriteNodeWithImageNamed:@"title"];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:title];
        [self startBackgroundMusic];
        
        
        go = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        go.fontColor = [SKColor whiteColor];
        go.text = @"LET'S DO THIS.";
        go.fontSize = 40;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/6);
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [go runAction:fadeIn];
        [self addChild:go];
        
        [BlongGameCenterButton gameCenterButtonWithScene:self];
    }
    return self;
}

- (void)startBackgroundMusic {
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"intro.m4a" ofType:nil]];
    backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [backgroundAudioPlayer prepareToPlay];
    backgroundAudioPlayer.numberOfLoops = 1;
    [backgroundAudioPlayer setVolume:1.0];
    [backgroundAudioPlayer play];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [backgroundAudioPlayer stop];
    go.fontColor = [SKColor blackColor];
    SKScene *gameScene = [[BlongMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
    transition.pausesIncomingScene = NO;
    [self.view presentScene:gameScene transition:transition];
}

@end
