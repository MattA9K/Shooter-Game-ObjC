# Shooter Game in Objective-C

##### Learn how to create a very basic shoot-em up game for iOS


![GitHub Logo](/images/https://github.com/MattAndrzejczuk/Shooter-Game-ObjC/blob/master/demo.gif?raw=true)


#### Create a basic destructible enemy unit:

```objective-c
        CGSize unitSize = CGSizeMake(60, 60);
        CGPoint randomPointInViewableGameScene = CGPointMake(randomX, randomY);
        SKSpriteNode* enemyNode = [[SKSpriteNode alloc] initWithImageNamed:@"enemy"];
        
        enemyNode.name = @"enemy";
        enemyNode.position = randomPointInViewableGameScene;
        enemyNode.size = unitSize;
        
        [self addChild:enemyNode];
```



#### Create a simple projectile:
```objective-c
    SKSpriteNode* bulletNode = [[SKSpriteNode alloc] initWithImageNamed:@"bullet"];
    bulletNode.position = CGPointMake(0, 0);
    bulletNode.size = CGSizeMake(40, 40);
    bulletNode.name = @"bullet";
    bulletNode.zPosition = 1000;
    [self addChild:bulletNode];
```


All projectiles, or SKSpriteNodes which have the sprite name set to "bullet" will destory enemy units on contact. Enemy unit sprites are named "enemy".

