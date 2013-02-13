//
//  EngPop.h
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define ENGPOP_DEFAULT_RADIUS 40

@interface EngPop : CCNode {

    CCSprite *sprite;
    
    // 敵キャラクターのプロパティ
    float radius;       // 大きさ（半径）
    NSInteger life;     // 耐久力
}
@property (nonatomic, retain)CCSprite *sprite;
@property (nonatomic, readonly)float radius;

// 指定したプロパティレイヤー上で動作開始
- (void)engSet: (CGPoint)position
         layer: (CCLayer *)layer;

// 指定された座標に対して衝突しているかどうか判定
- (BOOL)hitIfCollided:(CGPoint)position;
@end
