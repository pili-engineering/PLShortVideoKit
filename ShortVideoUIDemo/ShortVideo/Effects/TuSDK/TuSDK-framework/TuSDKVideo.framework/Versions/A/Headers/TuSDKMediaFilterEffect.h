//
//  TuSDKMediaFilterEffectData.h
//  TuSDKVideo
//
//  Created by sprint on 19/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKMediaEffectCore.h"

/**
 滤镜特效
 @since v2.2.0
 */
@interface TuSDKMediaFilterEffect : TuSDKMediaEffectCore <TuSDKMediaEffectParameterProtocol>

/**
 初级滤镜code初始化
 
 @param effectCode 滤镜code
 @return TuSDKMediaFilterEffectData
 @since v3.0
 */
- (instancetype)initWithEffectCode:(NSString *)effectCode atTimeRange:(TuSDKTimeRange *)timeRange;

/**
 初级滤镜code初始化

 @param effectCode 滤镜code
 @return TuSDKMediaFilterEffectData
 @since v2.2.0
 */
- (instancetype)initWithEffectCode:(NSString *)effectCode;

/**
  滤镜特效code
  @since v2.2.0
 */
@property (nonatomic,copy,readonly) NSString *effectCode;

/**
 设置是否开启大眼瘦脸 默认：NO
 该配置已废弃，在 v3.2.0 版本中已新增 TuSDKMediaPlasticFaceEffect 特效。
 @since v2.2.0
 */
@property (nonatomic) BOOL enablePlastic DEPRECATED_MSG_ATTRIBUTE("Pelease use TuSDKMediaPlasticFaceEffect");;

@end
