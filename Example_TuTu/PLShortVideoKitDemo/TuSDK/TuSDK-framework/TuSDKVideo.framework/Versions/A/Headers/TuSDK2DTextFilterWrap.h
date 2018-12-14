//
//  TuSDKText2DFilterWrap.h
//  TuSDK
//
//  Created by tutu on 2018/6/11.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import "TuSDKVideoImport.h"

/**
 文字特效FilterWrap
 @since     v2.2.0
 */
@interface TuSDK2DTextFilterWrap : TuSDKFilterWrap

/**
  贴纸数据
  @since     v2.2.0
 */
@property (nonatomic,strong) TuSDKTextStickerImage *text2DStickerImage;

/**
 贴纸数组
 @since     v2.2.0
 */
@property (nonatomic,strong) NSMutableArray * textStickers;

@end
