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

@end


@interface PLSAssetCell : UICollectionViewCell

@property (strong, nonatomic) PHAsset *asset;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) PHImageRequestID imageRequestID;

@end


@interface PhotoAlbumViewController : UICollectionViewController

@property (assign, nonatomic) NSInteger maxSelectCount;
@property (assign, nonatomic) PHAssetMediaType mediaType;
@end

