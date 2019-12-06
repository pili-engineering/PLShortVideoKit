//
//  TuSDKMediaMonsterFaceEffect.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/25.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectCore.h"
#import "TuSDKMonsterFaceWrap.h"

NS_ASSUME_NONNULL_BEGIN

/**
 哈哈镜特效
 @since v3.3.0
 */
@interface TuSDKMediaMonsterFaceEffect : TuSDKMediaEffectCore

/**
 初始化哈哈镜特效

 @param monsterFaceType 哈哈镜类型
 @return TuSDKMediaMonsterFaceEffect
 @since v3.3.0
 */
- (instancetype)initWithMonsterFaceType:(TuSDKMonsterFaceType)monsterFaceType;

/**
 哈哈镜code
 @since v3.3.0
 */
@property (nonatomic,readonly) TuSDKMonsterFaceType monsterFaceType;

@end

NS_ASSUME_NONNULL_END
