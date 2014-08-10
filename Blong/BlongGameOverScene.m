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
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
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
        NSString *highScoreString = [BlongGameCenterHelper highScore];
        highScoreText.text = [NSString stringWithFormat:@"HIGH SCORE: %@", highScoreString];
        highScoreText.fontSize = 10;
        highScoreText.color = [SKColor whiteColor];
        highScoreText.position = CGPointMake(highScoreText.frame.size.width/2, self.frame.size.height - highScoreText.frame.size.height);
        [self addChild:highScoreText];
        
        
        NSArray *quips = @[
                           @"BUT WHATEVER, LET'S DO IT AGAIN.",
                           @"ARE YOU PLAYING THIS ON THE TOILET? GROSS.",
                           @"ARE YOU ENJOYING THIS? I AM.",
                           @"DO YOU LIKE LIMP BIZKIT?",
                           @"SHARE THIS ON TWITTER. BUT YOU HAVE TO DO IT YOURSELF.",
                           @"WE'RE REALLY LETTING THE DOGS OUT.",
                           @"I GET IT. YOU LIKE BLONG.",
                           @"YOU EVER SEE THAT MOVIE TAKEN? IT'S PRETTY GOOD.",
                           @"WHAT'S WITH SNAPCHAT? I REALLY DON'T GET IT.",
                           @"ARE VIDEO GAMES ART? IS ART EVEN ART?",
                           @"WHERE ARE THE DIAMONDS!?!",
                           @"DO YOU LIKE INTERNET JOKES? I DO.",
                           @"I THINK I'M FALLING IN LOVE WITH YOU.",
                           @"THIS IS A REAL BLONG.",
                           @"YOU'RE CUTE. BUT WHAT DO I KNOW, I'M JUST A PHONE.",
                           @"BREAD IS WEIRD. IT'S COOKED BUT YOU COOK IT MORE AND IT'S TOAST."
                           ];
        
        go = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        go.color = [SKColor whiteColor];
        go.alpha = 0;
        if ([highScoreString isEqualToString:scoreText.text] && score > 0) {
            go.text = @"HEY THAT'S A HIGH SCORE! LET'S DO IT AGAIN.";
        } else {
            go.text = quipsSeen > 2 ? [quips objectAtIndex:(arc4random() % quips.count)] : [quips objectAtIndex:0];
        }
        quipsSeen++;
        go.fontSize = 15;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/5);
        SKAction *fadeIn = [SKAction fadeInWithDuration:1];
        [self addChild:go];
        [go runAction:fadeIn];
        [BlongGameCenterButton gameCenterButtonWithScene:self];

    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    go.color = [SKColor yellowColor];
    go.colorBlendFactor = 1.0;
    SKScene *gameScene = [[BlongMyScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
    transition.pausesIncomingScene = NO;
    [self.view presentScene:gameScene transition:transition];
}
@end
