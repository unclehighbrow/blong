//
//  BlongViewController.m
//  Blong
//
//  Created by Will Carlough on 7/7/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongViewController.h"
#import "BlongMyScene.h"
#import "BlongMainMenu.h"

@implementation BlongViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Create and configure the scene.
    CGSize boundsSize = self.view.bounds.size;
    
    SKScene *scene;

    float osVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (osVersion > 7.5) {
        scene = [BlongMainMenu sceneWithSize:CGSizeMake(boundsSize.width, boundsSize.height)];
    } else {
        scene = [BlongMainMenu sceneWithSize:CGSizeMake(boundsSize.height, boundsSize.width)];
    }
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) showGameCenter {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
