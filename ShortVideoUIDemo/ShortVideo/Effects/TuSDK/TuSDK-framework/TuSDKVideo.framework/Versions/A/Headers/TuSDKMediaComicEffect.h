//
//  TuSDKMediaComicEffect.h
//  TuSDKVideo
//
//  Created by sprint on 2018/11/16.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"

/**
 漫画特效
 @since v3.0.1
 */
@interface TuSDKMediaComicEffect : TuSDKMediaEffectCore

/**
 根据漫画特效代号 code 初始化
 
 @param code 漫画特效代号 code
 @return TuSDKMediaCartoonEffect
 @since v3.0.1
 */
- (instancetype)initWithEffectCode:(NSString *)code;

/**
 漫画特效代号
 @since v3.0.1
 */
@property (nonatomic,copy,readonly) NSString *effectCode;

@end
