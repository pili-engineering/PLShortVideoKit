//
//  PLSEditSettings.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/7/11.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLSTypeDefines.h"

// ------------------------------------------------------------------

/*!
 @constant	PLSMovieSettingsKey
 @abstract	视频对象的编辑信息
 @discussion
    存储的值的类型为 NSDictionary，包括 
    PLSURLKey,
    PLSAssetKey,
    PLSDurationKey,
    PLSStartTimeKey, 
    PLSVolumeKey,
    PLSNameKey
 
    Note: PLSURLKey 和 PLSAssetKey 中必须设置其中的一项.
 
 @since      v1.1.0
 */
PLS_EXPORT NSString *const PLSMovieSettingsKey;

/*!
 @constant	PLSAudioSettingsKey
 @abstract	音频对象的编辑信息
 @discussion
     存储的值的类型为 NSDictionary，包括
     PLSURLKey, 
     PLSDurationKey, 
     PLSStartTimeKey,
     PLSVolumeKey, 
     PLSNameKey
 
 @since      v1.1.0
 */
PLS_EXPORT NSString *const PLSAudioSettingsKey;

/*!
 @constant	PLSWatermarkSettingsKey
 @abstract	水印的设置信息
 @discussion
     存储的值的类型为 NSDictionary，包括
     PLSURLKey, 
     PLSSizeKey,
     PLSPointKey
 
 @since      v1.1.0
 */
PLS_EXPORT NSString *const PLSWatermarkSettingsKey;

// ------------------------------------------------------------------

PLS_EXPORT NSString *const PLSURLKey; /* NSURL */

PLS_EXPORT NSString *const PLSAssetKey; /* AVAsset */

PLS_EXPORT NSString *const PLSDurationKey; /* NSNumber(float) */

PLS_EXPORT NSString *const PLSStartTimeKey; /* NSNumber(float) */

PLS_EXPORT NSString *const PLSVolumeKey; /* NSNumber(float) */

PLS_EXPORT NSString *const PLSNameKey; /* NSString */

PLS_EXPORT NSString *const PLSSizeKey; /* NSValue(CGSize) */

PLS_EXPORT NSString *const PLSPointKey; /* NSValue(CGPoint) */










