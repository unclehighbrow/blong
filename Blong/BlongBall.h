//
//  BlongBall.h
//  Blong
//
//  Created by Will Carlough on 7/13/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class BlongMyScene;

@interface BlongBall : SKSpriteNode 
+(BlongBall *) ballOnLeft:(BOOL) left withScene:(BlongMyScene *) scene;

@end
