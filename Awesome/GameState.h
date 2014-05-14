//
//  GameState.h
//  Awesome
//
//  Created by block7 on 4/15/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameState : NSObject

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int highScore;
@property (nonatomic, assign) int stars;
@property (nonatomic, assign) int difficulty;
@property (nonatomic, assign) float force;
+ (instancetype)sharedInstance;
- (void) saveState;

@end