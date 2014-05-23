//
//  AweMyScene.m
//  Awesome
//
//  Created by block7 on 4/7/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "GameScene.h"
#import "GameObjectNode.h"
#import "PlatformNode.h"
#import "EndGameScene.h"
#import "AweMyScene.h"
#import "BoostNode.h"
#import "PowerUpNode.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer     = 0x1 << 0,
    CollisionCategoryStar       = 0x1 << 1,
    CollisionCategoryPowerUp    = 0x1 << 1,
    CollisionCategoryPlatform   = 0x1 << 2,
};

@interface GameScene () <SKPhysicsContactDelegate>
{
    SKNode *_backgroundNode;
    SKNode *_midgroundNode;
    SKNode *_foregroundNode;
    SKNode *_hudNode;
    SKNode *_player;
    
    SKSpriteNode *_tapToStartNode;
    SKSpriteNode *_boostButton;
    SKSpriteNode *_dpad;
    SKSpriteNode *_dpadback;
    
    SKLabelNode *_lblScore;
    SKLabelNode *_lblStars;
    SKLabelNode *_lblBoosts;
    
    int _maxPlayerY;
    int _dpadX;
    int _dpadY;
    int _platformYOffset;
    int _starYOffset;
    int _powerUpYOffset;
    
    float _lastPlatformHeight;
    float _lastPowerUpHeight;
    float _lastPowerUpX;
    float _lastStarHeight;
    float _lastPlatformX;
    float _lastStarX;
    float _boostInterval;
    float _touchX;
    float _platformSpacerMultiplier;
    float _starSpacerMultiplier;
    
    BOOL _gameOver;
    BOOL _dpadDown;
    BOOL _movingDpad;
    BOOL _makePlatform;
    BOOL _makeStar;
    BOOL _makePowerUp;
    BOOL _skipStar;
    BOOL _skipPowerUp;
    BOOL _skipPlatform;
}
@end

@implementation GameScene

bool moveRight = FALSE;
bool moveLeft = FALSE;

- (id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _maxPlayerY = 80;
        _boostInterval = 2500;
        [GameState sharedInstance].boostsLeft = 3;
        [GameState sharedInstance].score = 0;
        [GameState sharedInstance].stars = 0;
        _gameOver = NO;
        self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
        self.physicsWorld.contactDelegate = self;
        
        _backgroundNode = [self createBackgroundNode];
        [self addChild:_backgroundNode];
        
        _midgroundNode = [self createMidgroundNode];
        [self addChild:_midgroundNode];
        
        _foregroundNode = [SKNode node];
        [self addChild:_foregroundNode];
        
        _hudNode = [SKNode node];
        [self addChild:_hudNode];
        
        _makePlatform = TRUE;
        _skipPlatform = FALSE;
        _platformYOffset = 0;
        for (int platformCounter = 0; platformCounter <= 100; platformCounter++) {
            CGFloat platformX = arc4random_uniform(320);
            CGFloat platformY = arc4random_uniform(80) + _platformYOffset;
            PlatformType platformType = arc4random_uniform(2);
            
            if ([GameState sharedInstance].difficulty == 0) {
                _platformYOffset += 80;
            } else if ([GameState sharedInstance].difficulty == 1) {
                _platformYOffset += 60;
            } else if ([GameState sharedInstance].difficulty == 2) {
                _platformYOffset += 40;
            }
            
            if (platformY < 85.0f) {
                _makePlatform = FALSE;
            }
            
            if (_makePlatform) {
                if ([GameState sharedInstance].difficulty == 0) {
                    if (fabsf(_lastPlatformX - platformX) < 100.0) {
                        platformX += 100;
                    }
                    if (fabsf(_lastPlatformHeight - platformY) < 60.0) {
                        platformY += 60;
                    }
                } else if ([GameState sharedInstance].difficulty == 1) {
                    if (fabsf(_lastPlatformX - platformX) < 80.0) {
                        platformX += 80;
                    }
                    if (fabsf(_lastPlatformHeight - platformY) < 50.0) {
                        platformY += 50;
                    }
                } else if ([GameState sharedInstance].difficulty == 2) {
                    if (fabsf(_lastPlatformX - platformX) < 60.0) {
                        platformX += 60;
                    }
                    if (fabsf(_lastPlatformHeight - platformY) < 40.0) {
                        platformY += 40;
                    }
                }
                
                PlatformNode *platformNode = [self createPlatformAtPosition:CGPointMake(platformX, platformY) ofType:platformType];
                [_foregroundNode addChild:platformNode];
                _lastPlatformHeight = platformY;
                _lastPlatformX = platformX;
                
                if ([GameState sharedInstance].difficulty == 0) {
                    _makePlatform = TRUE;
                } else if ([GameState sharedInstance].difficulty == 1) {
                    _makePlatform = FALSE;
                } else if ([GameState sharedInstance].difficulty == 2) {
                    _makePlatform = FALSE;
                    _skipPlatform = TRUE;
                }
            } else if (!_makePlatform && _skipPlatform) {
                _makePlatform = FALSE;
                _skipPlatform = FALSE;
            } else if (!_makePlatform) {
                _makePlatform = TRUE;
            }
        }
        /*
        _makeStar = TRUE;
        _skipStar = FALSE;
        _starYOffset = 0;
        for (int starCounter = 0; starCounter <= 100; starCounter++) {
            CGFloat starX = arc4random_uniform(320);
            CGFloat starY = arc4random_uniform(140) + _starYOffset;
            StarType starType = arc4random_uniform(2);
            
            if ([GameState sharedInstance].difficulty == 0) {
                _starYOffset += 500;
            } else if ([GameState sharedInstance].difficulty == 1) {
                _starYOffset += 1000;
            } else if ([GameState sharedInstance].difficulty == 2) {
                _starYOffset += 1500;
            }
            
            if (starY < 85.0f) {
                _makeStar = FALSE;
            }

            if (_makeStar) {
                StarNode *starNode = [self createStarAtPosition:CGPointMake(starX, starY) ofType:starType];
                [_foregroundNode addChild:starNode];
                _lastStarHeight = starY;
                _lastStarX = starX;
                
                if ([GameState sharedInstance].difficulty == 0) {
                    _makeStar = TRUE;
                } else if ([GameState sharedInstance].difficulty == 1) {
                    _makeStar = FALSE;
                } else if ([GameState sharedInstance].difficulty == 2) {
                    _makeStar = FALSE;
                    _skipStar = TRUE;
                }
            } else if (!_makeStar && _skipStar) {
                _makeStar = FALSE;
                _skipStar = FALSE;
            } else if (!_makeStar) {
                _makeStar = TRUE;
            }
            
        }*/
        
        _makePowerUp = TRUE;
        _skipPowerUp = FALSE;
        _powerUpYOffset = 0;
        for (int counter = 0; counter <= 100; counter++) {
            CGFloat x = arc4random_uniform(320);
            CGFloat y = arc4random_uniform(140) + _powerUpYOffset;
            PowerUpType type = arc4random_uniform(3);
            
            if ([GameState sharedInstance].difficulty == 0) {
                _powerUpYOffset += 500;
            } else if ([GameState sharedInstance].difficulty == 1) {
                _powerUpYOffset += 1000;
            } else if ([GameState sharedInstance].difficulty == 2) {
                _powerUpYOffset += 1500;
            }
            
            if (y < 85.0f) {
                _makeStar = FALSE;
            }
            
            if (_makePowerUp) {
                PowerUpNode *node = [self createPowerUpAtPosition:CGPointMake(x, y) ofType:type];
                [_foregroundNode addChild:node];
                _lastStarHeight = y;
                _lastStarX = x;
                
                if ([GameState sharedInstance].difficulty == 0) {
                    _makePowerUp = TRUE;
                } else if ([GameState sharedInstance].difficulty == 1) {
                    _makePowerUp = FALSE;
                } else if ([GameState sharedInstance].difficulty == 2) {
                    _makePowerUp = FALSE;
                    _skipPowerUp = TRUE;
                }
            } else if (!_makePowerUp && _skipPowerUp) {
                _makePowerUp = FALSE;
                _skipPowerUp = FALSE;
            } else if (!_makePowerUp) {
                _makePowerUp = TRUE;
            }
            
        }
        
        _player = [self createPlayer];
        [_foregroundNode addChild:_player];
        
        _tapToStartNode = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
        _tapToStartNode.position = CGPointMake(160, 180.0f);
        [_hudNode addChild:_tapToStartNode];
        
        SKSpriteNode *star = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
        star.position = CGPointMake(25, self.size.height - 30);
        [_hudNode addChild:star];
        
        _lblStars = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblStars.fontSize = 30;
        _lblStars.fontColor = [SKColor whiteColor];
        _lblStars.position = CGPointMake(50, self.size.height - 40);
        _lblStars.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        [_lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
        [_hudNode addChild:_lblStars];
        
        _lblBoosts = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblBoosts.fontSize = 15;
        _lblBoosts.fontColor = [SKColor whiteColor];
        _lblBoosts.position = CGPointMake(320, 50);
        _lblBoosts.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        [_lblBoosts setText:[NSString stringWithFormat:@"Boosts: %d", [GameState sharedInstance].boostsLeft]];
        [_hudNode addChild:_lblBoosts];
        
        _lblScore = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
        _lblScore.fontSize = 30;
        _lblScore.fontColor = [SKColor whiteColor];
        _lblScore.position = CGPointMake(self.size.width - 20, self.size.height - 40);
        _lblScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
        [_lblScore setText:@"0"];
        [_hudNode addChild:_lblScore];
        
        _boostButton = [SKSpriteNode spriteNodeWithImageNamed:@"Boost"];
        _boostButton.name = @"boostButton";
        _boostButton.position = CGPointMake(300, 27);
        _boostButton.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_boostButton.size.width/2];
        _boostButton.physicsBody.dynamic = NO;
        [_hudNode addChild:_boostButton];
        
        _dpadback = [SKSpriteNode spriteNodeWithImageNamed:@"Dpadback"];
        _dpadback.name = @"dpadback";
        _dpadback.position = CGPointMake(160, 28);
        [_hudNode addChild:_dpadback];
        
        _dpad = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        _dpad.name = @"dpad";
        _dpad.position = CGPointMake(160, 27);
        _dpad.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_dpad.size.width/2];
        _dpad.physicsBody.dynamic = NO;
        [_hudNode addChild:_dpad];
        
        _dpadX = _dpad.position.x;
        _dpadY = _dpad.position.y;
    }
    return self;
}

- (SKNode *) createBackgroundNode
{
    SKNode *backgroundNode = [SKNode node];
    
    for (int nodeCount = 0; nodeCount < 20; nodeCount++) {
        NSString *backgroundImageName = [NSString stringWithFormat:@"Background%02d", nodeCount+1];
        SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:backgroundImageName];
        node.anchorPoint = CGPointMake(0.5f, 0.0f);
        node.position = CGPointMake(160.0f, nodeCount*64.0f);
        [backgroundNode addChild:node];
    }
    return backgroundNode;
    
}

- (SKNode *)createMidgroundNode
{
    SKNode *midgroundNode = [SKNode node];
    for (int i=0; i<10; i++) {
        NSString *spriteName;
        int r = arc4random() % 2;
        if (r > 0) {
            spriteName = @"BranchRight";
        } else {
            spriteName = @"BranchLeft";
        }
        
        SKSpriteNode *branchNode = [SKSpriteNode spriteNodeWithImageNamed:spriteName];
        branchNode.position = CGPointMake(160.0f, 500.0f * i);
        [midgroundNode addChild:branchNode];
    }
    return midgroundNode;
}

- (SKNode *) createPlayer
{
    SKNode *playerNode = [SKNode node];
    [playerNode setPosition:CGPointMake(160.0f, 85.0f)];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
    [playerNode addChild:sprite];
    playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    playerNode.physicsBody.dynamic = NO;
    playerNode.physicsBody.allowsRotation = NO;
    playerNode.physicsBody.restitution = 1.0f;
    playerNode.physicsBody.friction = 0.1f;
    playerNode.physicsBody.angularDamping = 0.2f;
    playerNode.physicsBody.linearDamping = 0.2f;
    
    playerNode.physicsBody.usesPreciseCollisionDetection = YES;
    playerNode.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    playerNode.physicsBody.collisionBitMask = 0;
    playerNode.physicsBody.contactTestBitMask = CollisionCategoryStar | CollisionCategoryPlatform;
    for (int i = 0; i < 320; i += 45) {
        PlatformNode *platformNode = [self createPlatformAtPosition:CGPointMake(i, 55.0f) ofType:0];
        [_foregroundNode addChild:platformNode];
    }
    return playerNode;
}

- (PowerUpNode *) createPowerUpAtPosition:(CGPoint)position ofType:(PowerUpType)type
{
    PowerUpNode *node = [PowerUpNode node];
    [node setPosition:position];
    if (type == 0) {
        [node setName:@"NODE_BOOST"];
        SKSpriteNode *sprite;
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Boost"];
        [node addChild:sprite];
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    } else if (type == 1) {
        [node setName:@"NODE_JETPACK"];
        SKSpriteNode *sprite;
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Boost"];
        [node addChild:sprite];
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    } else if (type == 2) {
        [node setName:@"NODE_STAR"];
        int starType = arc4random_uniform(2);
        [node setStarType:starType];
        SKSpriteNode *sprite;
        if (type == STAR_SPECIAL) {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"StarSpecial"];
        } else {
            sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
        }
        [node addChild:sprite];
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    }
    
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = CollisionCategoryPowerUp;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}
/*
- (StarNode *) createStarAtPosition:(CGPoint)position ofType:(StarType)type
{
    StarNode *node = [StarNode node];
    [node setPosition:position];
    [node setName:@"NODE_STAR"];
    [node setStarType:type];
    
    SKSpriteNode *sprite;
    if (type == STAR_SPECIAL) {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"StarSpecial"];
    } else {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Star"];
    }
    [node addChild:sprite];
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    node.physicsBody.dynamic = NO;
    
    node.physicsBody.categoryBitMask = CollisionCategoryStar;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}*/

- (BoostNode *) createBoostAtPosition:(CGPoint)position
{
    BoostNode *node = [BoostNode node];
    [node setPosition:position];
    
    SKSpriteNode *sprite;
    sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Boost"];
    [node addChild:sprite];
    
    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    node.physicsBody.dynamic = NO;
    
    node.physicsBody.categoryBitMask = CollisionCategoryStar;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (PlatformNode *) createPlatformAtPosition:(CGPoint)position ofType:(PlatformType)type
{
    PlatformNode *node = [PlatformNode node];
    [node setPosition:position];
    [node setName:@"NODE_PLATFORM"];
    [node setPlatformType:type];
    
    SKSpriteNode *sprite;
    if (type == PLATFORM_BREAK) {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"PlatformBreak"];
    } else {
        sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Platform"];
    }
    [node addChild:sprite];
    
    node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:sprite.size];
    node.physicsBody.dynamic = NO;
    node.physicsBody.categoryBitMask = CollisionCategoryPlatform;
    node.physicsBody.collisionBitMask = 0;
    
    return node;
}

- (void) createMorePlatforms {
    if ([GameState sharedInstance].difficulty == 0) {
        _platformSpacerMultiplier = 1.5;
        _starSpacerMultiplier = 1.5;
    } else if ([GameState sharedInstance].difficulty == 1) {
        _platformSpacerMultiplier = 1.0;
        _starSpacerMultiplier = 1.0;
    } else if ([GameState sharedInstance].difficulty == 2) {
        _platformSpacerMultiplier = 0.5;
        _starSpacerMultiplier = 0.5;
    }
    
    for (int platformCounter = 0; platformCounter <= 100; platformCounter++) {
        CGFloat platformX = arc4random_uniform(320);
        CGFloat platformY = (_platformSpacerMultiplier * arc4random_uniform(80)) + _platformYOffset;
        PlatformType platformType = arc4random_uniform(2);
        
        if ([GameState sharedInstance].difficulty == 0) {
            _platformYOffset += 80;
        } else if ([GameState sharedInstance].difficulty == 1) {
            _platformYOffset += 60;
        } else if ([GameState sharedInstance].difficulty == 2) {
            _platformYOffset += 40;
        }
        
        if (platformY < 85.0f) {
            _makePlatform = FALSE;
        }
        
        //NSLOG(@"%d", _makePlatform);
        if (_makePlatform) {
            if ([GameState sharedInstance].difficulty == 0) {
                if (fabsf(_lastPlatformX - platformX) < 100.0) {
                    platformX += 100;
                }
                if (fabsf(_lastPlatformHeight - platformY) < 60.0) {
                    platformY += 60;
                }
            } else if ([GameState sharedInstance].difficulty == 1) {
                if (fabsf(_lastPlatformX - platformX) < 80.0) {
                    platformX += 80;
                }
                if (fabsf(_lastPlatformHeight - platformY) < 50.0) {
                    platformY += 50;
                }
            } else if ([GameState sharedInstance].difficulty == 2) {
                if (fabsf(_lastPlatformX - platformX) < 60.0) {
                    platformX += 60;
                }
                if (fabsf(_lastPlatformHeight - platformY) < 40.0) {
                    platformY += 40;
                }
            }
            
            PlatformNode *platformNode = [self createPlatformAtPosition:CGPointMake(platformX, platformY) ofType:platformType];
            [_foregroundNode addChild:platformNode];
            //NSLOG(@"Platform made at: (%f, %f)", platformX, platformY);
            _lastPlatformHeight = platformY;
            
            if ([GameState sharedInstance].difficulty == 0) {
                _makePlatform = TRUE;
            } else if ([GameState sharedInstance].difficulty == 1) {
                _makePlatform = FALSE;
            } else if ([GameState sharedInstance].difficulty == 2) {
                _makePlatform = FALSE;
                _skipPlatform = TRUE;
            }
        } else if (!_makePlatform) {
            _makePlatform = TRUE;
        } else if (!_makePlatform && _skipPlatform) {
            _makePlatform = FALSE;
        }
    }
}
/*
- (void)  createMoreStars {
    if ([GameState sharedInstance].difficulty == 0) {
        _platformSpacerMultiplier = 1.5;
        _starSpacerMultiplier = 1.5;
    } else if ([GameState sharedInstance].difficulty == 1) {
        _platformSpacerMultiplier = 1.0;
        _starSpacerMultiplier = 1.0;
    } else if ([GameState sharedInstance].difficulty == 2) {
        _platformSpacerMultiplier = 0.5;
        _starSpacerMultiplier = 0.5;
    }
    
    for (int starCounter = 0; starCounter <= 100; starCounter++) {
        CGFloat starX = arc4random_uniform(320);
        CGFloat starY = (_starSpacerMultiplier * arc4random_uniform(140)) + _starYOffset;
        StarType starType = arc4random_uniform(2);
        
        if ([GameState sharedInstance].difficulty == 0) {
            _starYOffset += 500;
        } else if ([GameState sharedInstance].difficulty == 1) {
            _starYOffset += 1000;
        } else if ([GameState sharedInstance].difficulty == 2) {
            _starYOffset += 1500;
        }
        
        if (starY < 85.0f) {
            _makeStar = FALSE;
        }
        
        if (_makeStar) {
            if ([GameState sharedInstance].difficulty == 0) {
                if (fabsf(_lastStarX - starX) < 100.0) {
                    starX += 100;
                }
                if (fabsf(_lastStarHeight - starY) < 3060.0) {
                    starY += 3060;
                }
            } else if ([GameState sharedInstance].difficulty == 1) {
                if (fabsf(_lastStarX - starX) < 80.0) {
                    starX += 80;
                }
                if (fabsf(_lastStarHeight - starY) < 2750.0) {
                    starY += 2750;
                }
            } else if ([GameState sharedInstance].difficulty == 2) {
                if (fabsf(_lastStarX - starX) < 60.0) {
                    starX += 60;
                }
                if (fabsf(_lastStarHeight - starY) < 2540.0) {
                    starY += 2540;
                }
            }
            
            StarNode *starNode = [self createStarAtPosition:CGPointMake(starX, starY) ofType:starType];
            [_foregroundNode addChild:starNode];
            _lastStarHeight = starY;
            
            if ([GameState sharedInstance].difficulty == 0) {
                _makeStar = TRUE;
            } else if ([GameState sharedInstance].difficulty == 1) {
                _makeStar = FALSE;
            } else if ([GameState sharedInstance].difficulty == 2) {
                _makeStar = FALSE;
                _skipStar = TRUE;
            }
        } else if (!_makeStar) {
            _makeStar = TRUE;
        } else if (!_makeStar && _skipStar) {
            _makeStar = FALSE;
        }
        
    }
}*/

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    BOOL updateHUD = NO;
    SKNode *other = (contact.bodyA.node != _player) ? contact.bodyA.node : contact.bodyB.node;
    updateHUD = [(GameObjectNode *)other collisionWithPlayer:_player];
    
    if (updateHUD) {
        [_lblStars setText:[NSString stringWithFormat:@"X %d", [GameState sharedInstance].stars]];
        [_lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
    }
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKSpriteNode *node = (SKSpriteNode *)[self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"boostButton"] && ([GameState sharedInstance].boostsLeft > 0)) {
        _player.physicsBody.velocity = CGVectorMake(_player.physicsBody.velocity.dx, 750.0f);
        [GameState sharedInstance].boostsLeft--;
    }
    
    if ([node.name isEqualToString:@"dpad"]) {
        _touchX = location.x;
        _dpadDown = YES;
        _movingDpad = YES;
    }
    
    if (_player.physicsBody.dynamic) return;
    [_tapToStartNode removeFromParent];
    _player.physicsBody.dynamic = YES;
    [_player.physicsBody applyImpulse:CGVectorMake(0.0f, 50.0f)];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    if (_movingDpad) {
        _touchX = location.x;
        _dpadDown = YES;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _dpadDown = NO;
    _movingDpad = NO;
}

- (void) update:(NSTimeInterval)currentTime {
    if (_gameOver) return;
    //NSLog(@"Player: %f Boost Interval: %f", _player.position.y, _boostInterval);
    if (_player.position.y > _lastPlatformHeight - 200) {
        [self createMorePlatforms];
        //NSLOG(@"The last platform height is: %f", _lastPlatformHeight);
    }
    
    if (_player.position.y > _lastStarHeight - 200) {
        //[self createMoreStars];
        //NSLOG(@"The last star height is: %f", _lastStarHeight);
    }
    
    if (_player.physicsBody.velocity.dy >= 1000) {
        while (_player.physicsBody.velocity.dy >= 1000) {
            _player.physicsBody.velocity = CGVectorMake(_player.physicsBody.velocity.dx, _player.physicsBody.velocity.dy - 50);
        }
    }
    
    if (_player.position.y > _boostInterval - 800) {
        BoostNode *boost = [self createBoostAtPosition:CGPointMake(_player.position.x, _boostInterval)];
        [_foregroundNode addChild:boost];
        _boostInterval += 2500;
        NSLog(@"Boost created at (%f, %f)", _player.position.x, _boostInterval);
        
    }
    
    if ([GameState sharedInstance].boostsLeft <= 0) {
        _boostButton.alpha = 0.2;
    }
    
    if ([GameState sharedInstance].boostsLeft > 0) {
        _boostButton.alpha = 1.0;
    }
    
    if ((int)_player.position.y > _maxPlayerY) {
        [GameState sharedInstance].score += (int)_player.position.y - _maxPlayerY;
        _maxPlayerY = (int)_player.position.y;
        [_lblScore setText:[NSString stringWithFormat:@"%d", [GameState sharedInstance].score]];
    }
    
    [_foregroundNode enumerateChildNodesWithName:@"NODE_PLATFORM" usingBlock:^(SKNode *node, BOOL *stop) {
        [((PlatformNode *)node) checkNodeRemoval:_player.position.y];
    }];
    [_foregroundNode enumerateChildNodesWithName:@"NODE_STAR" usingBlock:^(SKNode *node, BOOL *stop) {
        [((PowerUpNode *)node) checkNodeRemoval:_player.position.y];
    }];
    
    if (_player.position.y > 200.0f) {
        _backgroundNode.position = CGPointMake(0.0f, -((_player.position.y - 200.0f)/10));
        _midgroundNode.position = CGPointMake(0.0f, -((_player.position.y - 200.0f)/4));
        _foregroundNode.position = CGPointMake(0.0f, -(_player.position.y - 200.0f));
    }
    
    if (_player.position.y < (_maxPlayerY - 400)) {
        [self endGame];
    }
    
    if (_dpadDown) {
        float angle = atan2f(0, _touchX - _dpadX);
        SKAction *moveDpad = [SKAction moveTo:CGPointMake(_touchX, _dpadY) duration:0.00001];
        double distance = sqrt(pow((_touchX - _dpadX), 2.0) + pow((0), 2.0));
        
        if (distance < 80) {
            [_dpad runAction:moveDpad];
        }
        
        if (distance > 80) {
            distance = 80;
        }
        
        SKAction *movePlayer = [SKAction moveByX:0.25*(distance)*cosf(angle) y:0 duration:0.005];
        [_player runAction:movePlayer];
    }
    
    if (!_dpadDown) {
        SKAction *moveDpad = [SKAction moveTo:CGPointMake(_dpadX, _dpadY) duration:0.00001];
        [_dpad runAction:moveDpad];
    }
    
    [_lblBoosts setText:[NSString stringWithFormat:@"Boosts: %d", [GameState sharedInstance].boostsLeft]];
}

- (void) didSimulatePhysics
{
    if (_player.position.x < -20.0f) {
        _player.position = CGPointMake(340.0f, _player.position.y);
    } else if (_player.position.x > 340.0f) {
        _player.position = CGPointMake(-20.0f, _player.position.y);
    }
    return;
}

- (void) endGame {
    _gameOver = YES;
    
    [[GameState sharedInstance] saveState];
    
    EndGameScene *endGameScene = [[EndGameScene alloc] initWithSize:self.size];
    SKTransition *reveal = [SKTransition fadeWithDuration:0.5];
    [self.view presentScene:endGameScene transition:reveal];
}

@end
