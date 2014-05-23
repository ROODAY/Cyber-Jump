//
//  PowerUpNode.h
//  Awesome
//
//  Created by block7 on 5/22/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>
#import "GameObjectNode.h"

typedef NS_ENUM(int, StarType) {
    STAR_NORMAL,
    STAR_SPECIAL,
};

typedef NS_ENUM(int, PowerUpType) {
    BOOST,
    JETPACK,
    STAR,
};

@interface PowerUpNode : GameObjectNode

@property (nonatomic, assign) StarType starType;
@property (nonatomic, assign) PowerUpType powerUpType;

@end
