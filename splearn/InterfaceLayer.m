//
//  InterfaceLayer.m
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "InterfaceLayer.h"
#import "GamePlay.h"


@implementation InterfaceLayer

- (id)init{
    self = [super init];
    if(self){
    }
    return self;
}

- (void)onEnter{
    [[[CCDirector sharedDirector]touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}
- (void)onExit{
    [[[CCDirector sharedDirector]touchDispatcher] removeDelegate:self];
}

#pragma mark タッチイベントの取り扱い
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {              // タッチされたとき
    // タッチされたポイントの座標をcocos2dの座標系（原点：左下）に変換
    CGPoint locationInView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector]convertToGL:locationInView];
    
    [[GamePlay sharedInstance].engController checkCollision:location];
    
    return YES;
}
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {              // タッチが移動しているとき
    // タッチエリアが変わったら移動の命令を切り替える
    // タッチされたポイントの座標系をcocos2d座標系に変換
    CGPoint locationInView = [touch locationInView:[touch view]];
    CGPoint location = [[CCDirector sharedDirector]convertToGL:locationInView];
    
    [[GamePlay sharedInstance].engController checkCollision:location];
    
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {              // タッチが終了したとき
}
- (void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {        // タッチが電話などでキャンセルされたとき
}
@end
