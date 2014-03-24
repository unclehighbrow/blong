//
//  BlongGameOverScene.h
//  Blong
//
//  Created by Will Carlough on 10/3/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class BlongGameCenterHelper;

@interface BlongGameOverScene : SKScene
-(id)initWithSize:(CGSize)size andScore:(int) score;
@property int score;
@end
