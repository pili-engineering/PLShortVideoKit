//
//  AVAsset+PLSTransformFix.h
//  PLShortVideoKit
//
//  Created by hxiongan on 2018/6/8.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PLSTypeDefines.h"

/*!
 @category AVAsset (PLSTransformFix)
 @brief PLSTransformFix 是一个处理 AVAsset 旋转角度的分类
 */
@interface AVAsset (PLSTransformFix)

/*!
 @method verifytransform
 @brief 某些视频的transform可能不正确，主要是tx和ty这两个值可能错误，这种错误在单个视频播放中不会有影响，但是加在AVMutableCompositionTrack中，则会影响显示的位置
 
 @return 返回视频修正后的 CGAffineTransform
 @see verifytransform:naturalSize:
 */
- (CGAffineTransform)verifytransform;

/*!
 @method verifytransform:naturalSize:
 @brief 某些视频的 transform 可能不正确，主要是tx和ty这两个值可能错误，这种错误在单个视频播放中不会有影响，但是加在AVMutableCompositionTrack中，则会影响显示的位置
 
 @param transform 待修正的 CGAffineTransform
 @param naturalSize 修正参考的宽高
 
 @return 返回修正后的 CGAffineTransform
 */
- (CGAffineTransform)verifytransform:(CGAffineTransform)transform naturalSize:(CGSize)naturalSize;

/*!
 @method isPortrait
 @brief 检查视频是横屏还是竖屏
 
 @discussion iOS 设备自带相机 App 拍摄的时候：
    1. Home 键在上或者下的时候，返回 YES
    2. Home 键在左或者右的时候，返回 NO
 
 @return 视频是否是 Portrait
 */
- (BOOL)isPortrait;

/*!
 @method checkForPortrait:
 @brief 检查 CGAffineTransform 是横屏还是竖屏
 
 @param transform 待检查的 CGAffineTransform
 
 @return transform 是否是 Portrait
 @see isPortrait
 */
- (BOOL)checkForPortrait:(CGAffineTransform)transform;

/*!
 @method transformWithVideoAssetTrack:fillMode:displayFrame:
 @brief  视频旋转
 @discussion 将 videoAssetTrack 按照 fillMode 放到 displayFrame，如果 displayFrame = CGRectZero，则放到 {0，0，videoAssetTrack的显示宽度，videoAssetTrack的显示高度}，方法内部会自动处理 videoAssetTrack.preferredTransform 属性
 
 @param videoAssetTrack 待旋转的视频通道
 @param fillMode 视频宽高和 displayFrame.size 比例不一样的时候，视频的填充模式
 @param displayFrame 目标显示位置和大小

 @return 返回结果 CGAffineTransform
 @since      v1.12.0
 */
- (CGAffineTransform)transformWithVideoAssetTrack:(AVAssetTrack *)videoAssetTrack
                                         fillMode:(PLSVideoFillModeType)fillMode
                                     displayFrame:(CGRect)displayFrame;

/*!
 @method transformWithVideoAssetTrack:fillMode:rotateAngle:displayFrame
 @brief  视频旋转
 @discussion 将 videoAssetTrack 旋转之后（方法内部会自动加上videoAssetTrack.preferredTransform），按照 fillMode 放到 displayFrame，如果 displayFrame = CGRectZero，则方到 {0，0，videoAssetTrack的显示宽度，videoAssetTrack的显示高度}
 
 @param videoAssetTrack 待旋转的视频通道
 @param fillMode 视频宽高和 displayFrame.size 比例不一样的时候，视频的填充模式
 @param rotateAngle 视频选择的角度（单位: 弧度）
 @param displayFrame 目标显示位置和大小
 
 @return 返回结果 CGAffineTransform
 @since      v1.12.0
 */

- (CGAffineTransform)transformWithVideoAssetTrack:(AVAssetTrack *)videoAssetTrack
                                         fillMode:(PLSVideoFillModeType)fillMode
                                      rotateAngle:(CGFloat)rotateAngle
                                     displayFrame:(CGRect)displayFrame;

@end
