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
    SKAction *_jetpackSound;
}
@end

@implementation PowerUpNode

- (BOOL) collisionWithPlayer:(SKNode *)player
{
    if (_powerUpType == STAR) {
        NSLog(@"Star hit");
        if ([GameState sharedInstance].difficulty == 0) {
            [GameState sharedInstance].force = 30.0f;
        } else if ([GameState sharedInstance].difficulty == 1) {
            [GameState sharedInstance].force = 25.0f;
        } else if ([GameState sharedInstance].difficulty == 2) {
            [GameState sharedInstance].force = 20.0f;
        }
        
        [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
        [self.parent runAction:_starSound];
        [self removeFromParent];
        [GameState sharedInstance].score += (_starType == STAR_NORMAL ? 20 : 100);
        [GameState sharedInstance].stars += (_starType == STAR_NORMAL ? 1 : 5);
        return YES;
    } else if (_powerUpType == JETPACK) {
        NSLog(@"Jetpack hit");
        if ([GameState sharedInstance].difficulty == 0) {
            [GameState sharedInstance].force = 100.0f;
        } else if ([GameState sharedInstance].difficulty == 1) {
            [GameState sharedInstance].force = 80.0f;
        } else if ([GameState sharedInstance].difficulty == 2) {
            [GameState sharedInstance].force = 60.0f;
        }
        
        [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
        [self.parent runAction:_jetpackSound];
        [self removeFromParent];
        return YES;
    } else if (_powerUpType == BOOST) {
        NSLog(@"Boost hit");
        if ([GameState sharedInstance].difficulty == 0) {
            [GameState sharedInstance].force = 40.0f;
        } else if ([GameState sharedInstance].difficulty == 1) {
            [GameState sharedInstance].force = 35.0f;
        } else if ([GameState sharedInstance].difficulty == 2) {
            [GameState sharedInstance].force = 30.0f;
        }
        
        [player.physicsBody applyImpulse:CGVectorMake(player.physicsBody.velocity.dx, [GameState sharedInstance].force)];
        [self.parent runAction:_boostSound];
        [self removeFromParent];
        [GameState sharedInstance].boostsLeft++;
        return YES;
    }
    
    return  NO;
}

- (id) init
{
    if (self = [super init]) {
        _starSound = [SKAction playSoundFileNamed:@"star.wav" waitForCompletion:NO];
        _boostSound = [SKAction playSoundFileNamed:@"boost.wav" waitForCompletion:NO];
        _jetpackSound = [SKAction playSoundFileNamed:@"jetpack.wav" waitForCompletion:NO];
    }
    
    return self;
}

@end
