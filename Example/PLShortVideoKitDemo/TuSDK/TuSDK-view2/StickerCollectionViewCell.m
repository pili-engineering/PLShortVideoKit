//
//  StickerCollectionViewCell.m
//  TuSDKVideoDemo
//
//  Created by wen on 21/08/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "StickerCollectionViewCell.h"
#import <TuSDKVideo/TuSDKVideo.h>

@interface StickerCollectionViewCell ()

@end

@implementation StickerCollectionViewCell

#pragma mark - setter getter

- (void)setBorderColor:(UIColor *)borderColor;
{
    _borderColor = borderColor;
    self.layer.borderWidth = 2;
    self.layer.borderColor = _borderColor.CGColor;
}

#pragma mark - init method

// 初始化cell 视图
- (void)initCellViewWith:(id)object;
{
    [self removeAllSubviews];
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.lsqGetSizeWidth, self.lsqGetSizeHeight)];
    iv.center = CGPointMake(self.lsqGetSizeWidth/2, self.lsqGetSizeHeight/2);
    iv.contentMode = UIViewContentModeScaleAspectFit;
    iv.image = nil;
    iv.contentMode = UIViewContentModeScaleToFill;

    if ([object isKindOfClass:[TuSDKPFStickerGroup class]]) {
        // 本地有该贴纸
        TuSDKPFStickerGroup *sticker = object;
        [[TuSDKPFStickerLocalPackage package] loadThumbWithStickerGroup:sticker imageView:iv];
        [self addSubview:iv];
    }else if ([object isKindOfClass:[NSDictionary class]]) {
        // 需下载
        NSDictionary *stickerDic = object;
        NSString *urlStr = [stickerDic objectForKey:@"previewImage"];
        [iv lsq_setImageWithURL:[NSURL URLWithString:urlStr]];
        [self addSubview:iv];
        
        UIImageView *downloadIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        downloadIV.tag = 201;
        downloadIV.center = CGPointMake(self.lsqGetSizeWidth - 10, self.lsqGetSizeHeight - 10);
        downloadIV.image = [UIImage imageNamed:@"style_default_1.7.0_download_icon"];
        [self addSubview:downloadIV];
    }else if (object == nil){
        // 显示取消贴纸图片
        iv.bounds = CGRectMake(0, 0, 30, 30);
        iv.image = [UIImage imageNamed:@"video_style_default_btn_sticker_off"];
        [self addSubview:iv];
    }
}

// 展示下载中视图
- (void)displayDownloadingView;
{
    for (UIView *view in self.subviews) {
        if (view.tag == 201) {
            [view removeFromSuperview];
        }
    }
    
    UIImageView *animationView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    animationView.image = [UIImage imageNamed:@"style_default_1.7.0_loading_icon"];
    animationView.center = CGPointMake(self.lsqGetSizeWidth/2, self.lsqGetSizeHeight/2);
    animationView.tag = 301;
    [self addSubview:animationView];
    [self startLoadingAnimationWith:animationView];
}

#pragma mark - help method

- (void)removeAllSubviews;
{
    for (UIView *view in self.subviews) {
        if (view.tag == 301) {
            [view.layer removeAllAnimations];
        }
        [view removeFromSuperview];
    }
    self.layer.borderColor = [UIColor clearColor].CGColor;
}


// 旋转动画
- (void)startLoadingAnimationWith:(UIView *)view;
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithDouble:0];
    animation.toValue = [NSNumber numberWithDouble:M_PI*2];
    animation.duration = 1.5;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    [view.layer addAnimation:animation forKey:nil];
}

@end
