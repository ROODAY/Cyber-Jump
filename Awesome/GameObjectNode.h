//
//  GameObjectNode.h
//  Awesome
//
//  Created by block7 on 4/9/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameObjectNode : SKNode

- (BOOL) collisionWithPlayer:(SKNode *)player;
- (void) checkNodeRemoval:(CGFloat)playerY;

@end
