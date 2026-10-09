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

CGFloat blongSideInset = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView *skView = (SKView *)self.view;
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    skView.multipleTouchEnabled = YES;
    skView.backgroundColor = darknessColor; // no white flash between launch screen and first scene
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // Wait until the view is in the window so bounds and safe area are the real screen's.
    SKView *skView = (SKView *)self.view;
    if (skView.scene || !skView.window) {
        return;
    }

    // Keep both sides symmetric, clear of the Dynamic Island / notch.
    UIEdgeInsets safeInsets = self.view.safeAreaInsets;
    blongSideInset = MAX(safeInsets.left, safeInsets.right);

    // Create and configure the scene.
    SKScene *scene = [BlongMainMenu sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden
{
    return YES;
}

// Thumbs live near the edges; don't let a paddle swipe pull up Home or Control Center.
- (UIRectEdge)preferredScreenEdgesDeferringSystemGestures
{
    return UIRectEdgeAll;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeLeft;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) showGameCenter {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] initWithState:GKGameCenterViewControllerStateDefault];
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
