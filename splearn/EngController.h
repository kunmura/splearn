//
//  EngController.h
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface EngController : CCNode {
    NSMutableArray *engs;    // 敵をストックしておく配列
    NSInteger engPos;        // 配列内の、次に登場させる敵の位置
}
@property (nonatomic, retain)NSMutableArray *engs;

// 動作を開始
- (void)startController;
// 動作を停止。画面上に表示してる敵キャラを削除
- (void)stopController;

// 管理している敵キャラに当たり判定を実施
- (BOOL)checkCollision:(CGPoint)position;

// リセット用
- (void)reset;
@end
