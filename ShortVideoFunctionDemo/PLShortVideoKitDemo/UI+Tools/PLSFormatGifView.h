//
//  PLSFormatGifView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/7/31.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PLSFormatGifViewCell : UICollectionViewCell
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) UIImage *imageData;

@end

@class PLSFormatGifView;
@protocol PLSFormatGifViewDelegate <NSObject>
@optional
/**
 *  每次操作选择
 *
 *  @param formatGifView 当前view
 *
 *  @param selectedArray 视频帧数组
 */
- (void)formatGifView:(PLSFormatGifView *)formatGifView selectedArray:(NSArray *)selectedArray;

/**
 *  预览查看
 *
 *  @param formatGifView 当前view
 *
 *  @param previewArray 预览视频帧数组
 */
- (void)formatGifView:(PLSFormatGifView *)formatGifView previewArray:(NSArray *)previewArray;

@end

@interface PLSFormatGifView : UIView

@property (nonatomic, weak) id<PLSFormatGifViewDelegate> delegate;

- (instancetype)initWithMovieURL:(NSURL *)url minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration;

- (instancetype)initWithMovieAsset:(AVAsset *)asset minDuration:(Float64)minDuration maxDuration:(Float64)maxDuration;

@end
