//
//  TuSDKPFStickerLocalGridViewBase.h
//  TuSDK
//
//  Created by Clear Hu on 15/9/8.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFSticker.h"

/**
 *  本地贴纸选择单元格视图基础类
 */
@interface TuSDKPFStickerLocalGridViewBase : UIButton
/**
 *  图片视图
 */
@property(nonatomic,readonly) UIImageView *thumbView;

/**
 *  贴纸对象数据
 */
@property (nonatomic, retain) TuSDKPFSticker *data;

/**
 *  需要重置视图
 */
-(void)viewNeedRest;
@end
