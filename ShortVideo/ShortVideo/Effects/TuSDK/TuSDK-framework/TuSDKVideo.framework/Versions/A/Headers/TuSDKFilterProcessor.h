//
//  TuSDKFilterProcessor.h
//  TuSDK
//
//  Created by Yanlin Qiu on 26/06/2017.
//  Copyright © 2017 tusdk.com. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKVideoCameraBase.h"
#import "TuSDKMediaEffectCore.h"
#import "TuSDKMediaEffectSync.h"

/**
 * 人脸信息检测结果类型
 */
typedef NS_ENUM(NSUInteger,lsqVideoProcesserFaceDetectionResultType) {
    /** Succeed */
    lsqVideoProcesserFaceDetectionResultTypeFaceDetected,
    /** No face is detected */
    lsqVideoProcesserFaceDetectionResultTypeNoFaceDetected,
};


#pragma mark - TuSDKFilterProcessorDelegate

@class TuSDKFilterProcessor;
/**
 *  视频处理事件委托
 */
@protocol TuSDKFilterProcessorDelegate <NSObject>

@optional

/**
 *  滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param processor 视频处理对象
 *  @param newFilter 新的滤镜对象
 */
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor filterChanged:(TuSDKFilterWrap *)newFilter DEPRECATED_MSG_ATTRIBUTE("Please use TuSDKFilterProcessorMediaEffectDelegate");

@end

/**
 *  人脸检测事件委托
 */
@protocol TuSDKFilterProcessorFaceDetectionDelegate <NSObject>

@optional

/**
 *  人脸检测事件委托 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param processor 视频处理对象
 *  @param type 人脸信息
 *  @param count 检测到的人脸数量
 */
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor faceDetectionResultType:(lsqVideoProcesserFaceDetectionResultType)type faceCount:(NSUInteger)count;

@end

/**
 特效事件委托
 @since 2.2.0
 */
@protocol TuSDKFilterProcessorMediaEffectDelegate <NSObject>

@optional

/**
 一个新的特效正在被应用

 @param processor 视频处理对象
 @param mediaEffectData 应用的特效信息
 @since 2.2.0
 */
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor didApplyingMediaEffect:(id<TuSDKMediaEffect>)mediaEffectData;

/**
 特效数据移除
 
 @param processor 视频处理对象
 @param mediaEffectDatas 被移除的特效列表
 @since 2.2.0
 */
- (void)onVideoProcessor:(TuSDKFilterProcessor *)processor didRemoveMediaEffects:(NSArray<id<TuSDKMediaEffect>> *)mediaEffectDatas;

@end


#pragma mark - TuSDKFilterProcessor

/**
 滤镜引擎，实时处理帧数据，并返回处理的结果
 */
@interface TuSDKFilterProcessor : TuSDKFilterProcessorBase 
{
    @protected
    
//    /**
//     *  输出画面分辨率，默认原始采样尺寸输出。
//     *  如果设置了输出尺寸，则对画面进行等比例缩放，必要时进行裁剪，保证输出尺寸和预设尺寸一致。
//     */
//    CGSize _outputSize;
    
    // 设备当前朝向
    UIDeviceOrientation _deviceOrient;
    // 设备图像方向
    UIImageOrientation _imageOrient;
    // 设备视频方向
    AVCaptureVideoOrientation _videoOrientation;
    // 物理感应器方向所对应的视频transform
    CGAffineTransform _videoInputTransform;
}

/**
 *  初始化
 *
 *  支持： kCVPixelFormatType_420YpCbCr8BiPlanarFullRange | kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange kCVPixelFormatType_32BGRA
 *
 *  @param pixelFormatType          原始采样的pixelFormat Type
 *  @param isOriginalOrientation    传入图像的方向是否为原始朝向，SDK 将依据该属性来调整人脸检测时图片的角度。如果没有对图片进行旋转，则为 YES
 *  @param outputSize                输出尺寸
 *
 *  @return instance
 */
- (instancetype)initWithFormatType:(OSType)pixelFormatType
        isOriginalOrientation:(BOOL)isOriginalOrientation
               videoSize:(CGSize)outputSize;


/**
 *  是否开启动态贴纸 (默认: NO)
 */
@property (nonatomic) BOOL enableLiveSticker;

/**
 * 人脸检测事件委托
 */
@property (nonatomic, weak) id<TuSDKFilterProcessorFaceDetectionDelegate> faceDetectionDelegate;

/**
 * 特效事件委托
 */
@property (nonatomic, weak) id<TuSDKFilterProcessorMediaEffectDelegate> mediaEffectDelegate;


/**
 *  输出 PixelBuffer 格式，可选: lsqFormatTypeBGRA | lsqFormatTypeYUV420F | lsqFormatTypeRawData
 *  默认:lsqFormatTypeBGRA
 */
@property (nonatomic) lsqFrameFormatType outputPixelFormatType;

/**
 *  是否调整输出方向，当 isOriginalOrientation 为 YES 时生效;  YES: 调整输出的buffer方向  NO：输出的buffer方向与输入保持一致
 *  默认:NO
 */
@property (nonatomic, assign) BOOL adjustOutputRotation;

/**
 *  用户界面方向 默认为：UIInterfaceOrientationPortrait
 */
@property(readwrite, nonatomic) UIInterfaceOrientation interfaceOrientation;

/** 特效播放类 */
@property (nonatomic,strong) id<TuSDKMediaEffectSync> mediaEffectsSync;

/** 特效播放类 */
@property (nonatomic,readonly) TuSDKComboFilterWrapChain *filterWrapChain;


/**
 Process a video sample and return result soon
 
 @param sampleBuffer sampleBuffer sampleBuffer Buffer to process
 @return Video PixelBuffer
 */
- (CVPixelBufferRef)syncProcessVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer frameTime:(CMTime)currentTime;

/**
 Process a video sample and return result soon
 
 @param sampleBuffer sampleBuffer sampleBuffer Buffer to process
 @return Video PixelBuffer
 */
- (CVPixelBufferRef)syncProcessVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;

/**
 Process pixelBuffer and return result soon
 
 @param pixelBuffer pixelBuffer
 @return PixelBuffer
 */
- (CVPixelBufferRef)syncProcessPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/**
 Process pixelBuffer and return result soon
 
 @param pixelBuffer pixelBuffer
 @param currentTime frameTime
 @return PixelBuffer
 */
- (CVPixelBufferRef)syncProcessPixelBuffer:(CVPixelBufferRef)pixelBuffer frameTime:(CMTime)currentTime;

/**
 在OpenGL线程中调用，在这里可以进行采集图像的二次处理
 @param texture    纹理ID
 @param size      纹理尺寸
 @return           返回的纹理
 */
- (GLuint)syncProcessTexture:(GLuint)texture textureSize:(CGSize)size;

/**
 将 CVPixelBufferRef 数据从 srcPixelBuffer 复制到 destPixelBuffer
 
 @param srcPixelBuffer 源 CVPixelBufferRef
 @param destPixelBuffer 目标 CVPixelBufferRef
 */
- (void)copyPixelBuffer:(CVPixelBufferRef)srcPixelBuffer dest:(CVPixelBufferRef) destPixelBuffer;

/**
 手动销毁帧数据
 */
- (void)destroyFrameData;

/**
 设置检测框最小倍数 [取值范围: 0.1 < x < 0.5, 默认: 0.2] 值越大性能越高距离越近
 */
- (void)setDetectScale: (CGFloat) scale;
#pragma mark - destory

/**
 *  销毁
 */
- (void)destory;

@end

#pragma mark - 特效管理

/**
 * 特效管理
 */
@interface TuSDKFilterProcessor (MediaEffectManager)

/**
 *  切换滤镜
 *
 *  @param code 滤镜代号
 *
 *  @return 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *)code DEPRECATED_MSG_ATTRIBUTE("Please call addMediaEffect:");

#pragma mark - live sticker

/**
 *  显示一组动态贴纸。当显示一组贴纸时，会清除画布上的其它贴纸
 *
 *  @param groupSticker 动态贴纸对象
 *
 */
- (void)showGroupSticker:(TuSDKPFStickerGroup *)groupSticker DEPRECATED_MSG_ATTRIBUTE("Please call addMediaEffect:");

/**
 *  动态贴纸组是否已在使用
 *
 *  @param groupSticker 动态贴纸组对象
 *  @return 　是否使用
 */
- (BOOL)isGroupStickerUsed:(TuSDKPFStickerGroup *)groupSticker DEPRECATED_MSG_ATTRIBUTE();

/**
 *  清除动态贴纸
 */
- (void)removeAllLiveSticker DEPRECATED_MSG_ATTRIBUTE("Please use removeMediaEffectsWithType:TuSDKMediaEffectDataTypeSticker");

/**
 验证 TuSDKFilterProcessor 当前是否支持该特效类型
 @param mediaEffectType 特效类型
 @return true/false
 @since      v2.2.0
 */
-(BOOL)isSupportedMediaEffectType:(TuSDKMediaEffectDataType)mediaEffectType;

/**
 添加一个多媒体特效。该方法不会自动设置触发时间.
 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 
 @param mediaEffect 特效数据
 @since      v2.2.0
 */
- (BOOL)addMediaEffect:(id<TuSDKMediaEffect>)mediaEffect;

/**
 移除特效数据
 
 @param mediaEffect 特效数据
 @since      v2.2.0
 */
- (void)removeMediaEffect:(id<TuSDKMediaEffect>)mediaEffect;

/**
 移除指定类型的特效信息

 @param effectType 特效类型
 @since      v2.2.0
 */
- (void)removeMediaEffectsWithType:(NSUInteger)effectType;

/**
 移除所有特效数据
 
 @since      v2.2.0
 */
- (void)removeAllMediaEffect;

/**
 获取指定类型的特效信息

 @param effectType 特效数据类型
 @return 特效列表
 @since      v2.2.0
 */
- (NSArray<id<TuSDKMediaEffect>> *)mediaEffectsWithType:(NSUInteger)effectType;

/**
 获取所有特效
 
 @return NSArray<id<TuSDKMediaEffect> *
 @since      v3.0.1
 */
- (NSArray<__kindof id<TuSDKMediaEffect>> *)mediaEffects;


@end
