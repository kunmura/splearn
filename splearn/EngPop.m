//
//  EngPop.m
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "EngPop.h"
#import "GamePlay.h"
#import "SimpleAudioEngine.h"

@implementation EngPop

@synthesize sprite;
@synthesize radius;

- (id)init{
    self = [super init];
    if(self){
        
        self.sprite = [CCSprite node];
        [self addChild:self.sprite];
        
        CCSpriteBatchNode *fg = [CCSpriteBatchNode batchNodeWithFile:@"moya2.png"];
        CCSpriteFrame *frame1 = [CCSpriteFrame frameWithTexture:fg.texture rect:CGRectMake(0, 0, 110, 110)];
        CCSpriteFrame *frame2 = [CCSpriteFrame frameWithTexture:fg.texture rect:CGRectMake(110, 0, 110, 110)];
        NSArray* animFrames = [NSArray arrayWithObjects:frame1,frame2,nil];
        CCAnimation *animation = [CCAnimation animationWithSpriteFrames:animFrames delay:0.3f];
        id repeat_moya2 = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
        
        [self.sprite runAction:repeat_moya2];
        
        radius = ENGPOP_DEFAULT_RADIUS;        
    }
    return self;
}

- (void)dealloc{
    self.sprite = nil;
    [super dealloc];
}

- (void)engSet:(CGPoint)position layer:(CCLayer *)layer {

    self.position = position;

    life = 1.0f;
    
    // ラベルの追加
    CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"have" fontName:@"Helvetica" fontSize:22];
    label2.position = ccp(0,10);
    label2.color = ccc3(CCRANDOM_0_1()*255, CCRANDOM_0_1()*255, CCRANDOM_0_1()*255);
    [self addChild:label2];
    
    // アップデート
    [self scheduleUpdate];
    
    [layer addChild:self];
}

- (void)update:(ccTime)dt{
}

- (void)removeFromParentAndCleanup:(BOOL)cleanup {
    // 画面から除外するときに、プロパティもリセット
    self.position = CGPointZero;
    self.scale = 1.0f;
    
    NSLog(@"cleanup");
    
    // リセット後、オーバーライドした元の処理を呼び出す
    [super removeFromParentAndCleanup:cleanup];
}

- (BOOL)hitIfCollided:(CGPoint)position {
    // 座標との距離が自分のサイズよりも小さい場合は当たったとみなします
    BOOL isHit = ccpDistance(self.position, position) < radius;
    //NSLog(@"eng 1: %f,%f",self.position.x,self.position.y);
    //NSLog(@"eng 2: %f,%f",position.x,position.y);
    if (isHit) {
        //NSLog(@"eng.m: hit");
        [self gotHit:position];
    }
    return isHit;
}

- (void)gotHit:(CGPoint)position {
    life--;
    if (life<=0) {
        // 爆破エフェクトをGameSceneのbaseLayerで表示します。
        // CCParticleSunをベースにパラメータを調整して爆発を表現します。
        // (自分自身は上の処理で画面上から取り除かれているためselfではなく
        //  baseLayerに直接配置しています)
        CCParticleSystem *bomb = [CCParticleSun node];
        bomb.duration = 0.3f;
        bomb.life = 0.5f;
        bomb.speed = 200;
        bomb.scale = self.scale * 2.0f;
        bomb.position = self.position;
        bomb.autoRemoveOnFinish = YES;
        [[GamePlay sharedInstance].baseLayer addChild:bomb z:100];
        
        // 音の再生
        [[SimpleAudioEngine sharedEngine] playEffect:@"have.mp3"];
        
        // オブジェクトの削除
        [self removeFromParentAndCleanup:YES];
        
        // ダメージ
        [[GamePlay sharedInstance] damege];
    }
}

@end
