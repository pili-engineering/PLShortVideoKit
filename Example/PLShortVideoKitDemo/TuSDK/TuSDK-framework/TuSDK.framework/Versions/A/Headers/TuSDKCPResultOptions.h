//
//  TuSDKCPResultOptions.h
//  TuSDK
//
//  Created by Clear Hu on 14/12/11.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import "TuSDKCPOptions.h"
#import <CoreGraphics/CoreGraphics.h>
#import "TuSDKCPResultViewController.h"

/**
 *  处理结果视图控制器选项
 */
@interface TuSDKCPResultOptions : TuSDKCPOptions
/**
 *  保存到临时文件 (默认不保存, 当设置为YES时, TuSDKResult.tmpFile)
 */
@property (nonatomic) BOOL saveToTemp;

/**
 *  保存到系统相册 (默认不保存, 当设置为YES时, TuSDKResult.asset)
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 *  保存到系统相册的相册名称
 */
@property (nonatomic, copy) NSString *saveToAlbumName;

/**
 *  照片输出压缩率 0-1 如果设置为0 将保存为PNG格式  (默认: 0.95)
 */
@property (nonatomic) CGFloat outputCompress;
@end
