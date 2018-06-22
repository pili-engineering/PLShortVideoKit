//
//  PLSAssetImageGenerator.h
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, PLSAssetInfoType) {
    PLSAssetInfoTypeVideo,
    PLSAssetInfoTypeImage
};

@interface PLSAssetInfo : NSObject

@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, assign) PLSAssetInfoType type;
@property (nonatomic, assign) CGFloat startTime;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat animDuration;

- (UIImage *)captureImageAtTime:(CGFloat)time outputSize:(CGSize)outputSize;

- (CGFloat)realDuration;

@end


@interface PLSAssetImageGenerator : NSObject

@property (nonatomic) CGSize outputSize;
@property (nonatomic) NSInteger imageCount;
@property (nonatomic, assign) CGFloat duration;

- (void)addVideoWithAsset:(AVAsset *)asset startTime:(CGFloat)startTime duration:(CGFloat)duration animDuration:(CGFloat)animDuration;

- (void)generateWithCompleteHandler:(void(^)(UIImage *))handler;

- (void)cancel;

@end

