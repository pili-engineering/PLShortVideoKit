//
//  PLShortVideoEditor.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/7/10.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSEditPlayer.h"

@interface PLShortVideoEditor : NSObject

@property (strong, nonatomic) PLSEditPlayer *player;
@property (strong, nonatomic) PLSEditPlayer *audioPlayer;

/**
 @brief 编辑完成时的 block 回调
 
 @since      v1.1.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @brief 使用 NSURL 初始化编辑实例
 
 @since      v1.1.0
 */
- (instancetype)initWithURL:(NSURL *)url;

/**
 @brief 使用 AVAsset 初始化编辑实例
 
 @since      v1.1.0
 */
- (instancetype)initWithAsset:(AVAsset *)asset;

/**
 @brief 加载编辑信息，实时预览编辑效果
 
 @since      v1.1.0
 */
- (void)startEditing:(NSDictionary *)editSettings;

/**
 @brief 停止实时预览编辑效果
 
 @since      v1.1.0
 */
- (void)stopEditing;

@end


