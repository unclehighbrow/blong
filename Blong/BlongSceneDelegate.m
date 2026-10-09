//
//  BlongSceneDelegate.m
//  Blong
//

#import "BlongSceneDelegate.h"
#import "BlongMyScene.h"
#import "BlongPauseMenu.h"
#import "BlongGameCenterHelper.h"
#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>

@implementation BlongSceneDelegate

BOOL gameCenter = YES;

-(void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    if (gameCenter) {
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        localPlayer.authenticateHandler = ^(UIViewController *loginVC, NSError *error) {
            if ([GKLocalPlayer localPlayer].authenticated) { // logged in
                [BlongGameCenterHelper retrieveScores];
            } else if (loginVC) { // logging in
                [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
            } else { // logged out
            }
        };
    }
}

-(void)sceneWillResignActive:(UIScene *)scene {
    SKView *view = (SKView *) self.window.rootViewController.view;
    view.paused = YES;

    // prevent audio crash
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

-(void)sceneDidEnterBackground:(UIScene *)scene {
    // prevent audio crash
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

-(void)sceneWillEnterForeground:(UIScene *)scene {
    // resume audio
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

-(void)sceneDidBecomeActive:(UIScene *)scene {
    SKView *view = (SKView *) self.window.rootViewController.view;
    view.paused = NO;
    if ([view.scene isKindOfClass:[BlongMyScene class]]) {
        [BlongPauseMenu pauseMenuWithScene:(BlongMyScene *)view.scene];
    }
}

@end
