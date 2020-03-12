//
//  TuSDKGPUSelectiveCircleFilter.h
//  TuSDK
//
//  Created by Clear Hu on 15/5/5.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
/**
 *  圆形选区滤镜
 */
@interface TuSDKGPUSelectiveCircleFilter : TuSDKTwoInputFilter
/// The center about which to apply the distortion, with a default of (0.5, 0.5)
@property(readwrite, nonatomic) CGPoint center;
/// The radius of the distortion, ranging from 0.0 to 1.0, with a default of 0.25
@property(readwrite, nonatomic) CGFloat radius;
/// The size of the area between the blurred portion and the clear circle, ranging from 0.0 to 1.0, with a default of 0.12
@property(readwrite, nonatomic) CGFloat excessive;
// 是否显示预览 默认不显示 0-1
@property(readwrite, nonatomic) CGFloat maskAlpha;
// 预览颜色 默认为白色
@property(readwrite, nonatomic) UIColor *maskColor;
// 旋转角度 0-360
@property(readwrite, nonatomic) CGFloat degree;
// 选区模式 (默认：0, 圆形 0.1, 矩形 0.2)
@property(readwrite, nonatomic) CGFloat selective;
@end
