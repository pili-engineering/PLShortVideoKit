//
//  TuSDKMovieEditor.h
//  TuSDKVideo
//
//  Created by Yanlin Qiu on 19/12/2016.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"
#import "TuSDKMovieEditorBase.h"
#import "TuSDKVideoResult.h"

#pragma mark - TuSDKMovieEditorDelegate

@class TuSDKMovieEditor;
@protocol TuSDKMovieEditorDelegate;
@protocol TuSDKMovieEditorMediaEffectsDelegate;

#pragma mark - TuSDKMovieEditor

/**
 *  视频编辑
 */
@interface TuSDKMovieEditor : TuSDKMovieEditorBase

/**
 *  特效事件委托
 */
@property (nonatomic, weak) id<TuSDKMovieEditorMediaEffectsDelegate> mediaEffectsDelegate;

/**
 *  初始化
 *
 *  @param holderView 预览容器
 *  @return 对象实例
 */
- (instancetype)initWithPreview:(UIView *)holderView options:(TuSDKMovieEditorOptions *) options;


@end

/**
 * 特效事件委托
 */
@protocol TuSDKMovieEditorMediaEffectsDelegate <NSObject>

@optional

/**
 当前正在应用的特效
 
 @param editor TuSDKMovieEditor
 @param mediaEffectData 正在预览特效
 @since 2.2.0
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor didApplyingMediaEffect:(id<TuSDKMediaEffect>)mediaEffectData;

/**
 特效被移除通知
 
 @param editor TuSDKMovieEditor
 @param mediaEffects 被移除的特效列表
 @since      v2.2.0
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor didRemoveMediaEffects:(NSArray<id<TuSDKMediaEffect>> *)mediaEffects;

@end

