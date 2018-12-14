//
//  TuSdkPlasticFace.h
//  TuSDK
//
//  Created by hecc on 2018/8/16.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

@interface TuSdkPlasticFace : TuSDKFilter<TuSDKFilterParameterProtocol, TuSDKFilterFacePositionProtocol>

/**
 * 扩眼参数
 */
@property(readwrite,nonatomic)CGFloat eyeEnlargeSize;

/**
 * 廋脸参数
 */
@property(readwrite,nonatomic)CGFloat chinSize ;


/**
 * 瘦鼻参数
 */
@property(readwrite,nonatomic)float mNoseSize ;
/**
 * 嘴宽
 */
@property(readwrite,nonatomic)float mMouthWidth ;

/**
 * 细眉
 */
@property(readwrite,nonatomic)float mArchEyebrow;

/**
 * 眼距
 */
@property(readwrite,nonatomic)float mEyeDis;

/**
 * 眼角
 */
@property(readwrite,nonatomic)float mEyeAngle;

/**
 * 下巴
 */
@property(readwrite,nonatomic)float mJawSize;



@end
