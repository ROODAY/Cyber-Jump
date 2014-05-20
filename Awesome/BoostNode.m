//
//  BoostNode.m
//  Awesome
//
//  Created by block7 on 5/19/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "BoostNode.h"
@import AVFoundation;

@interface BoostNode()
{
    SKAction *_boostSound;
}
@end

@implementation BoostNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    if ([GameState sharedInstance].difficulty == 0) {
        [GameState sharedInstance].force = 10.0f;
    } else if ([GameState sharedInstance].difficulty == 1) {
        [GameState sharedInstance].force = 15.0f;
    } else if ([GameState sharedInstance].difficulty == 2) {
        [GameState sharedInstance].force = 20.0f;
    }
    
    //player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force);
    [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
    [self.parent runAction:_boostSound];
    [GameState sharedInstance].boostsLeft++;
    [self removeFromParent];
    
    return  YES;
}

- (id) init
{
    if (self = [super init]) {
        _boostSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
    }
    
    return self;
}

@end
