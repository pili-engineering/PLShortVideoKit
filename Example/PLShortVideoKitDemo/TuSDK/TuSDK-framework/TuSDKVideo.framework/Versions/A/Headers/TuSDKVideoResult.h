//
//  TuSDKVideoResult.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 21/12/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

/**
 导出的视频文件类型
 */
typedef NS_ENUM(NSInteger,lsqFileType)
{
    /** MOV */
    lsqFileTypeQuickTimeMovie,
    
    /** MP4 */
    lsqFileTypeMPEG4
};

/**
 *  视频结果
 */
@interface TuSDKVideoResult : NSObject

/**
 *  临时视频文件路径
 */
@property (nonatomic, copy) NSString *videoPath;

/**
 *  相册视频对象
 */
@property (nonatomic, retain) id<TuSDKTSAssetInterface> videoAsset;

/**
 *  视频时长
 */
@property (nonatomic, assign) CGFloat duration;

/**
 *  SDK处理结果
 *
 *  @return SDK处理结果
 */
+ (instancetype)result;

@end
