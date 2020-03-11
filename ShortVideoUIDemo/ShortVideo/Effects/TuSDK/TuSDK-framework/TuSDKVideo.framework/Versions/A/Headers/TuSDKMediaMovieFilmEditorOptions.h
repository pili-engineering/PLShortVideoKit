//
//  TuSDKMediaMovieFilmEditorOptions.h
//  TuSDKVideo
//
//  Created by sprint on 10/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "TuSDKVideoImport.h"
#import "TuSDKVideoQuality.h"


/**
 视频剪辑器配置项
 
 @since v3.0.1
 */
@interface TuSDKMediaMovieFilmEditorOptions : NSObject

/**
 视频导出尺寸.  默认: CGSizeZero SDK自动计算最佳宽高
 
 @since v3.0.1
 */
@property (nonatomic,assign) CGSize exportVideoSize;

/**
 设置导出的视频画质
 
 @since v3.0.1
 */
@property (nonatomic, strong) TuSDKVideoQuality * _Nullable exportQuality;

/**
 是否将编辑后的是视频保存至系统相册  默认 : YES
 
 @since v3.0.1
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 保存到相册的名称
 
 @since v3.0.1
 */
@property (nonatomic, copy) NSString * _Nullable saveToAlbumName;



@end
