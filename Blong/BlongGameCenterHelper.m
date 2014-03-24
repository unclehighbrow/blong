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
        GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] initWithPlayerIDs: @[localPlayer.playerID]];
        if (leaderboardRequest != nil) {
            leaderboardRequest.playerScope = GKLeaderboardPlayerScopeFriendsOnly;
            leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
            leaderboardRequest.identifier = scoreBoardName;
            leaderboardRequest.range = NSMakeRange(1,1);
            [leaderboardRequest loadScoresWithCompletionHandler: ^(NSArray *scores, NSError *error) {
                if (error != nil) {
                    NSLog(@"couldn't get high score");
                }
                if (scores != nil) {
                    _highScore = [NSString stringWithFormat:@"%lld", ((GKScore *)scores[0]).value];
                }
            }];
        }
    }
}


+(void)reportScore:(int) score {
    if ([GKLocalPlayer localPlayer].authenticated) { // logged in
        GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:scoreBoardName];
        scoreReporter.value = score;
        scoreReporter.context = 0;
        if (!_highScore || [_highScore intValue] < score) {
            _highScore = [NSString stringWithFormat:@"%d", score];
        }
        
        [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
            if (error) {
                NSLog(@"that went poorly: %@", error);
            }
        }];
    }
}
@end
