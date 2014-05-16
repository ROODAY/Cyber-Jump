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
    if ([GameState sharedInstance].difficulty == 0) {
        [GameState sharedInstance].force = 300.0f;
    } else if ([GameState sharedInstance].difficulty == 1) {
        [GameState sharedInstance].force = 325.0f;
    } else if ([GameState sharedInstance].difficulty == 2) {
        [GameState sharedInstance].force = 350.0f;
    }
    
    if (player.physicsBody.velocity.dy < 0) {
        player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force);
        
        if (_platformType == PLATFORM_BREAK) {
            [self removeFromParent];
        }
    }
    
    return NO;
}

@end
