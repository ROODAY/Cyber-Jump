//
//  StarNode.m
//  Awesome
//
//  Created by block7 on 4/9/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "StarNode.h"
@import AVFoundation;

@interface StarNode()
{
    SKAction *_starSound;
}
@end

@implementation StarNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    if ([GameState sharedInstance].difficulty == 0) {
        [GameState sharedInstance].force = 350.0f;
    } else if ([GameState sharedInstance].difficulty == 1) {
        [GameState sharedInstance].force = 400.0f;
    } else if ([GameState sharedInstance].difficulty == 2) {
        [GameState sharedInstance].force = 450.0f;
    }
    
    player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force);
    [self.parent runAction:_starSound];
    [self removeFromParent];
    [GameState sharedInstance].score += (_starType == STAR_NORMAL ? 20 : 100);
    [GameState sharedInstance].stars += (_starType == STAR_NORMAL ? 1 : 5);
    
    return  YES;
}

- (id) init
{
    if (self = [super init]) {
        _starSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
    }
    
    return self;
}

@end
