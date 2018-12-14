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
@interface TuSDKMediaFilterEffect : TuSDKMediaEffectCore 

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
 @since v2.2.0
 */
@property (nonatomic) BOOL enablePlastic;

@end

#pragma mark Filter Parameters

/**
 获取及设置滤镜参数
 @since v2.2.0
 */
@interface TuSDKMediaFilterEffect (FilterParameters)

/**
 获取所有可调节的滤镜参数

 @return NSArray<TuSDKFilterArg *> *
 @since v2.2.0
 */
- (NSArray<TuSDKFilterArg *> *)filterArgs;

/**
 *  获取滤镜参数
 *
 *  @param key 参数键名
 *  @return 滤镜参数
 * @since v3.0.1
 */
- (TuSDKFilterArg *)argWithKey:(NSString *)key;

/**
 改变滤镜参数
 
 @param paramIndex 参数索引
 @param precent 参数值
 @since v2.2.0
 */
- (void)submitParameter:(NSUInteger)paramIndex argPrecent:(CGFloat)precent;

/**
 改变滤镜参数
 
 @param paramKey 参数 key
 @param precent 参数值
 @since v3.0.1
 */
- (void)submitParameterWithKey:(NSString *)paramKey argPrecent:(CGFloat)precent;

/**
 提交滤镜参数
 
 @since v2.2.0
 */
- (void)submitParameters;

@end
