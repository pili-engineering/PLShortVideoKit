//
//  TuSDKMediaMovieFilmEditor.h
//  TuSDKVideo
//
//  Created by ligh  on 9/10/2018.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMediaAssetInfo.h"
#import "TuSDKVideoResult.h"
#import "TuSDKMovieEditorMode.h"
#import "TuSDKMediaMovieFilmEditorOptions.h"
#import "TuSDKMediaPacketEffect.h"
#import "TuSDKMediaEffectTimeline.h"
#import "TuSDKMediaMovieEditor.h"

@protocol TuSDKMediaMovieFilmEditorSaveDelegate;
@protocol TuSDKMediaMovieFilmEditorPlayerDelegate;

/**
 视频剪辑器.
 可将多个视频素材进行合成拼接，并可以添加大片特效，富有感染力的音频特效等.
 
 @since v3.0.1
 */
@interface TuSDKMediaMovieFilmEditor : NSObject <TuSDKMediaMovieEditor>


/**
 初始化 TuSDKMediaMontageMovieEditor

 @param preView 预览视图
 @param inputAssets 输入视频源
 @param options 指定编辑器初始化配置
 @return TuSDKMediaMontageMovieEditor
 
 @since v3.0.1

 */
- (instancetype _Nonnull )initWithPreview:(UIView *_Nonnull)preView assets:(NSArray<AVAsset *> *_Nonnull)inputAssets options:(TuSDKMediaMovieFilmEditorOptions *_Nonnull)options;

/**
 输入的资产列表
 
 @since v3.0.1
 */
@property (nonatomic,readonly) NSArray<AVAsset *> *_Nullable inputAssets;

/**
 状态信息
 
 @since v3.0.1
 */
@property (assign,readonly) lsqMovieEditorStatus status;

/**
 指定导出时长 默认：15s
 
 @since v3.0.1
 */
@property (nonatomic) CMTime exportDuration;

/**
 指定输出画幅比例，默认：0 SDK自动计算最佳输出比例
 
 @since v3.0.1
 */
@property (nonatomic) CGFloat outputRatio;


#pragma mark - Play/Save Delegate

/**
 视频播放器事件委托
 
 @since v3.0.1
 */
@property (nonatomic, weak) id <TuSDKMediaMovieFilmEditorPlayerDelegate> _Nullable playerDelegate;

/**
 视频保存事件委托
 
 @since v3.0.1
 */
@property (nonatomic, weak) id <TuSDKMediaMovieFilmEditorSaveDelegate> _Nullable saveDelegate;

/**
 更新预览View

 @param frame 设定的frame
 
 @since v3.0.1
 */
- (void) updatePreViewFrame:(CGRect)frame;


@end

/**
 添加特效
 
 @since v3.0.1
 */
@interface TuSDKMediaMovieFilmEditor  (MediaEffect)

/**
 添加特效

 @param mediaEffect 特效信息
 @return true/false
 
 @since v3.0.1
 */
- (BOOL)addMediaPacketEffect:(id<TuSDKMediaPacketEffect> _Nonnull)mediaEffect;

/**
 移除特效

 @param mediaEffect 特效信息
 
 @since v3.0.1
 */
- (void)removeMediaPacketEffect:(id<TuSDKMediaPacketEffect> _Nonnull)mediaEffect;


/**
 移除特效
 @since v3.0.1
 */
- (void)removeAllMediaPacketEffect;

@end

/**
 时间轴
 */
#pragma mark - Timeline

@interface TuSDKMediaMovieFilmEditor (Timeline)

/**
 输入的资产文件总总时长
 
 @since v3.0.1
 */
- (CMTime)inputDuration;

/**
 应用特效后的输出总时长
 
 @since v3.0.1
 */
- (CMTime)outputDuraiton;

/**
 当前已经播放时长

 @return CMTime
 
 @since v3.0.1
 */
- (CMTime)outputTime;

@end


#pragma mark - TuSDKMediaMovieFilmEditorPlayerDelegate 视频播放进度回调

/**
 视频加载加载时间回调
 
 @since v3.0.1
 */
@protocol TuSDKMediaMovieFilmEditorPlayerDelegate <NSObject>
@required

/**
 播放进度改变事件
 
 @param editor MovieEditor
 @param percent (0 - 1)
 @param outputTime 导出文件后所在输出时间
 
 @since v3.0.1
 */
- (void)mediaMovieFilmEditor:(TuSDKMediaMovieFilmEditor *_Nonnull)editor progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 播放进度改变事件
 
 @param editor MovieEditor
 @param status 当前播放状态
 
 @since v3.0.1
 */
- (void)mediaMovieFilmEditor:(TuSDKMediaMovieFilmEditor *_Nonnull)editor playerStatusChanged:(lsqMovieEditorStatus)status;

@end


#pragma mark - TuSDKMediaMovieFilmEditorSaveDelegate 视频保存进度回调

/**
 视频加载加载时间回调
 
 @since v3.0.1
 */
@protocol TuSDKMediaMovieFilmEditorSaveDelegate <NSObject>

@required

/**
 保存进度改变事件
 
 @param editor TuSDKMovieEditor
 @param percentage 进度百分比 (0 - 1)
 
 @since v3.0.1
 */
- (void)mediaMovieFilmEditor:(TuSDKMediaMovieFilmEditor *_Nonnull)editor saveProgressChanged:(CGFloat)percentage;

/**
 视频保存完成
 
 @param editor TuSDKMovieEditor
 @param result 保存结果
 @param error 错误信息
 
 @since v3.0.1
 */
- (void)mediaMovieFilmEditor:(TuSDKMediaMovieFilmEditor *_Nonnull)editor saveResult:(TuSDKVideoResult *_Nullable)result error:(NSError *_Nullable)error;

/**
 保存状态改变事件
 
 @param editor MovieEditor
 @param status 当前保存状态
 
 @since v3.0.1
 */
- (void)mediaMovieFilmEditor:(TuSDKMediaMovieFilmEditor *_Nonnull)editor saveStatusChanged:(lsqMovieEditorStatus)status;

@end
