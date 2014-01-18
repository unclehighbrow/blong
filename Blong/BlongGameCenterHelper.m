//
//  BlongGameCenterHelper.m
//  Blong
//
//  Created by Will Carlough on 1/18/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import "BlongGameCenterHelper.h"

@implementation BlongGameCenterHelper

+ (void) retrieveScores {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (localPlayer.authenticated) {
        GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayerIDs: @[localPlayer.playerID]];
        if (leaderboardRequest != nil) {
            leaderboardRequest.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
            leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardRequest.identifier = @"default2014";
            leaderboardRequest.range = NSMakeRange(1,1);
            [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                if (error != nil) {
                    NSLog(@"coulnd't get high score");
                }
                if (scores != nil) {
                    NSLog(@"got score %@", ((GKScore *)scores[0]).formattedValue);
                }
            }];
        }
    }
}


+(void)reportScore:(int) score {
    if ([GKLocalPlayer localPlayer].authenticated) { // logged in
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@"default2014"];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"that went poorly: %@", error);
            }
        }];
    }
}
@end
