//
//  BlongLoadingScene.m
//  Blong
//
//  Created by Will Carlough on 3/11/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import "BlongLoadingScene.h"
#import "BlongMyScene.h"
#import "BlongMainMenu.h"


@implementation BlongLoadingScene
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        NSLog(@"initing loading scene");
        SKLabelNode *loadingText = [SKLabelNode labelNodeWithFontNamed:@"Checkbook"];
        loadingText.text = @"Loading";
        loadingText.position = CGPointMake(CGRectGetMidX(self.frame) - loadingText.frame.size.width/2, CGRectGetMidY(self.frame));
        loadingText.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [self addChild:loadingText];
        
        SKAction *dotAction = [SKAction runBlock:^{
            if ([loadingText.text isEqual: @"Loading..."]) {
                loadingText.text = @"Loading";
            } else {
                loadingText.text = [loadingText.text stringByAppendingString:@"."];
            }
        }];
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *repeatDotAction = [SKAction repeatActionForever:[SKAction sequence:@[dotAction, wait]]];
        [loadingText runAction:repeatDotAction];
    }
    return self;
}


-(void) didMoveToView:(SKView *)view {
    NSLog(@"loading scene did move to view");
//    NSArray *textureArray = @[
//        [SKTexture textureWithImageNamed:@"blong_background"],
//        [SKTexture textureWithImageNamed:@"game_center_button"],
//        [SKTexture textureWithImageNamed:@"left_paddle"],
//        [SKTexture textureWithImageNamed:@"right_paddle"],
//        [SKTexture textureWithImageNamed:@"continue"],
//        [SKTexture textureWithImageNamed:@"main_menu"],
//        [SKTexture textureWithImageNamed:@"spark"],
//        [SKTexture textureWithImageNamed:@"ball"],
//        [SKTexture textureWithImageNamed:@"pause_button"],
//        [SKTexture textureWithImageNamed:@"title"],
//        [SKTexture textureWithImageNamed:@"brick6"]
//    ];
//    
//    [SKAction playSoundFileNamed:@"intro.m4a" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"balls_coming_in.aif" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"11.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"29.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"bip.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"bop.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"game_over.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"game_over2.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"level_start.wav" waitForCompletion:NO];
//    [SKAction playSoundFileNamed:@"new_level.wav" waitForCompletion:NO];
//    
//    
//    
//    [SKTexture preloadTextures:textureArray withCompletionHandler:^
//     {
//         // The textures are loaded into memory. Start the level.
//         SKScene *menuScene = [[BlongMainMenu alloc] initWithSize:self.size];
//         SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
//         transition.pausesIncomingScene = NO;
//         [self.view presentScene:menuScene transition:transition];
//     }];
    
            // The textures are loaded into memory. Start the level.
            SKScene *menuScene = [[BlongMainMenu alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition flipHorizontalWithDuration:1];
             transition.pausesIncomingScene = NO;
             [self.view presentScene:menuScene transition:transition];
    
}

@end
