//
//  EndGameScene.m
//  Awesome
//
//  Created by block7 on 4/28/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "EndGameScene.h"
#import "GameScene.h"
#import "AweMyScene.h"

@implementation EndGameScene

- (id) initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
        star.position = CGPointMake(25, self.size.height-30);
        [self addChild:star];
        
        SKLabelNode *lblStars = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblStars.fontSize = 30;
        lblStars.fontColor = [SKColor whiteColor];
        lblStars.position = CGPointMake(50, self.size.height-40);
        lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
        [self addChild:lblStars];
        
        SKLabelNode *lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblScore.fontSize = 50;
        lblScore.fontColor = [SKColor whiteColor];
        lblScore.position = CGPointMake(160, 300);
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
        [self addChild:lblScore];
        
        SKLabelNode *gameOver = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        gameOver.fontSize = 55;
        gameOver.fontColor = [SKColor redColor];
        gameOver.position = CGPointMake(160, 400);
        gameOver.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [gameOver setText:@"Game Over!"];
        [self addChild:gameOver];
        
        SKLabelNode *lblHighScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblHighScore.fontSize = 30;
        lblHighScore.fontColor = [SKColor cyanColor];
        lblHighScore.position = CGPointMake(160, 150);
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblHighScore setText:[NSString stringWithFormat:@"High Score: %d", [GameState sharedInstance].highScore]];
        [self addChild:lblHighScore];
        
        SKLabelNode *lblMenu = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblMenu.fontSize = 30;
        lblMenu.name = @"lblMenu";
        lblMenu.fontColor = [SKColor whiteColor];
        lblMenu.position = CGPointMake(160, 100);
        lblMenu.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblMenu setText:@"Return to Menu!"];
        [self addChild:lblMenu];
        
        SKLabelNode *lblTryAgain = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTryAgain.fontSize = 30;
        lblTryAgain.name = @"lblTryAgain";
        lblTryAgain.fontColor = [SKColor whiteColor];
        lblTryAgain.position = CGPointMake(160, 50);
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTryAgain setText:@"Try Again!"];
        [self addChild:lblTryAgain];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"lblTryAgain"]) {
        GameScene *gameScene = [[GameScene alloc] initWithSize:self.size];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:gameScene transition:reveal];
    }
    
    if ([node.name isEqualToString:@"lblMenu"]) {
        SKScene *menuScene = [[AweMyScene alloc] initWithSize:self.size];
        SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:menuScene transition:reveal];
    }
}

@end
