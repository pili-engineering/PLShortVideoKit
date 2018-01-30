//
//  TuSDKVideoQuality.h
//  TuSDKVideo
//
//  Created by wen on 19/06/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 视频质量（TuSDKLiveVideoQuality_Default为默认配置）
 */
typedef NS_ENUM (NSUInteger, TuSDKRecordVideoQuality)
{
    /*
     * bitRate：1500 * 1000
     */
    TuSDKRecordVideoQuality_Low1 = 0,
    
    /*
     * bitRate：2000 * 1000
     */
    TuSDKRecordVideoQuality_Low2 = 1,
    
    /*
     * bitRate：2600 * 1000
     */
    TuSDKRecordVideoQuality_Low3 = 2,
    
    /*
     * bitRate：3000 * 1000
     */
    TuSDKRecordVideoQuality_Medium1 = 3,
    
    /*
     * bitRate：5000 * 1000
     */
    TuSDKRecordVideoQuality_Medium2 = 4,
    
    /*
     * bitRate：8000 * 1000
     */
    TuSDKRecordVideoQuality_Medium3 = 5,
    
    /*
     * bitRate：10000 * 1000
     */
    TuSDKRecordVideoQuality_High1 = 6,
    
    /*
     * bitRate：15000 * 1000
     */
    TuSDKRecordVideoQuality_High2 = 7,
    
    /*
     * bitRate：18000 * 1000
     */
    TuSDKRecordVideoQuality_High3 = 8,
    
    TuSDKRecordVideoQuality_Default = 9
};


@interface TuSDKVideoQuality : NSObject

/**
 视频的帧率   注：仅影响视频编码时的内部设置，若设置录制的帧率，请通过 camera.frameRate 进行设置
 */
@property (nonatomic, assign) int32_t lsqEncodeVideoFrameRate;

/**
 视频的码率，单位是bps
 */
@property (nonatomic, assign) NSUInteger lsqVideoBitRate;

/**
 编码时使用的压缩等级。默认情况下使用 AVVideoProfileLevelH264Main41，如果对于视频编码有额外的需求并且知晓该参数带来的影响可以自行更改
 */
@property (nonatomic, copy) NSString *lsqVideoProfileLevel;

/**
 默认视频配置
 
 @return
 */
+ (instancetype)defaultQuality;

/**
 根据视频画质枚举设置画质参数

 @param videoQuality 画质枚举
 @return 定义的画质对象
 */
+ (instancetype)makeQualityWith:(TuSDKRecordVideoQuality)videoQuality;

@end
