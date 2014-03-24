//
//  BlongGameCenterHelper.h
//  Blong
//
//  Created by Will Carlough on 1/18/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface BlongGameCenterHelper : NSObject
+(void) retrieveScores;
+(void) reportScore:(int) score;
+(NSString *) highScore;

@end
