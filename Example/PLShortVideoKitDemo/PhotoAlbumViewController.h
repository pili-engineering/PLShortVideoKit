//
//  PhotoAlbumViewController.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//


/**
 * WARNING: 本自定义相册只做演示用，若用于上线的 APP 中，则需按需求修改。
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "PLSRateButtonView.h"

@interface PLSScrollView : UIView

- (id)initWithFrame:(CGRect)frame withImages:(NSMutableArray *)images;

@property(strong, nonatomic) UIScrollView *scrollView;

@property(strong, nonatomic) NSMutableArray *images;

@property(strong, nonatomic) NSMutableArray *imageViews;

@property (strong, nonatomic) NSMutableArray *selectedAssets;

- (void)addImage:(UIImage *)image;

@end


@interface PHAsset (PLSImagePickerHelpers)

- (NSURL *)movieURL;

- (UIImage *)imageURL:(PHAsset *)phAsset targetSize:(CGSize)targetSize;

- (NSURL *)getImageURL:(PHAsset *)phAsset;

- (NSData *)getImageData:(PHAsset *)phAsset;

@end


@interface PLSAssetCell : UICollectionViewCell

@property (strong, nonatomic) PHAsset *phAsset;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) PHImageRequestID imageRequestID;
@property (strong, nonatomic) UILabel *durationLabel;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSString *localIdentifier;
@end


@interface PhotoAlbumViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *assets;
@property (assign, nonatomic) NSInteger maxSelectCount;
@property (assign, nonatomic) PHAssetMediaType mediaType;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) PLSRateButtonView *rateButtonView;

@property (strong, nonatomic) PLSScrollView *dynamicScrollView;

// 0 剪辑 1 转码 2 拼接
@property (assign, nonatomic) NSInteger typeIndex;

- (void)nextButtonClick:(UIButton *)sender;

- (void)fetchAssetsWithMediaType:(PHAssetMediaType)mediaType;

@end

