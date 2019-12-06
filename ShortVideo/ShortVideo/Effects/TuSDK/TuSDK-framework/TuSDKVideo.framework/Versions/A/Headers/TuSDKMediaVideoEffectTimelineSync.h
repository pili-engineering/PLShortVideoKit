//
//  TuSDKMediaVideoEffectTimelineSync.h
//  TuSDKVideo
//
//  Created by sprint on 17/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaEffect.h"
#import "TuSDKComboFilterWrapChain.h"
#import "TuSDKMediaEffectSync.h"

@interface TuSDKMediaVideoEffectTimelineSync : NSObject <TuSDKMediaEffectSync,TuSDKFilterFacePositionProtocol>

{
    @protected
    TuSDKComboFilterWrapChain *_wrapChain;
}

/**
 初始化 TuSDKMediaVideoEffectSync
 
 @param wrapChain 特效关系链式
 @return TuSDKMediaVideoEffectSync
 
 @since v3.0.1
 */
- (instancetype)initWithWrapChain:(TuSDKComboFilterWrapChain *)wrapChain;

/**
 预览的分辨率
 
 @sinc v3.0.1
 */
@property (nonatomic)CGSize outputSize;

/**
 预览时裁剪范围
 
 @sinc v3.0.1
 */
@property (nonatomic,assign)CGRect cropRect;


/**
 是否可以播放音频特效 默认: YES
 @sinc v3.0.1
 */
@property (nonatomic) BOOL audioPlayable;

/**
 暂停播放音频特效
 
 @since v3.0.1
 */
- (void)pauseAudioEffect;

/**
 暂停播放音频特效
 
 @since v3.4.1
 */
- (void)stopAudioEffect;

@end
