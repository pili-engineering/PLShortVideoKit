//
//  PLSVideoEditingController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "PLShortVideoKit/PLShortVideoKit.h"

typedef NS_ENUM(NSUInteger, PLSVideoEditOperationType) {
    /** 涂鸦 */
    PLSVideoEditOperationType_draw = 1 << 0,
    /** 贴图 */
    PLSVideoEditOperationType_sticker = 1 << 1,
    /** 文本 */
    PLSVideoEditOperationType_text = 1 << 2,
    /** 所有 */
    PLSVideoEditOperationType_All = ~0UL,
};

@protocol PLSVideoEditingControllerDelegate;

@interface PLSVideoEditingController : UIViewController

/** 是否隐藏状态栏 默认YES */
@property (nonatomic, assign) BOOL isHiddenStatusBar;

/// 自定义外观颜色
@property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
@property (nonatomic, strong) UIColor *cancelButtonTitleColorNormal;
/// 自定义文字
@property (nonatomic, copy) NSString *oKButtonTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *processHintStr;

//- (void)showProgressHUDText:(NSString *)text;
- (void)showProgressHUD;
- (void)hideProgressHUD;

/** 初始化 */
- (instancetype)initWithOrientation:(UIInterfaceOrientation)orientation;

#pragma mark -- 编辑

/** 视频旋转方向 */
@property (nonatomic, assign) PLSPreviewOrientation videoLayerOrientation;
/** 设置编辑对象->重新编辑 */
@property (nonatomic, strong) PLSVideoEdit *videoEdit;
/** 编辑模式 */
@property (nonatomic, strong) PLSVideoEditingView *editingView;
/** 编辑视频 */
@property (nonatomic, readonly) UIImage *placeholderImage;
@property (nonatomic, readonly) AVAsset *asset;
@property (nonatomic, readonly) CMTimeRange timeRange;

/** 设置编辑视频路径->重新初始化 */
- (void)setVideoURL:(NSURL *)url timeRange:(CMTimeRange)timeRange placeholderImage:(UIImage *)image;
- (void)setVideoAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange placeholderImage:(UIImage *)image;

/** 设置操作类型 default is PLSVideoEditOperationType_All */
@property (nonatomic, assign) PLSVideoEditOperationType operationType;
/** 自定义贴图资源 */
@property (nonatomic, strong) NSString *stickerPath;

/** 代理 */
@property (nonatomic, weak) id<PLSVideoEditingControllerDelegate> delegate;

@end

@protocol PLSVideoEditingControllerDelegate <NSObject>

- (void)VideoEditingController:(PLSVideoEditingController *)videoEditingVC didCancelPhotoEdit:(PLSVideoEdit *)videoEdit;
- (void)VideoEditingController:(PLSVideoEditingController *)videoEditingVC didFinishPhotoEdit:(PLSVideoEdit *)videoEdit;

@end
