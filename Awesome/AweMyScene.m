//
//  EndGameScene.m
//  Awesome
//
//  Created by block7 on 4/28/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "AweMyScene.h"
#import "GameScene.h"

@implementation AweMyScene

- (id) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        SKLabelNode *title = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        title.name = @"title";
        title.fontSize = 55;
        title.fontColor = [SKColor whiteColor];
        title.position = CGPointMake(160, 400);
        title.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [title setText:@"Cyber Jump"];
        [self addChild:title];
        
        SKLabelNode *startGameEasy = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        startGameEasy.fontSize = 30;
        startGameEasy.name = @"easy";
        startGameEasy.fontColor = [SKColor whiteColor];
        startGameEasy.position = CGPointMake(160, 150);
        startGameEasy.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [startGameEasy setText:@"Easy"];
        [self addChild:startGameEasy];
        
        SKLabelNode *startGameMedium = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        startGameMedium.fontSize = 30;
        startGameMedium.name = @"medium";
        startGameMedium.fontColor = [SKColor whiteColor];
        startGameMedium.position = CGPointMake(160, 100);
        startGameMedium.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [startGameMedium setText:@"Medium"];
        [self addChild:startGameMedium];
        
        SKLabelNode *startGameHard = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        startGameHard.fontSize = 30;
        startGameHard.name = @"hard";
        startGameHard.fontColor = [SKColor whiteColor];
        startGameHard.position = CGPointMake(160, 50);
        startGameHard.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [startGameHard setText:@"Hard"];
        [self addChild:startGameHard];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"easy"]) {
        _gameDifficulty = 0;
        SKScene *myScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:myScene transition:reveal];
    }
    
    if ([node.name isEqualToString:@"medium"]) {
        _gameDifficulty = 1;
        SKScene *myScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:myScene transition:reveal];
    }
    
    if ([node.name isEqualToString:@"hard"]) {
        _gameDifficulty = 2;
        SKScene *myScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:myScene transition:reveal];
    }
}

@end
