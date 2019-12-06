//
//  PLSGifComposer.h
//  PLShortVideoKit
//
//  Created by 冯文秀 on 2017/7/28.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

/*!
 @class PLSGifComposer
 @brief 图片生成 GIF 类
 */
@interface PLSGifComposer : NSObject

/*!
 @property gifName
 @abstract Gif 的名称，可以为 nil。当为 nil 时，内部会自动生成一个唯一的名称
 
 @since      v1.3.0
 */
@property (strong, nonatomic) NSString *gifName;

/*!
 @property completionBlock
 @abstract Gif 合成完成的 block。url 为 Gif 文件的地址

 @since      v1.3.0
 */
@property (copy, nonatomic) void(^completionBlock)(NSURL *url);

/*!
 @property failureBlock
 @abstract Gif 合成失败的 block
 
 @since      v1.3.0
 */
@property (copy, nonatomic) void(^failureBlock)(NSError* error);

/*!
 @property interval
 @abstract Gif 动图每帧间隔设置，默认 0.1f，若需自定义，请在调用 composeGif 合成前，设置该属性
 
 @since      v1.4.0
 */
@property (assign, nonatomic) CGFloat interval;

/*!
 @method initWithImagesArray:
 @brief 实例初始化方法
 
 @param imagesArray 图片数据
 
 @since      v1.3.0
 */
- (instancetype)initWithImagesArray:(NSArray *)imagesArray;

/*!
 @method composeGif
 @brief 将视频帧／图片数组合成为 Gif 动图，合成结果的回调见 completionBlock，failureBlock
 
 @since      v1.3.0
 */
- (void)composeGif;

/*!
 @method cancelComposeGif
 @brief 取消合成 Gif 动图
 
 @since      v1.4.0
 */
- (void)cancelComposeGif;

/*!
 @method loadGifWithFrame:superView:repeatCount:
 @brief UIImageView 加载 Gif 图
 
 @param frame UIImageView的frame
 @param superView UIImageView的父视图
 @param repeatCount gif播放重复次数，0 为无限循环

 @since      v1.3.0
 */
- (void)loadGifWithFrame:(CGRect)frame superView:(UIView *)superView repeatCount:(NSInteger)repeatCount;

/*!
 @method getImagesWithVideoURL:startTime:endTime:imageCount:imageSize:completionBlock:
 @brief 从视频中获取多张图片
 
 @param videoURL      原视频的地址
 @param startTime     从视频中获取图片的起始时间点
 @param endTime       从视频中获取图片的结束时间点，如果设置为 0，则将使用视频总时长作为结束时间
 @param imageCount    从视频中获取的图片总数
 @param imageSize     获取图片的宽高
 @param completionBlock 获取图片完成的回调 block. 如果发生错误，错误信息将通过 block 返回
 
 @since      v1.16.0
 */
+ (void)getImagesWithVideoURL:(NSURL * _Nonnull)videoURL
                    startTime:(float)startTime
                      endTime:(float)endTime
                   imageCount:(int)imageCount
                    imageSize:(CGSize)imageSize
              completionBlock:(void (^)(NSError *error, NSArray *images))completionBlock;

/*!
 @method getImagesWithAsset:startTime:endTime:imageCount:imageSize:completionBlock:
 @brief 从视频中获取多张图片
 
 @param asset         视频 AVAsset 对象
 @param startTime     从视频中获取图片的起始时间点
 @param endTime       从视频中获取图片的结束时间点，如果设置为 0，则将使用视频总时长作为结束时间
 @param imageCount    从视频中获取的图片总数
 @param imageSize     获取图片的宽高
 @param completionBlock 获取图片完成的回调 block. 如果发生错误，错误信息将通过 block 返回
 
 @since      v1.16.0
 */
+ (void)getImagesWithAsset:(AVAsset * _Nonnull)asset
                 startTime:(float)startTime
                   endTime:(float)endTime
                imageCount:(int)imageCount
                 imageSize:(CGSize)imageSize
           completionBlock:(void (^)(NSError *error, NSArray *images))completionBlock;

@end
