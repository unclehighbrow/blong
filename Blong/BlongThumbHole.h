//
//  BlongThumbHole.h
//  Blong
//
//  Created by Will Carlough on 10/3/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BlongMyScene.h"

@interface BlongThumbHole : SKSpriteNode
+(BlongThumbHole *) thumbHoleOnLeft:(BOOL)left WithScene:(BlongMyScene *)scene;
-(void) explode;
@end
