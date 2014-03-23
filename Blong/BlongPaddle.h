//
//  BlongPaddle.h
//  Blong
//
//  Created by Will Carlough on 9/30/13.
//  Copyright (c) 2013 Will Carlough. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BlongPaddle : SKSpriteNode {

}
+(BlongPaddle *) paddle:(NSString *)image;
-(void) shrink:(float)shrinkage;
-(void) getPhysical;
@end
