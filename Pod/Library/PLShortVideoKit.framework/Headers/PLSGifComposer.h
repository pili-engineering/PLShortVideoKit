//
//  PLSGifComposer.h
//  PLShortVideoKit
//
//  Created by 冯文秀 on 2017/7/28.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PLSGifComposer : NSObject

/**
 @abstract Gif 的名称，可以为 nil。当为 nil 时，内部会自动生成一个唯一的名称
 
 @since      v1.3.0
 */
@property (strong, nonatomic) NSString *gifName;

/**
 @abstract Gif 合成完成的 block。url 为 Gif 文件的地址

 @since      v1.3.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/**
 @abstract Gif 合成失败的 block
 
 @since      v1.3.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/**
 @abstract Gif 动图每帧间隔设置，默认 0.1f，若需自定义，请在调用 composeGif 合成前，设置该属性
 
 @since      v1.4.0
 */
@property (assign, nonatomic) CGFloat interval;

/**
 @brief 实例初始化方法
 
 @since      v1.3.0
 */
- (instancetype)initWithImagesArray:(NSArray *)imagesArray;

/**
 @brief 将视频帧／图片数组合成为 Gif 动图，合成结果的回调见 completionBlock，failureBlock
 
 @since      v1.3.0
 */
- (void)composeGif;

/**
 @brief 取消合成 Gif 动图
 
 @since      v1.4.0
 */
- (void)cancelComposeGif;

/**
 @brief UIImageView 加载 Gif 图
 *
 * @param frame UIImageView的frame
 *
 * @param superView UIImageView的父视图
 *
 * @param repeatCount gif播放重复次数，0 为无限循环

 @since      v1.3.0
 */
- (void)loadGifWithFrame:(CGRect)frame superView:(UIView *)superView repeatCount:(NSInteger)repeatCount;

@end
