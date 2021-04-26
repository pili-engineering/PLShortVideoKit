//
//  PLSFile.h
//  PLShortVideoKit
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class PLSFileSection;

/*!
 @class PLSFile
 @abstract 视频录制文件类
 
 @since      v1.0.0
 */
@interface PLSFile : NSObject

/*!
 @property filesArray
 @abstract 保存所有视频段信息的数组
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSMutableArray<PLSFileSection *> *__nullable filesArray;

/*!
 @property currentFileURL
 @abstract 当前视频段的地址
 
 @since      v1.0.0
 */
@property (strong, nonatomic) NSURL *__nullable currentFileURL;

/*!
 @property currentFileDuration
 @abstract 当前视频段的时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat currentFileDuration;

/*!
 @property totalDuration
 @abstract 所有视频段的总时长
 
 @since      v1.0.0
 */
@property (assign, nonatomic) CGFloat totalDuration;

@end
