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
/**
 *  视频编辑器事件委托
 */
@protocol TuSDKMovieEditorDelegate <NSObject>

/**
 *  视频处理完成
 *
 *  @param editor 编辑器
 *  @param result TuSDKVideoResult对象
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor result:(TuSDKVideoResult *)result;

/**
 *  视频处理出错
 *
 *  @param editor 编辑器
 *  @param error  错误对象
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor failedWithError:(NSError*)error;

@optional

/**
 *  视频处理进度通知
 *
 *  @param editor   编辑器
 *  @param progress 进度 (0~1)
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor progress:(CGFloat)progress;

/**
 *  滤镜改变 (如需操作UI线程， 请检查当前线程是否为主线程)
 *
 *  @param editor    编辑器
 *  @param newFilter 新的滤镜对象
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor filterChanged:(TuSDKFilterWrap *)newFilter;

/**
 *  TuSDKMovieEditor 状态改变
 *
 *  @param editor TuSDKMovieEditor
 *  @param status 状态信息
 */
- (void)onMovieEditor:(TuSDKMovieEditor *)editor statusChanged:(lsqMovieEditorStatus) status;


@end


#pragma mark - TuSDKMovieEditor

/**
 *  视频编辑
 */
@interface TuSDKMovieEditor : TuSDKMovieEditorBase

/**
 *  编辑器事件委托
 */
@property (nonatomic, weak) id<TuSDKMovieEditorDelegate> delegate;

/**
 *  初始化
 *
 *  @param holderView 预览容器
 *  @return 对象实例
 */
- (instancetype)initWithPreview:(UIView *)holderView options:(TuSDKMovieEditorOptions *) options;


@end
