//
//  TuSDKPFEditTextControllerBase.h
//  TuSDK
//
//  Created by wen on 24/07/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKCPImageResultController.h"
#import "TuSDKICMaskRegionView.h"
#import "TuSDKPFTextView.h"

@interface TuSDKPFEditTextControllerBase : TuSDKCPImageResultController

/**
 *  裁剪区域视图
 */
@property (nonatomic, readonly) TuSDKICMaskRegionView *cutRegionView;

/**
 *  贴纸视图
 */
@property (nonatomic, readonly) TuSDKPFTextView *textView;

/**
 *  添加文字
 */
- (void)appendText;

/**
 *  编辑图片完成按钮动作
 */
- (void)onImageCompleteAtion;

@end
