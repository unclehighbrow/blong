//
//  BlongGameCenterButton.m
//  Blong
//
//  Created by Will Carlough on 1/18/14.
//  Copyright (c) 2014 Will Carlough. All rights reserved.
//

#import "BlongGameCenterButton.h"

@implementation BlongGameCenterButton
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [(BlongViewController *)self.scene.view.window.rootViewController showGameCenter];
}
+(SKSpriteNode *)spriteNodeWithImageNamed:(NSString *)name {
    if (self = [super name]) {
        
    }
    return self;
}
@end
