//
//  TuSDKMediaEffectParameterProtocol.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/17.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

NS_ASSUME_NONNULL_BEGIN

/**
 特效参数调节协议
 
 @since v3.2.0
 */
@protocol TuSDKMediaEffectParameterProtocol <NSObject>

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

/**
 重置参数
 
 @since v3.1.2
 */
- (void)resetParameters;

@end

NS_ASSUME_NONNULL_END
