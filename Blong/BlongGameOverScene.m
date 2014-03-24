//
//  BlongGameOverScene.m
//  Blong
//
//  Created by Will Carlough on 10/3/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongGameOverScene.h"
#import "BlongMyScene.h"
#import "BlongGameCenterButton.h"
#import "BlongGameCenterHelper.h"

@implementation BlongGameOverScene
-(id)initWithSize:(CGSize)size andScore:(int) score {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        SKLabelNode *gameOverText = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        gameOverText.text = @"GAME OVER";
        gameOverText.color = [SKColor whiteColor];
        gameOverText.fontSize = 40;
        gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.height/5);
        [self addChild:gameOverText];
        
        SKLabelNode *scoreText = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        scoreText.text = [NSString stringWithFormat:@"%d", score];
        scoreText.fontSize = 50;
        scoreText.color = [SKColor whiteColor];
        scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:scoreText];
        
        SKLabelNode *highScoreText = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        highScoreText.text = [NSString stringWithFormat:@"HIGH SCORE: %@", [BlongGameCenterHelper highScore]];
        highScoreText.fontSize = 10;
        highScoreText.color = [SKColor whiteColor];
        highScoreText.position = CGPointMake(highScoreText.frame.size.width/2, self.frame.size.height - highScoreText.frame.size.height);
        [self addChild:highScoreText];
        
        SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        go.color = [SKColor whiteColor];
        go.alpha = 0;
        go.text = @"BUT WHATEVER, LET'S DO IT AGAIN";
        go.fontSize = 20;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/6);
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [self addChild:go];
        [go runAction:fadeIn];
        
        [BlongGameCenterButton gameCenterButtonWithScene:self];

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
