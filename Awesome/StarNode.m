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
    player.physicsBody.velocity = CGVectorMake(player.physicsBody.velocity.dx, 400.0f);
    [self.parent runAction:_starSound];
    [self removeFromParent];
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
