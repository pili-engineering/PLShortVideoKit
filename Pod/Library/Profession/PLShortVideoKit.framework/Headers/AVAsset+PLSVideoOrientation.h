//
//  AVAsset+PLSVideoOrientation.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/5/26.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/*!
 @typedef isSupportHardwareH265Encoder
 @brief 视频选择方向定义
 */
typedef enum {
    PLSVideoOrientationUp,               //Device starts recording in Portrait
    PLSVideoOrientationDown,             //Device starts recording in Portrait upside down
    PLSVideoOrientationLeft,             //Device Landscape Left  (home button on the left side)
    PLSVideoOrientationRight,            //Device Landscape Right (home button on the Right side)
    PLSVideoOrientationNotFound = 99     //An Error occurred or AVAsset doesn't contains video track
} PLSVideoOrientation;


/*!
 @category AVAsset (PLSVideoOrientation)
 @brief 获取视频选择方向的分类
 */
@interface AVAsset (PLSVideoOrientation)

/*!
 @property videoOrientation
 @discussion Returns a PLSVideoOrientation that is the orientation
 of the iPhone / iPad whent starst recording
 
 @return A PLSVideoOrientation that is the orientation of the video
 */
@property (readonly, nonatomic) PLSVideoOrientation videoOrientation;

/*!
 @property videoDegree
 @discussion  Returns a PLSVideoOrientation that is the orientation
 of the iPhone / iPad whent starst recording
 
 @return A videoDegree that is the degree of the video
 */
@property (readonly, nonatomic) CGFloat videoDegree;

@end
