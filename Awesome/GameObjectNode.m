//
//  GameObjectNode.m
//  Awesome
//
//  Created by block7 on 4/9/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "GameObjectNode.h"

@implementation GameObjectNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    return NO;
}
- (void) checkNodeRemoval:(CGFloat)playerY
{
    if (playerY > self.position.y + 300.0f) {
        [self removeFromParent];
    }
}

@end
