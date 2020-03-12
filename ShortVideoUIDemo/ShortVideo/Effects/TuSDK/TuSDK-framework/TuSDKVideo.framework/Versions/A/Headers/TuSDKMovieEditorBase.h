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
#import "TuSDKMovieEditorMode.h"
#import "TuSDKMediaTimelineAssetMoviePlayer.h"
#import "TuSDKMediaMovieEditorSaver.h"
#import "TuSDKMediaTimeEffect.h"
#import "TuSDKMediaEffectSync.h"
#import "TuSDKMediaMovieEditor.h"

@protocol TuSDKMovieEditorLoadDelegate;
@protocol TuSDKMovieEditorSaveDelegate;
@protocol TuSDKMovieEditorPlayerDelegate;

/**
 *  视频编辑基类
 */
@interface TuSDKMovieEditorBase : NSObject
                                        <
                                            TuSDKMediaMovieEditor,
                                            TuSDKMediaTimelineAssetMoviePlayerDelegate,
                                            TuSDKMediaMovieEditorSaverDelegate,
                                            TuSDKMediaVideoRender
                                        >


/**
 *  初始化
 *
 *  @param holderView 预览容器
 *  @return 对象实例
 */
- (instancetype _Nonnull )initWithPreview:(UIView *_Nonnull)holderView options:(TuSDKMovieEditorOptions *_Nonnull)options;

/**
 视频编辑配置项
 
 @since v3.2.1
 */
@property (nonatomic,readonly) TuSDKMovieEditorOptions * _Nonnull options;

/**
 预览视图容器
 @since v3.2.1
 */
@property (nonatomic,readonly) UIView * _Nullable holderView;

/**
 输入的资产信息
 @since v1.0.0
 */
@property (nonatomic,readonly) AVAsset * _Nullable inputAsset;

/**
 获取视频信息，视频加载完成后可用
 
 @since      v3.0
 */
@property (nonatomic,readonly)TuSDKMediaAssetInfo * _Nullable inputAssetInfo;


/**
 TuSDKMovieEditor 状态
 
 @since v1.0.0
 */
@property (assign,readonly) lsqMovieEditorStatus status;

/**
 裁剪范围 （开始时间~持续时间）
 
 @since v3.0.1
 */
@property (nonatomic,strong,readonly) TuSDKTimeRange * _Nullable cutTimeRange;

/**
 预览时视频原音音量， 默认 1.0  注：仅在 option 中的 enableSound 为 YES 时有效
 
 @since v1.0.0
 */
@property (nonatomic, assign) CGFloat videoSoundVolume;

#pragma mark - Load/Save

/**
 视频加载事件委托
 
 @since v3.0
 */
@property (nonatomic, weak) id <TuSDKMovieEditorLoadDelegate> _Nullable loadDelegate;

/**
 视频播放器事件委托
 
 @since v3.0
 */
@property (nonatomic, weak) id <TuSDKMovieEditorPlayerDelegate> _Nullable playerDelegate;

/**
 视频保存事件委托
 
 @since v3.0
 */
@property (nonatomic, weak) id <TuSDKMovieEditorSaveDelegate> _Nullable saveDelegate;

/**
 *  通知视频编辑器状态
 *
 *  @param status 状态信息
 */
- (void) notifyMovieEditorStatus:(lsqMovieEditorStatus) status;

/**
 更新预览View

 @param frame 设定的frame
 @since 2.2.0
 */
- (void) updatePreViewFrame:(CGRect)frame;

/**
 更新视频输出比例

 @param outputRatio 输出比例
 @since v3.2.1
 */
- (void) updateOutputRatio:(CGFloat)outputRatio;

@end

/**
 时间轴
 */
#pragma mark - Timeline

@interface TuSDKMovieEditorBase (Timeline)

/**
 将当前回放时间设置为指定的输入时间

 @param inputTime 输入时间
 @sicne v3.0.1
 */
- (void)seekToInputTime:(CMTime)inputTime;

/**
 媒体的真实时长
 
 @since      v3.0
 */
- (CMTime)inputDuration;

/**
 应用特效后的输出总时长
 
 @since v3.0
 */
- (CMTime)outputDuraiton;

/**
 当前已经播放时长

 @return CMTime
 @since v3.0
 */
- (CMTime)outputTimeAtTimeline;

/**
 当前正在播放的切片时间
 
 @return CMTime
 @since v3.0
 */
- (CMTime)outputTimeAtSlice;


@end


#pragma mark -  MediaEffectManager

/**
 * 特效管理
 */
@interface TuSDKMovieEditorBase  (MediaEffectManager) <TuSDKMediaEffectSyncDelegate>

/**
 添加一个多媒体特效。该方法不会自动设置触发时间.
 
 @param mediaEffect 特效数据
 @discussion 如果已有特效和该特效不能同时共存，已有旧特效将被移除.
 @since    v2.0
 */
- (BOOL)addMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除特效数据
 
 @since      v2.1
 
 @param mediaEffect TuSDKMediaEffectData
 */
- (void)removeMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 移除指定类型的特效信息
 
 @since      v2.1
 @param effectType 特效类型
 */
- (void)removeMediaEffectsWithType:(NSUInteger)effectType;

/**
 @since      v2.0
 @discussion 移除所有特效
 */
- (void)removeAllMediaEffect;

/**
 开始编辑并预览特效.
 
 @since      v2.1
 @param mediaEffect TuSDKMediaEffectData
 @discussion  当调用该方法时SDK内部将会设置特效开始时间为当前视频时间。
 */
- (void)applyMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 停止编辑特效.
 
 @since      v2.1
 @param mediaEffect TuSDKMediaEffectData
 @discussion 当调用该方法时SDK内部将会设置特效结束时间为当前视频时间。
 */
- (void)unApplyMediaEffect:(id<TuSDKMediaEffect> _Nonnull)mediaEffect;

/**
 获取指定类型的特效信息
 
 @since      v2.1
 @param effectType 特效数据类型
 @return 特效列表
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)mediaEffectsWithType:(NSUInteger)effectType;

/**
 获取添加的所有特效
 
 @since      v3.4.0
 @return 特效列表
 */
- (NSArray<id<TuSDKMediaEffect>> *_Nonnull)allMediaEffects;

@end

#pragma mark - 时间特效 > 反复/快慢速/倒序

@interface TuSDKMovieEditorBase (TimeEffect)

/**
 添加时间特效.
 目前所有时间特效均互斥同时只能添加一个

 @param timeEffect 时间特效
        TuSDKMediaSpeedTimeEffect / TuSDKMediaRepeatTimeEffect / TuSDKMediaReverseTimeEffect
 
 @since v3.0
 */
- (void)addMediaTimeEffect:(id<TuSDKMediaTimeEffect> _Nonnull)timeEffect;

/**
 获取设置的时间特效信息
 
 @since      v3.0.1
 @return 已添加时间特效列表
 */
- (NSArray<id<TuSDKMediaTimeEffect>> * _Nonnull)mediaTimeEffects;

/**
 清除所有时间特效
 
 @since v3.0
 */
- (void)removeAllMediaTimeEffect;

@end

#pragma mark - Particle Effect

@interface TuSDKMovieEditorBase (ParticleEffect)

/**
 更新粒子特效的发射器位置
 
 @param point 粒子发射器位置  左上角为(0,0)  右下角为(1,1)
 @since      v2.0
 */
- (void)updateParticleEmitPosition:(CGPoint)point;

/**
 更新 下一次添加的 粒子特效材质大小  0~1  注：对当前正在添加或已添加的粒子不生效
 
 @param size 粒子特效材质大小
 @since      v2.0
 */
- (void)updateParticleEmitSize:(CGFloat)size;

/**
 更新 下一次添加的 粒子特效颜色  注：对当前正在添加或已添加的粒子不生效
 
 @param color 粒子特效颜色
 @since      v2.0
 */
- (void)updateParticleEmitColor:(UIColor *_Nonnull)color;

@end



#pragma mark - TuSDKMovieEditorLoadDelegate 

/**
 视频加载加载时间回调
 @since v3.0
 */
@protocol TuSDKMovieEditorLoadDelegate <NSObject>
@required

/**
 加载进度改变事件
 
 @param editor TuSDKMovieEditor
 @param percentage 进度百分比 (0 - 1)
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor loadProgressChanged:(CGFloat)percentage;

/**
 加载状态回调
 
 @param editor TuSDKMovieEditor
 @param status 当前加载状态
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor loadStatusChanged:(lsqMovieEditorStatus)status;

/**
 视频加载完成
 
 @param editor TuSDKMovieEditor
 @param assetInfo 视频信息
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor assetInfoReady:(TuSDKMediaAssetInfo * _Nullable)assetInfo error:(NSError *_Nullable)error;

@end


#pragma mark - TuSDKMovieEditorPlayDelegate 视频播放进度回调

/**
 视频加载加载时间回调
 @since v3.0
 */
@protocol TuSDKMovieEditorPlayerDelegate <NSObject>
@required

/**
 播放进度改变事件
 
 @param editor MovieEditor
 @param percent (0 - 1)
 @param outputTime 导出文件后所在输出时间
 @since      v3.0
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor progressChanged:(CGFloat)percent outputTime:(CMTime)outputTime;

/**
 播放状态改变事件
 
 @param editor MovieEditor
 @param status 当前播放状态
 
 @since      v3.0
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor playerStatusChanged:(lsqMovieEditorStatus)status;

@end


#pragma mark - TuSDKMovieEditorSaveDelegate 视频保存进度回调

/**
 视频加载加载时间回调
 @since v3.0
 */
@protocol TuSDKMovieEditorSaveDelegate <NSObject>

@required

/**
 保存进度改变事件
 
 @param editor TuSDKMovieEditor
 @param percentage 进度百分比 (0 - 1)
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor saveProgressChanged:(CGFloat)percentage;

/**
 视频保存完成
 
 @param editor TuSDKMovieEditor
 @param result 保存结果
 @param error 错误信息
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor saveResult:(TuSDKVideoResult *_Nullable)result error:(NSError *_Nullable)error;

/**
 保存状态改变事件
 
 @param editor MovieEditor
 @param status 当前保存状态
 
 @since      v3.0
 */
- (void)mediaMovieEditor:(TuSDKMovieEditorBase *_Nonnull)editor saveStatusChanged:(lsqMovieEditorStatus)status;

@end
