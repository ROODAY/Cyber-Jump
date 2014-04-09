//
//  StarNode.h
//  Awesome
//
//  Created by block7 on 4/9/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, StarType) {
    STAR_NORMAL,
    STAR_SPECIAL,
};

@interface StarNode : SKNode

@property (nonatomic, assign) StarType starType;

@end
