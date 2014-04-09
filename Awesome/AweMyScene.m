//
//  AweMyScene.m
//  Awesome
//
//  Created by block7 on 4/7/14.
//  Copyright (c) 2014 Too Much Daylight. All rights reserved.
//

#import "AweMyScene.h"
#import "StarNode.h"
#import "GameObjectNode.h"
#import "PlatformNode.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory) {
    CollisionCategoryPlayer     = 0x1 << 0,
    CollisionCategoryStar       = 0x1 << 1,
    CollisionCategoryPlatform   = 0x1 << 2,
};

@interface AweMyScene () <SKPhysicsContactDelegate>
{
    SKNode *_backgroundNode;
    SKNode *_midgroundNode;
    SKNode *_foregroundNode;
    SKNode *_hudNode;
    SKNode *_player;
    SKSpriteNode *_tapToStartNode;
}
@end

@implementation AweMyScene

- (id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        self.physicsWorld.gravity = CGVectorMake(0.0f, -2.0f);
        self.physicsWorld.contactDelegate = self;
        
        _backgroundNode = [self createBackgroundNode];
        [self addChild:_backgroundNode];
        
        _foregroundNode = [SKNode node];
        [self addChild:_foregroundNode];
        
        _hudNode = [SKNode node];
        [self addChild:_hudNode];
        
        PlatformNode *platform = [self createPlatformAtPosition:CGPointMake(160, 320) ofType:PLATFORM_NORMAL];
        [_foregroundNode addChild:platform];
        
        StarNode *star = [self createStarAtPosition:CGPointMake(160, 220) ofType:STAR_SPECIAL];
        [_foregroundNode addChild:star];
        
        _player = [self createPlayer];
        [_foregroundNode addChild:_player];
        
        _tapToStartNode = [SKSpriteNode spriteNodeWithImageNamed:@"TapToStart"];
        _tapToStartNode.position = CGPointMake(160, 180.0f);
        [_hudNode addChild:_tapToStartNode];
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

- (SKNode *) createPlayer
{
    SKNode *playerNode = [SKNode node];
    [playerNode setPosition:CGPointMake(160.0f, 80.0f)];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Player"];
    [playerNode addChild:sprite];
    playerNode.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:sprite.size.width/2];
    playerNode.physicsBody.dynamic = NO;
    playerNode.physicsBody.allowsRotation = NO;
    playerNode.physicsBody.restitution = 1.0f;
    playerNode.physicsBody.friction = 0.0f;
    playerNode.physicsBody.angularDamping = 0.0f;
    playerNode.physicsBody.linearDamping = 0.0f;
    
    playerNode.physicsBody.usesPreciseCollisionDetection = YES;
    playerNode.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    playerNode.physicsBody.collisionBitMask = 0;
    playerNode.physicsBody.contactTestBitMask = CollisionCategoryStar | CollisionCategoryPlatform;
    
    return playerNode;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_player.physicsBody.dynamic) return;
    [_tapToStartNode removeFromParent];
    _player.physicsBody.dynamic = YES;
    [_player.physicsBody applyImpulse:CGVectorMake(0.0f, 20.0f)];
}
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

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    BOOL updateHUD = NO;
    SKNode *other = (contact.bodyA.node != _player) ? contact.bodyA.node : contact.bodyB.node;
    updateHUD = [(GameObjectNode *)other collisionWithPlayer:_player];
    
    if (updateHUD) {
        
    }
}

@end
