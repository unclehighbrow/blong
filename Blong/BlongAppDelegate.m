//
//  BlongAppDelegate.m
//  Blong
//
//  Created by Will Carlough on 7/7/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import "BlongAppDelegate.h"
#import "BlongMyScene.h"
#import "BlongPauseMenu.h"
#import <SpriteKit/SpriteKit.h>
#import <GameKit/GameKit.h>


@implementation BlongAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    localPlayer.authenticateHandler = ^(UIViewController *loginVC, NSError *error) {
        NSLog(@"woooo %@", error);
        if ([GKLocalPlayer localPlayer].authenticated) {
            NSLog(@"what ho %@", [GKLocalPlayer localPlayer].alias);
        } else if (loginVC) {
            [self.window.rootViewController presentViewController:loginVC animated:YES completion:nil];
        } else {
            NSLog(@"no dice");
        }
    };
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    SKView *view = (SKView *) self.window.rootViewController.view;
    BlongMyScene *scene = (BlongMyScene *) view.scene;
    scene.paused = YES;
    [BlongPauseMenu pauseMenuWithScene:(BlongMyScene *)scene];

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
