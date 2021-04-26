//
//  PLSAsset.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2018/2/12.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/*!
 @class PLSAsset
 @brief PLSAsset 是对当前设备是否支持 H.265 硬编码/硬解码 的检查工具类
 
 @warning H.265 分为 hev 和 hvc 两种格式，目前苹果系的产品只支持 hvc 格式
 */
@interface PLSAsset : AVAsset

/*!
 @method isH265Video:
 @brief 判断 AVAsset 是否是 H.265 格式的视频文件
 
 @param asset 待判断的 AVAsset 实例
 
 @return 是否是 H.265 格式的视频
 */
+ (BOOL)isH265Video:(AVAsset *)asset;

/*!
 @method isSupportHardwareH265Decoder
 @brief 判断当前设备是否支持 H.265 硬解码
 
 @return 支持返回 YES，否则返回 NO
 */
+ (BOOL)isSupportHardwareH265Decoder;

/*!
 @method isSupportHardwareH265Encoder
 @brief 判断当前设备是否支持 H.265 硬编码
 
 @return 支持返回 YES，否则返回 NO
 */
+ (BOOL)isSupportHardwareH265Encoder;

@end
