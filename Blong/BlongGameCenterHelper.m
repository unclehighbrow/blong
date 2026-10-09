//
//  BlongGameCenterHelper.m
//  Blong
//
//  Created by Will Carlough on 1/18/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import "BlongGameCenterHelper.h"

@implementation BlongGameCenterHelper

static NSString *_highScore = 0;
static NSString *scoreBoardName = @"default2014";

+(NSString *) highScore {
    return _highScore;
}

+(void)retrieveScores {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (localPlayer.authenticated) {
        [GKLeaderboard loadLeaderboardsWithIDs:@[scoreBoardName] completionHandler:^(NSArray<GKLeaderboard *> *leaderboards, NSError *error) {
            if (error != nil || leaderboards.count == 0) {
                NSLog(@"couldn't get high score");
                return;
            }
            [leaderboards[0] loadEntriesForPlayers:@[localPlayer] timeScope:GKLeaderboardTimeScopeAllTime completionHandler:^(GKLeaderboardEntry *localPlayerEntry, NSArray<GKLeaderboardEntry *> *entries, NSError *error) {
                if (error != nil) {
                    NSLog(@"couldn't get high score");
                }
                if (localPlayerEntry != nil) {
                    _highScore = [NSString stringWithFormat:@"%ld", (long)localPlayerEntry.score];
                }
            }];
        }];
    }
}


+(void)reportScore:(int) score {
    if ([GKLocalPlayer localPlayer].authenticated) { // logged in
        [GKLeaderboard submitScore:score context:0 player:[GKLocalPlayer localPlayer] leaderboardIDs:@[scoreBoardName] completionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"that went poorly: %@", error);
            }
        }];
    }
    if (!_highScore || [_highScore intValue] < score) {
        _highScore = [NSString stringWithFormat:@"%d", score];
    }
}
@end
