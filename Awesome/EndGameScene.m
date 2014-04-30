//
//  EndGameScene.m
//  Awesome
//
//  Created by block7 on 4/28/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "EndGameScene.h"
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
        lblScore.fontSize = 60;
        lblScore.fontColor = [SKColor whiteColor];
        lblScore.position = CGPointMake(160, 300);
        lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
        [self addChild:lblScore];
        
        SKLabelNode *lblHighScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblHighScore.fontSize = 30;
        lblHighScore.fontColor = [SKColor cyanColor];
        lblHighScore.position = CGPointMake(160, 150);
        lblHighScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblHighScore setText:[NSString stringWithFormat:@"High Score: %d", [GameState sharedInstance].highScore]];
        [self addChild:lblHighScore];
        
        SKLabelNode *lblTryAgain = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        lblTryAgain.fontSize = 30;
        lblTryAgain.fontColor = [SKColor whiteColor];
        lblTryAgain.position = CGPointMake(160, 50);
        lblTryAgain.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        [lblTryAgain setText:@"Tap to Retry!"];
        [self addChild:lblTryAgain];
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    SKScene *myScene = [[AweMyScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:myScene transition:reveal];
}

@end
