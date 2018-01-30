//
//  TuSDKFilterParameter.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/11.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "TuSDKFaceAligment.h"

@class TuSDKFilterParameter;

#pragma mark - TuSDKFilterParameterProtocol
/**
 *  滤镜配置选项协议
 */
@protocol TuSDKFilterParameterProtocol <NSObject>
/**
 *  滤镜配置选项
 */
@property (nonatomic, retain) TuSDKFilterParameter *parameter;

/**
 *  提交滤镜配置选项
 */
- (void)submitParameter;
@end

#pragma mark - TuSDKFilterTexturesProtocol
/**
 *  材质协议
 */
@protocol TuSDKFilterTexturesProtocol <NSObject>
/**
 *  加载材质
 *
 *  @param textures 材质列表
 */
- (void)appendTextures:(NSArray *)textures;
@end


#pragma mark - TuSDKFilterFacePositionProtocol
/**
 *  人脸特征点协议
 */
@protocol TuSDKFilterFacePositionProtocol <NSObject>
/**
 *  更新信息
 *
 *  @param faces  脸
 *  @param radian 设备弧度
 */
- (void)updateFaceFeatures:(NSArray<TuSDKFaceAligment *> *)faces radian:(CGFloat)radian;
@end


#pragma mark - TuSDKFilterStickerProtocol
/**
 *  滤镜贴纸协议
 */
@protocol TuSDKFilterStickerProtocol <TuSDKFilterFacePositionProtocol>

/**
 *  更新贴纸数据
 *
 *  @param stickers 要显示的贴纸数据
 */
- (void)setLiveStickers:(NSArray *)stickers;

/**
 设置显示区域和视图比例
 
 @param displayRect 显示区域
 @param ratio 画面比例
 */
- (void)setDisplayRect:(CGRect)displayRect withRatio:(CGFloat)ratio;

/**
 设置是否根据计时时间自动播放贴纸  注：视频剪辑中贴纸时间使用视频帧时间设置贴纸帧的index，录制中贴纸时间根据定时器时间自动播放

 @param isAutoplay 是否根据计时时间自动播放贴纸，若不调用该方法，默认值为 YES
 */
- (void)setAutoplayStickers:(BOOL)isAutoplay;

/**
 根据某个时间设置贴纸 index
 
 @param time 时间参数
 */
- (void)seekToStickerIndexByTime:(CMTime)time;

/**
 设置贴纸显示时间，当选择了某一段视频时，需要传入此参数进行贴纸帧和视频帧时间的校对
 */
- (void)setStickerShowTime:(CMTime)stickerShowTime;

/**
 设置是否显示贴纸
 
 @param isVisibility 是否显示贴纸，YES：显示贴纸   NO：不显示
 */
- (void)setStickerVisibility:(BOOL)isVisibility;
@end

#pragma mark - TuSDKFilterArg
/** 滤镜参数*/
@interface TuSDKFilterArg : NSObject
/** 设置百分比 0 - 1*/
@property (nonatomic) CGFloat precent;

/** 获取值*/
@property (nonatomic, readonly) CGFloat value;

/** 参数键名*/
@property (nonatomic, readonly) NSString *key;

/** 默认值*/
- (void)reset;
@end

#pragma mark - TuSDKFilterParameter
/** 滤镜配置选项*/
@interface TuSDKFilterParameter : NSObject
/** 参数列表*/
@property (nonatomic, readonly) NSArray *args;

/** 参数键名列表*/
@property (nonatomic, readonly) NSArray *argKeys;

/** 配置参数总数*/
@property (nonatomic, readonly) NSUInteger count;

/** 是否已初始化*/
@property (nonatomic, readonly) BOOL isInited;

/**
 *  滤镜配置选项
 *
 *  @return parameter 滤镜配置选项
 */
+ (instancetype)parameter;

/**
 *  滤镜配置选项
 *
 *  @param args 自定义参数
 *
 *  @return args 滤镜配置选项
 */
+ (instancetype)parameterWithArgs:(NSDictionary *)args;

/**
 *  获取已改变数值的参数列表
 */
- (NSArray *)changedArgs;

/**
 *  重置参数
 */
- (void)reset;

/**
 *  强制刷新滤镜参数
 */
- (void)forceProcessing;

/**
 *  重置参数
 *
 *  @param key 参数键名
 */
- (void)resetWithKey:(NSString *)key;

/**
 *  获取滤镜参数
 *
 *  @param key 参数键名
 *
 *  @return key 滤镜参数
 */
- (TuSDKFilterArg *)argWithKey:(NSString *)key;

/**
 *  获取默认配置参数值
 *
 *  @param key 参数键名
 *
 *  @return key 参数值
 */
- (CGFloat)argWithDefaultKey:(NSString *)key;

/**
 *  设置滤镜参数百分比
 *
 *  @param key     参数键名
 *  @param precent 百分比 0 - 1
 */
- (void)setArgWithKey:(NSString *)key precent:(CGFloat)precent;

/**
 *  步进滤镜参数百分比
 *
 *  @param key     参数键名
 *  @param precent 百分比 0 - 1
 */
- (void)stepArgWithKey:(NSString *)key precent:(CGFloat)precent;

/**
 * 添加一个浮点参数
 *
 * @param key
 *            参数键名
 * @param value
 *            当前值
 * @param minValue
 *            最小值
 * @param maxValue
 *            最大值
 */
- (void)appendFloatArgWithKey:(NSString *)key
                        value:(CGFloat)value
                     minValue:(CGFloat)minValue
                     maxValue:(CGFloat)maxValue;

/**
 合并滤镜参数

 @param other 其他滤镜参数
 */
- (void)merge:(TuSDKFilterParameter *)other;

/**
 同步滤镜参数

 @param other 其他滤镜参数
 */
- (void)syncArgs:(TuSDKFilterParameter *)other;
@end
