//
//  GameScene.m
//  EmptySpriteKit
//
//  Created by Matt Andrzejczuk on 2/28/17.
//  Copyright © 2017 Matt Andrzejczuk. All rights reserved.
//

#import "GameScene.h"
#include <stdlib.h>

@implementation GameScene {
    SKShapeNode *_spinnyNode;
    
    NSMutableArray *enemiesArray;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    // Get label node from scene and store it for use later
    
    SKSpriteNode* playerNode = [[SKSpriteNode alloc] initWithImageNamed:@"particle"];
    playerNode.position = CGPointMake(0, 0);
    playerNode.size = CGSizeMake(60, 60);
    
    [self addChild:playerNode];
    [self generateRandomEnemies];
}



- (void)generateRandomEnemies {
    enemiesArray = [[NSMutableArray alloc] init];
    static int totalEnemies = 30;
    int i;
    
    for (i = 0; i < totalEnemies; i++) {
        CGFloat maxX = self.size.width;
        CGFloat maxY = self.size.height;
        
        CGFloat minX = (self.size.width / 2) * -1;
        CGFloat minY = (self.size.height / 2) * -1;
        
        int randomX = arc4random_uniform(maxX) + minX;
        int randomY = arc4random_uniform(maxY) + minY;
        
        SKSpriteNode* enemyNode = [[SKSpriteNode alloc] initWithImageNamed:@"enemy"];
        enemyNode.name = @"enemy";
        
        enemyNode.position = CGPointMake(randomX, randomY);
        enemyNode.size = CGSizeMake(60, 60);
        [self addChild:enemyNode];
    }
}


// guiSelect

- (void)fireBullet:(CGPoint)pos {
    SKSpriteNode* bulletNode = [[SKSpriteNode alloc] initWithImageNamed:@"bullet"];
    bulletNode.position = CGPointMake(0, 0);
    bulletNode.size = CGSizeMake(40, 40);
    bulletNode.name = @"bullet";
    bulletNode.zPosition = 1000;
    [self addChild:bulletNode];
    
    CGPoint destination = CGPointMake((pos.x * 3), (pos.y * 3));
    
    SKAction *action = [SKAction moveTo:destination duration:0.9];
    [bulletNode runAction:action];
}

- (void)showTargetGUI: (CGPoint)pos {
    SKSpriteNode* guiTarget = [[SKSpriteNode alloc] initWithImageNamed:@"guiSelect"];
    guiTarget.position = CGPointMake(pos.x, pos.y);
    guiTarget.size = CGSizeMake(40, 40);
    guiTarget.name = @"bullet";
    guiTarget.zPosition = 1000;
    [self addChild:guiTarget];
    
    SKAction *action = [SKAction fadeOutWithDuration:0.2];
    [guiTarget runAction:action];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        [NSThread sleepForTimeInterval:2];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Clean Memory
            [guiTarget removeFromParent];
        });
    });
}

- (void)touchDownAtPoint:(CGPoint)pos {
    [self fireBullet:pos];
    [self showTargetGUI:pos];
}


- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    [self enumerateChildNodesWithName:@"enemy" usingBlock:^(SKNode *node, BOOL *stop) {
        
        
        SKNode* scanN = [self nodeAtPoint:node.position];
        
        if (scanN.name == @"bullet") {
            [node removeFromParent];
            [scanN removeFromParent];
            
            NSString *burstPath =
            [[NSBundle mainBundle]
             pathForResource:@"fire" ofType:@"sks"];
            
            SKEmitterNode *myEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:burstPath];
            
            myEmitter.position = scanN.position;
            myEmitter.particleSize = CGSizeMake(60, 60);
            
            // codes..
            [self addChild: myEmitter]; // add once
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
                [NSThread sleepForTimeInterval:2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI UPDATE 1
                    [myEmitter removeFromParent];
                });
            });
        }
    }];
    
    // Called before each frame is rendered
}

@end
