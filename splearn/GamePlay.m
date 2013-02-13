//
//  GamePlay.m
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GamePlay.h"
#import "EngPop.h"
#import "SimpleAudioEngine.h"

#import "GameStart.h"
#import "Result.h"

@interface GamePlay ()
// 乱数の種を現在時刻で初期化するメソッド
- (void)initRandom;
@end

@implementation GamePlay

@synthesize engText;
@synthesize voiceURL;
@synthesize baseLayer;
@synthesize interfaceLayer;
@synthesize engController;
@synthesize engLabel;

static GamePlay *scene_ = nil;

+ (GamePlay *)sharedInstance {
    if (scene_ == nil) {
        scene_ = [GamePlay node];
    }
	return scene_;
}

- (void)initRandom {
	struct timeval t;
	gettimeofday(&t, nil);
	unsigned int i;
	i = t.tv_sec;
	i += t.tv_usec;
	srandom(i);
}

//----------------------------------------------- API

// APIたたく
- (void)api
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.iknow.jp/goals/470263/items/34891"]];
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// ヘッダー受信
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _data = [[NSMutableData alloc] initWithData:0]; // データの初期化
}

// データ追加
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data]; // データの追加
}

// エラー時
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

// 受信完了
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSError *error=nil;
    
    // JSONパース
    NSDictionary *_jsonArray = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *_cue = [_jsonArray objectForKey:@"cue"];
    NSDictionary *_content = [_cue objectForKey:@"content"];
    engText = [_content objectForKey:@"text"];
    voiceURL = [_content objectForKey:@"sound"];
    //NSLog(@"_cue %@",_cue);
    //NSLog(@"_text %@",engText);
    
    //------------------------------------------- baseLayer addChild engText
    NSString *str = [NSString stringWithFormat:@"%@",engText];
    engLabel = [CCLabelTTF labelWithString:str fontName:@"Helvetica" fontSize:22];
}

//----------------------------------------------- init
-(id) init
{
    self = [super init];
    if(self){
        
        // プレイヤーのライフ
        playerLife = 15;
        
        //--------------------------------------- call iKnow api
        [self api];
        
        //--------------------------------------- game layer
        self.baseLayer = [CCLayer node];
        [self addChild:baseLayer z:0];
        
        // ユーザーインタフェースを担当するクラスを起動・baseLayer上に配置
        self.interfaceLayer = [InterfaceLayer node];
        [self.baseLayer addChild:self.interfaceLayer z:100];
        
        // 敵キャラクターを配置する管理クラスを起動
        self.engController = [EngController node];
        [self.baseLayer addChild:self.engController z:-1];
        
        // BGMの音量調整
        [SimpleAudioEngine sharedEngine].backgroundMusicVolume = 0.5f;
        
        // 背景画像を設置
        CCSprite *sprite = [CCSprite spriteWithFile:@"hito_retina1_1s.png"];
        sprite.position = ccp(160,284);
        [self.baseLayer addChild:sprite z:-1];
        
        CCSprite *textbord = [CCSprite spriteWithFile:@"textbord.png"];
        textbord.position = ccp(160,80);
        CCLabelTTF *text = [CCLabelTTF labelWithString:@"持っている" fontName:@"Arial Unicode MS" fontSize:40];
        text.position = ccp(200,50);

        [textbord addChild:text];
        [self.baseLayer addChild:textbord z:0];
        
        // ゲームを開始
        [self addChild:[GameStart node] z:100];
        
    }
    return self;
}

- (void)startGame {
    // もやもやの出現
    [self.engController startController];
    
    // バックグラウンドミュージックの再生開始
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"background.mp3" loop:YES];
}

- (void)result {
    // Result用のレイヤーを画面の最前面に追加します。
    [self addChild:[Result node] z:100];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)damege {
    playerLife--;
    //NSLog(@"%d",playerLife);
    if(playerLife<=0){
        [[GamePlay sharedInstance] result];
    }
}

- (void)reset {
    playerLife=15;
    [self.engController stopController];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
