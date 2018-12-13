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

static int quipsSeen = 0;
SKLabelNode *goGameOver;

@implementation BlongGameOverScene
-(id)initWithSize:(CGSize)size andScore:(int) score {
    if (self = [super initWithSize:size]) {
        [self runAction:[SKAction playSoundFileNamed:@"game_over.m4a" waitForCompletion:NO]];
        
        self.backgroundColor = darknessColor;
        
        
        
        SKLabelNode *scoreText = [SKLabelNode labelNodeWithFontNamed:headFont];
        scoreText.text = [NSString stringWithFormat:@"%d", score];
        scoreText.fontSize = headFontSize;
        scoreText.fontColor = headColor;
        scoreText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        scoreText.position = CGPointMake( CGRectGetMidX(self.frame), self.frame.size.height - ((self.frame.size.height/5)*2));
        [self addChild:scoreText];
        
        
        SKLabelNode *gameOverText = [SKLabelNode labelNodeWithFontNamed:headFont];
        gameOverText.text = @"GAME OVER";
        gameOverText.fontColor = warningColor;
        gameOverText.fontSize = headFontSize;
        gameOverText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - ((self.frame.size.height/5)*1));
        [self addChild:gameOverText];
        

        SKLabelNode *highScoreText = [SKLabelNode labelNodeWithFontNamed:regFont];
        NSString *highScoreString = [BlongGameCenterHelper highScore];
        if ([highScoreString isEqualToString:scoreText.text] && score > 0) {
            highScoreText.text = @"Hey, that's the high score!";
        } else {
            highScoreText.text = [NSString stringWithFormat:@"HIGH SCORE: %@", highScoreString];
        }
        
        highScoreText.fontSize = baseFontSize;
        highScoreText.fontColor = headColor;
        highScoreText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        highScoreText.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - ((self.frame.size.height/5)*3));
        [self addChild:highScoreText];
        
        
        NSArray *quips = @[
                           @"But whatever, Let's do it again.",
                           @"Are you playing this on the toilet? gross.",
                           @"Are you enjoying this? I am.",
                           @"Do you like Limp Bizkit?",
                           @"Share this on Twitter. but you have to do it yourself.",
                           @"We're really letting the dogs out.",
                           @"I get it. you like Blong.",
                           @"You ever see that movie Taken? it's pretty good.",
                           @"What's with Snapchat? I really don't get it.",
                           @"Are video games art? Is art even art?",
                           @"Where are the diamonds!?!",
                           @"Do you like Internet Jokes? I do.",
                           @"I think I'm falling in love with you.",
                           @"This is a real Blong.",
                           @"You're cute. But what do I know, I'm just a phone.",
                           @"Bread is weird. It's cooked but you cook it more and it's toast."
                           ];

        goGameOver = [SKLabelNode labelNodeWithFontNamed:headFont];
        goGameOver.fontColor = tintColor;
        goGameOver.alpha = 0;
        goGameOver.text = quipsSeen > 2 ? [quips objectAtIndex:(arc4random() % quips.count)] : [quips objectAtIndex:0];
        quipsSeen++;
        goGameOver.fontSize = tinyFontSize;
        while (goGameOver.frame.size.width > self.frame.size.width  && goGameOver.fontSize > 2) {
            goGameOver.fontSize = goGameOver.fontSize - 1;
        }
        goGameOver.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        goGameOver.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - ((self.frame.size.height/5)*4) );
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [self addChild:goGameOver];
        [goGameOver runAction:fadeIn];
        [BlongGameCenterButton gameCenterButtonWithScene:self];

    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    goGameOver.fontColor = activeColor;
    goGameOver.colorBlendFactor = 1.0;
    SKScene *gameScene = [[BlongMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
    transition.pausesIncomingScene = NO;
    [self.view presentScene:gameScene transition:transition];
}
@end
