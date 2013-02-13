//
//  Result.m
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "Result.h"
#import "GamePlay.h"

@implementation Result

- (id)init {
    self = [super init];
    if (self) {
        CCSprite *sprite = [CCSprite spriteWithFile:@"hito_retina2_1s.png"];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        sprite.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:sprite];
        
        // 画面中央の下部にリプレイを促すラベルを表示します
        CCLabelTTF *replayLabel = [CCLabelTTF labelWithString:@"CLEAR!!"
                                                     fontName:@"Helvetica"
                                                     fontSize:32];
        replayLabel.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:replayLabel];
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
    [[GamePlay sharedInstance] reset];
    [[GamePlay sharedInstance] startGame];
}

@end
