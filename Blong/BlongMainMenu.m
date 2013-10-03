//
//  BlongMainMenu.m
//  Blong
//
//  Created by Will Carlough on 10/1/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongMainMenu.h"
#import "BlongMyScene.h"

@implementation BlongMainMenu
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        title.fontSize = 50;
        title.text = @"BLONG";
        title.color = [SKColor whiteColor];
        title.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:title];
        
        SKLabelNode *go = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
        go.text = @"*(let's have an awesome time)*";
        go.fontSize = 20;
        go.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height/4);
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
