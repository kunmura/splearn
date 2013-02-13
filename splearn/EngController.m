//
//  EngController.m
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EngController.h"
#import "EngPop.h"
#import "GamePlay.h"

@interface EngController ()
// 敵をステージ上に配置するメソッド
- (void)stageEng;
@end

@implementation EngController

@synthesize engs;

- (id)init{
    self = [super init];
    if(self){
        self.engs = [NSMutableArray arrayWithCapacity:20];
        // 敵キャラクターを先にストックしておき、
        // ゲームプレイ時に余計な処理を行わない様にしておきます
        for (int i=0; i<20; i++){
            EngPop *eng = [EngPop node];
            [self.engs addObject:eng];
        }
        engPos = 0;
    }
    return self;
}

- (void)dealloc{
    self.engs = nil;
    [super dealloc];
}

- (void)startController {
    [self schedule:@selector(stageEng) interval:0.1f];
}

- (void)stopController {
    // イベントスケジューラーから解除し、
    // 画面表示している敵キャラクターを全て取り除く
    [self unschedule:@selector(stageEng)];
    for(EngPop *e in self.engs){
        [e removeFromParentAndCleanup:YES];
    }
    
    // ポジションをリセット
    engPos = 0;
}

-(void)stageEng{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    
    if(engPos<15){
        EngPop *e = [self.engs objectAtIndex:engPos];
        
        CGPoint position = ccp(CCRANDOM_0_1() * winSize.width, CCRANDOM_0_1() * winSize.height);
        
        [e engSet:position layer:[GamePlay sharedInstance].baseLayer];
        engPos = (engPos +1)%20;
    }
}

- (BOOL)checkCollision:(CGPoint)position {
    BOOL isHit = NO;
    //NSLog(@"%f,%f",position.x,position.y);
    for (EngPop *e in self.engs) {
        isHit = [e hitIfCollided:position];
        // 当たっていればチェック終了
        if (isHit) {
            break;
        }
    }
    return isHit;
}
@end
