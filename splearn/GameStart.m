//
//  GameStart.m
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameStart.h"
#import "GamePlay.h"

@implementation GameStart

- (id)init {
    self = [super init];
    if (self) {
        /*
        // 白んだ色で画面を覆います
        CCLayerColor *shade = [CCLayerColor layerWithColor:ccc4(230, 230, 230, 200)];
        [self addChild:shade];
        */
        
        CCSprite *sprite = [CCSprite spriteWithFile:@"start.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        sprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:sprite];
    }
    return self;
}

// 本クラスがアクティブなレイヤーに登録されたタイミングで、
// タッチイベントの受信を開始します
- (void)onEnter {
    [[[CCDirector sharedDirector]touchDispatcher]addTargetedDelegate:self
                                                            priority:0
                                                     swallowsTouches:YES];
}
- (void)onExit {
    [[[CCDirector sharedDirector]touchDispatcher]removeDelegate:self];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // タッチイベントを取り扱う場合はccTouchBeganを必ず実装します
    return YES;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // 画面がタップされたらゲームを開始します
    [self removeFromParentAndCleanup:YES];
    [[GamePlay sharedInstance] startGame];
}

@end
