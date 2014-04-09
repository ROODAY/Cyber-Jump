//
//  PlatformNode.m
//  Awesome
//
//  Created by block7 on 4/9/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "PlatformNode.h"

@implementation PlatformNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    if (player.physicsBody.velocity.dy < 0) {
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 250.0f);
        
        if (_platformType == PLATFORM_BREAK) {
            [self removeFromParent];
        }
    }
    
    return NO;
}

@end
