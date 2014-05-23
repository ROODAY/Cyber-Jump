//
//  PowerUpNode.m
//  Awesome
//
//  Created by block7 on 5/22/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "PowerUpNode.h"

@interface PowerUpNode()
{
    SKAction *_starSound;
    SKAction *_boostSound;
    SKAction *_powerUpSound;
}
@end

@implementation PowerUpNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    if (_powerUpType == 0) {
        if ([GameState sharedInstance].difficulty == 0) {
            [GameState sharedInstance].force = 20.0f;
        } else if ([GameState sharedInstance].difficulty == 1) {
            [GameState sharedInstance].force = 25.0f;
        } else if ([GameState sharedInstance].difficulty == 2) {
            [GameState sharedInstance].force = 30.0f;
        }
        
        [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
        [self.parent runAction:_starSound];
        [self removeFromParent];
        [GameState sharedInstance].score += (_starType == STAR_NORMAL ? 20 : 100);
        [GameState sharedInstance].stars += (_starType == STAR_NORMAL ? 1 : 5);
    } else if (_powerUpType == 1) {
        if ([GameState sharedInstance].difficulty == 0) {
            [GameState sharedInstance].force = 20.0f;
        } else if ([GameState sharedInstance].difficulty == 1) {
            [GameState sharedInstance].force = 25.0f;
        } else if ([GameState sharedInstance].difficulty == 2) {
            [GameState sharedInstance].force = 30.0f;
        }
        
        [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
        [self.parent runAction:_starSound];
        [self removeFromParent];
        [GameState sharedInstance].score += (_starType == STAR_NORMAL ? 20 : 100);
        [GameState sharedInstance].stars += (_starType == STAR_NORMAL ? 1 : 5);
    } else if (_powerUpType == 2) {
        if ([GameState sharedInstance].difficulty == 0) {
            [GameState sharedInstance].force = 20.0f;
        } else if ([GameState sharedInstance].difficulty == 1) {
            [GameState sharedInstance].force = 25.0f;
        } else if ([GameState sharedInstance].difficulty == 2) {
            [GameState sharedInstance].force = 30.0f;
        }
        
        [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
        [self.parent runAction:_starSound];
        [self removeFromParent];
    }
    
    return  YES;
}

- (id) init
{
    if (self = [super init]) {
        _starSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
        _boostSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
        _powerUpSound = [SKAction playSoundFileNamed:@"StarPing.wav" waitForCompletion:NO];
    }
    
    return self;
}

@end
