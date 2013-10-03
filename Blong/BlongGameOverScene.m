//
//  BlongGameOverScene.m
//  Blong
//
//  Created by Will Carlough on 10/3/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongGameOverScene.h"
#import "BlongMyScene.h"

@implementation BlongGameOverScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        SKLabelNode *gameOverText = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
        gameOverText.text = @"GAME OVER";
        gameOverText.color = [SKColor whiteColor];
        gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:gameOverText];
        
        SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"AvenirNext-Heavy"];
        go.color = [SKColor whiteColor];
        go.text = @"But whatever, let's do it again.";
        go.fontSize = 20;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/6);
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [go runAction:fadeIn];
        [self addChild:go];
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKScene *gameScene = [[BlongMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
    transition.pausesIncomingScene = NO;
    [self.view presentScene:gameScene transition:transition];
}
@end
