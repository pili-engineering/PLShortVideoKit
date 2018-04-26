//
//  TuSDKCPImageResultController.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/2.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import "TuSDKCPResultViewController.h"
#import "TuSDKTKThread.h"

/**
 *  图片处理结果视图控制器
 */
@interface TuSDKCPImageResultController : TuSDKCPResultViewController
{
    @protected
    // 是否在下载图片
    BOOL _downloading;
    // 原图是否从服务器获取
    BOOL _downloadedFromServer;
}

/**
 *  输入的临时文件目录 (处理优先级: inputImage > inputTempFilePath > inputAsset)
 */
@property (nonatomic, copy) NSString *inputTempFilePath;

/**
 *  输入的相册图片对象 (处理优先级: inputImage > inputTempFilePath > inputAsset)
 */
@property (nonatomic, retain) id<TuSDKTSAssetInterface> inputAsset;

/**
 *  输入的图片对象 (处理优先级: inputImage > inputTempFilePath > inputAsset)
 */
@property (nonatomic, retain) UIImage *inputImage;

/**
 *  预览图片视图
 */
@property (nonatomic, readonly) UIButton *preview;

/**
 *  是否显示处理结果预览图 (默认：关闭，调试时可以开启)
 */
@property (nonatomic) BOOL showResultPreview;

/**
 *  控制器关闭后是否自动删除临时文件 (默认：NO)
 */
@property (nonatomic) BOOL isAutoRemoveTemp;

/**
 *  加载来源图片
 *
 *  @return image 来源图片
 */
- (UIImage *)loadOrginImage;

/**
 *  获取裁剪图片
 *
 *  @param image            图片对象
 *  @param cutRect          裁剪百分区域
 *  @param imageOrientation 图片方向
 *
 *  @return image 裁剪图片
 */
- (UIImage *)cuterImage:(UIImage *)image
                cutRect:(CGRect)cutRect
       imageOrientation:(UIImageOrientation)imageOrientation;

/**
 *  获取裁剪图片
 *
 *  @param image            图片对象
 *  @param cutRect          裁剪百分区域
 *  @param imageOrientation 图片方向
 *  @param cutRatio         裁切比例 (当CGRectIsEmpty(cutRect) 生效)
 *
 *  @return image 裁剪图片
 */
- (UIImage *)cuterImage:(UIImage *)image
                cutRect:(CGRect)cutRect
       imageOrientation:(UIImageOrientation)imageOrientation
               cutRatio:(CGFloat)cutRatio;

/**
 *  异步加载输入图片
 *
 *  @param block 快速线程开始方法
 */
- (void)asyncLoadInputImageWithBlock:(TuSDKTKThreadStartBlock)block;

/**
 *  异步图片加载完毕
 *
 *  @param image 图片
 */
- (void)onAsyncImageLoaded:(UIImage *)image;

/**
 *  检测图片数据是否可用，如果原图在iCloud上，需要异步下载
 *
 *  @param image 图片
 *  @param block 下载进度回调
 */
- (BOOL)checkImageValid:(UIImage *)image handler:(TuSDKTSAssetProgressBlock)block;

/**
 是否需要预处理图片
 
 @param image 要显示的图片
 @return
 */
- (BOOL)preProcessWithImage:(UIImage *)image;

/**
 图片加载并显示后，是否需要继续处理
 
 @param image 要显示的图片
 */
- (void)postProcessWithImage:(UIImage *)image;

/**
 *  异步加载输入图片完成
 *
 *  @param image 输入图片
 */
- (void)loadedInputImage:(UIImage *)image;

/**
 * 显示测试预览视图
 *
 * @param result
 * @return BOOL 是否显示测试预览视图
 */
- (BOOL)showResultPreview:(TuSDKResult *)result;
@end
