//
//  EndGameScene.h
//  Awesome
//
//  Created by block7 on 4/28/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface EndGameScene : SKScene

- (id) initWithSize:(CGSize)size andDifficulty:(int)difficulty;
@property (nonatomic) int gameDifficulty;
@end
