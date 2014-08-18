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
SKLabelNode *go;

@implementation BlongGameOverScene
-(id)initWithSize:(CGSize)size andScore:(int) score {
    if (self = [super initWithSize:size]) {
        [self runAction:[SKAction playSoundFileNamed:@"game_over.m4a" waitForCompletion:NO]];
        
        self.backgroundColor = darknessColor;
        
	SKLabelNode *gameOverText = [SKLabelNode labelNodeWithFontNamed:headFont];
        gameOverText.text = @"GAME OVER";
        gameOverText.fontColor = warningColor;
        gameOverText.fontSize = headFontSize;
        gameOverText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + self.frame.size.height/5);
        [self addChild:gameOverText];
        
        SKLabelNode *scoreText = [SKLabelNode labelNodeWithFontNamed:headFont];
        scoreText.text = [NSString stringWithFormat:@"%d", score];
        scoreText.fontSize = headFontSize;
        scoreText.fontColor = headColor;
        scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:scoreText];
        
        SKLabelNode *highScoreText = [SKLabelNode labelNodeWithFontNamed:regFont];
        NSString *highScoreString = [BlongGameCenterHelper highScore];
        highScoreText.text = [NSString stringWithFormat:@"HIGH SCORE: %@", highScoreString];
        highScoreText.fontSize = tinyFontSize;
        highScoreText.fontColor = tintColor;
        highScoreText.position = CGPointMake(highScoreText.frame.size.width/2, self.frame.size.height - highScoreText.frame.size.height);
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

        go = [SKLabelNode labelNodeWithFontNamed:headFont];
        go.fontColor = tintColor;
        go.alpha = 0;
        if ([highScoreString isEqualToString:scoreText.text] && score > 0) {
            go.text = @"Hey that's a high score! Let's do it again.";
        } else {
            go.text = quipsSeen > 2 ? [quips objectAtIndex:(arc4random() % quips.count)] : [quips objectAtIndex:0];
        }
        quipsSeen++;
        go.fontSize = baseFontSize;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/4);
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [self addChild:go];
        [go runAction:fadeIn];
        [BlongGameCenterButton gameCenterButtonWithScene:self];

    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    go.fontColor = activeColor;
    go.colorBlendFactor = 1.0;
    SKScene *gameScene = [[BlongMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
    transition.pausesIncomingScene = NO;
    [self.view presentScene:gameScene transition:transition];
}
@end
