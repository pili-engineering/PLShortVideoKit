//
//  TuSDKMovieEditorBase.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 19/12/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKVideoResult.h"
#import "TuSDKMovieEditorOptions.h"
#import "TuSDKMediaEffectData.h"
#import "TuSDKTimeRange.h"
#import "TuSDKMVStickerAudioEffectData.h"
#import "TuSDKMediaSceneEffectData.h"

/**
 *  TuSDKMovieEditor状态
 */
typedef NS_ENUM(NSInteger, lsqMovieEditorStatus)
{
    //  未知
    lsqMovieEditorStatusUnknow,
    // 加载失败
    lsqMovieEditorStatusLoadFailed,
    // 加载完成
    lsqMovieEditorStatusLoaded,
    // 正在播放
    lsqMovieEditorStatusPreviewing,
    // 正在录制
    lsqMovieEditorStatusRecording,
    // 录制完成
    lsqMovieEditorStatusRecordingCompleted,
    // 录制失败
    lsqMovieEditorStatusRecordingFailed,
    // 取消录制
    lsqMovieEditorStatusRecordingCancelled,
    // 预览完成
    lsqMovieEditorStatusPreviewingCompleted,
    // 暂停预览
    lsqMovieEditorStatusPreviewingPause,
};

/**
 *  视频编辑基类
 */
@interface TuSDKMovieEditorBase : NSObject
{
    @protected
    
    // 视频视图
    TuSDKICFilterMovieViewWrap *_cameraView;
}

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) NSURL *inputURL;

/**
 *  输入视频源 URL > Asset
 */
@property (nonatomic) AVAsset *inputAsset;

/**
 *  裁剪范围 （开始时间~持续时间）
 */
@property (nonatomic,strong) TuSDKTimeRange *cutTimeRange;

/**
 *  最小裁剪持续时间
 */
@property (nonatomic, assign) NSUInteger minCutDuration;

/**
 *  最大裁剪持续时间
 */
@property (nonatomic, assign) NSUInteger maxCutDuration;

/**
 *  保存到系统相册 (默认保存, 当设置为NO时, 保存到临时目录)
 */
@property (nonatomic) BOOL saveToAlbum;

/**
 *  保存到系统相册的相册名称
 */
@property (nonatomic, copy) NSString *saveToAlbumName;

/**
 *  视频覆盖区域颜色 (默认：[UIColor blackColor])
 */
@property (nonatomic, retain) UIColor *regionViewColor;

/**
 *  是否正在切换滤镜
 */
@property (nonatomic, readonly) BOOL isFilterChanging;

/**
 *  视频总持续时间
 */
@property(readonly,nonatomic) float duration;

/**
 *  视频实际总时长
 */
@property(readonly,nonatomic) float actualDuration;

/**
 *  TuSDKMovieEditor 状态
 */
@property (readonly,assign) lsqMovieEditorStatus status;

/**
 *  导出视频的文件格式（默认:lsqFileTypeMPEG4）
 */
@property (nonatomic, assign) lsqFileType fileType;

/**
 *  预览时视频原音音量， 默认 1.0  注：仅在 option 中的 enableSound 为 YES 时有效
 */
@property (nonatomic, assign) CGFloat videoSoundVolume;

/**
 *  场景特效设置数组
 */
@property (nonatomic, strong) NSArray<TuSDKMediaSceneEffectData *> *sceneEffects;

#pragma mark - waterMark

/**
 *  设置水印图片，最大边长不宜超过 500
 */
@property (nonatomic, retain) UIImage *waterMarkImage;

/**
 *  水印位置，默认 lsqWaterMarkBottomRight
 */
@property (nonatomic) lsqWaterMarkPosition waterMarkPosition;

#pragma mark - init

/**
 *  初始化
 *
 *  @param holderView 预览容器
 *  @return 对象实例
 */
- (instancetype)initWithPreview:(UIView *)holderView options:(TuSDKMovieEditorOptions *)options;

/**
 *  加载视频，显示第一帧
 */
- (void)loadVideo;

#pragma mark - Preview

/**
 *  启动预览
 */
- (void) startPreview;

/**
 *  停止预览
 */
- (void) stopPreview;

/**
 *  是否正在预览视频
 *
 *  @return true/false
 */
- (BOOL) isPreviewing;

/**
 跳转至某一时间节点

 @param time 当前视频的时间节点(若以设置过裁剪时间段，该时间表示裁剪后时间表示)
 */
- (void) seekToPreviewWithTime:(CMTime)time;

#pragma mark - Record

/**
 *  开始录制视频 将被存储至文件
 */
- (void) startRecording;

/**
 *  取消录制
 */
- (void) cancelRecording;

/**
 *  是否正在录制视频
 *
 *  @return true/false
 */
- (Boolean) isRecording;

/**
 *  通知视频编辑器状态
 *
 *  @param status 状态信息
 */
- (void) notifyMovieEditorStatus:(lsqMovieEditorStatus) status;

/**
 *  通知视频处理进度事件
 *
 *  @param progress 进度 (0 ~1)
 */
- (void)notifyMovieProgress:(CGFloat)progress;

/**
 *  通知视频处理结果
 *
 *  @param result TuSDKVideoResult 对象
 *  @param error  错误信息
 *  
 *  @return
 */
- (void)notifyResult:(TuSDKVideoResult *)result error:(NSError *)error;

#pragma mark - switch filter

/**
 *  切换滤镜
 *
 *  @param code 滤镜代号
 *
 *  @return BOOL 是否成功切换滤镜
 */
- (BOOL)switchFilterWithCode:(NSString *)code;

#pragma mark - media effect

/**
 添加一个特效

 @param effect 特效对象，需使用 TuSDKMediaEffectData 的子类
 */
- (void)addMediaEffect:(TuSDKMediaEffectData *)effect;

/**
 移除所有特效
 */
- (void)removeAllEffect;

#pragma mark - destroy

/**
 *  销毁
 */
- (void)destroy;

@end
