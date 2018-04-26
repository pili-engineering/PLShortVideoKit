//
//  TuSDKFace2DComboFilterWrap.h
//  TuSDK
//
//  Created by Clear Hu on 2017/11/19.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterWrap.h"
#import "TuSDKFilterParameter.h"

/** Face 2D Combo Filter Wrap*/
@interface TuSDKFace2DComboFilterWrap : TuSDKFilterWrap<TuSDKFilterStickerProtocol>
/**
 *  初始化滤镜对象包装
 *
 *  @return opt 滤镜对象包装
 */
+ (nullable instancetype) init;

/** 是否开启大眼瘦脸*/
@property (nonatomic) BOOL enablePlastic;
/**
 设置是否显示贴纸
 @param isVisibility 是否显示贴纸，YES：显示贴纸   NO：不显示
 */
@property (nonatomic) BOOL stickerVisibility;
@end
