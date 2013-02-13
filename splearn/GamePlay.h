//
//  GamePlay.h
//  splearn
//
//  Created by Murayama Kunshiro on 13/01/22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "EngController.h"

@interface GamePlay : CCScene {
    
    //----------------------------------------------- API
    NSURLConnection *_connection;
    NSMutableData *_data;
    
    NSString *engText;   // 英単語の格納
    NSString *voiceUrl;     // 英単語のボイス
    
    NSInteger playerLife;   // プレイヤーのライフ
    
    //----------------------------------------------- game
    CCLayer *baseLayer;
    InterfaceLayer *interfaceLayer;
    EngController *engController;   // 敵の管理クラス
    CCLabelTTF *engLabel;
}
@property (nonatomic, readonly)NSString *engText;
@property (nonatomic, readonly)NSString *voiceURL;

@property (nonatomic, readonly)NSInteger playerLife;

@property (nonatomic, retain)CCLayer *baseLayer;
@property (nonatomic, retain)InterfaceLayer *interfaceLayer;
@property (nonatomic, retain)EngController *engController;
@property (nonatomic, readonly)CCLabelTTF *engLabel;

- (void)startGame;

- (void)result;

- (void)damege;

- (void)reset;

+ (GamePlay *)sharedInstance;
@end
