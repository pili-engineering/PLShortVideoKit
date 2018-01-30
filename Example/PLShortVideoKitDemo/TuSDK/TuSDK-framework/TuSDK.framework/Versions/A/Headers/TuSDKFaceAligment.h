//
//  TuSDKFaceAligment.h
//  TuSDK
//
//  Created by Yanlin Qiu on 21/08/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - TuSDKFaceAligment
/** 人脸对齐信息 (归一百分比) */
@interface TuSDKFaceAligment : NSObject
/** 人脸区域 */
@property (nonatomic) CGRect rect;
/** 对齐信息 */
@property (nonatomic, readonly, retain) NSArray<NSValue *> *marks;
/** 原始对齐信息 */
@property (nonatomic, retain) NSArray<NSValue *> *orginMarks;

/** 仰角／俯角 */
@property (nonatomic) CGFloat pitch;

/** 左右旋转角度 */
@property (nonatomic) CGFloat yaw;

/** 翻滚角 */
@property (nonatomic) CGFloat roll;
@end
