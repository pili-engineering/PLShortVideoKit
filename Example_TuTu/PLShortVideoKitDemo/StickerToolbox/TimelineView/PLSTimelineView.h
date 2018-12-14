//
//  PLSTimelineView.h
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PLSTimelineMediaInfo.h"
#import "PLSTimeLineItem.h"
#import "PLSTimeLineAudioItem.h"

@class PLSTimelineView;

@protocol PLSTimelineViewDelegate <NSObject>

/**
 回调拖动的item对象（在手势结束时发生）
 
 @param item timeline对象
 */
- (void)timelineDraggingTimelineItem:(PLSTimeLineItem *)item;

/**
 回调timeline开始被手动滑动
 */
- (void)timelineBeginDragging;

- (void)timelineDraggingAtTime:(CGFloat)time;

- (void)timelineEndDraggingAndDecelerate:(CGFloat)time;

- (void)timelineCurrentTime:(CGFloat)time duration:(CGFloat)duration;

@end

@interface PLSTimelineView : UIView

@property (nonatomic, weak)   id<PLSTimelineViewDelegate> delegate;
@property (nonatomic, copy)   NSString *leftPinchImageName;
@property (nonatomic, copy)   NSString *rightPinchImageName;
@property (nonatomic, copy)   NSString *pinchBgImageName;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *pinchBgColor;
@property (nonatomic, assign) CGFloat actualDuration;

/**
 装载数据，用来显示
 
 @param urls 视频地址
 @param segment 段长（指的是一个屏幕宽度的视频时长  单位：s）
 @param photos 一个段长上需要显示的图片个数 默认为8
 */
- (void)setupVideoUrls:(NSArray *)urls segment:(CGFloat)segment photosPersegent:(NSInteger)photos;

/**
 装载数据，用来显示
 
 @param clips 媒体片段
 @param segment 段长（指的是一个屏幕宽度的视频时长  单位：s）
 @param photos 一个段长上需要显示的图片个数 默认为8
 */
- (void)setMediaClips:(NSArray<PLSTimelineMediaInfo *> *)clips segment:(CGFloat)segment photosPersegent:(NSInteger)photos;

/**
 获取当前时间指针所指向的时间
 
 @return 时间
 */
- (CGFloat)getCurrentTime;

/**
 视频播放过程中，传入当前播放的时间，导航条进行相应的展示
 
 @param time 当前播放时间
 */
- (void)seekToTime:(CGFloat)time;

/**
 取消当前控件行为 例如：在滑动时，调用此方法则不再滑动
 */
- (void)cancel;

#pragma mark - 添加文字、图片信息的增删改查
/**
 添加显示元素 （例如加动图后，需要构建timelineItem对象，并且传入用来显示）
 
 @param timelineItem 显示元素
 */
- (void)addTimelineItem:(PLSTimeLineItem *)timelineItem;

/**
 删除显示元素
 
 @param timelineItem 显示元素
 */
- (void)removeTimelineItem:(PLSTimeLineItem *)timelineItem;

/**
 传入Timeline进入编辑
 
 @param timelineItem timelineItem
 */
- (void)editTimelineItem:(PLSTimeLineItem *)timelineItem;

/**
 timelineView编辑完成
 */
- (void)editTimelineComplete;

/**
 从vid获取PLSTimelineItem对象
 
 @param obj obj
 @return PLSTimeLineItem
 */
- (PLSTimeLineItem *)getTimelineItemWithOjb:(id)obj;

/**
 更新透明度
 
 @param alpha 透明度
 */
- (void)updateTimelineViewAlpha:(CGFloat)alpha;

/**
 获取所有已添加到时间线上的 item
 
 @return PLSTimeLineItem array
 */
- (NSMutableArray <PLSTimeLineItem *>*)getAllAddedItems;

#pragma mark - 添加音效信息的增删改查

/**
 添加元素
 
 @param audioItem 音效元素
 */
//- (void)addTimeLineAudioItem:(PLSTimeLineAudioItem *)audioItem;

/**
 更新进度
 
 @param audioItem 音效元素
 */
- (void)updateTimelineAudioItem:(PLSTimeLineAudioItem *)audioItem;

/**
 删除音效元素
 
 @param audioItem 音效元素
 */
- (void)removeTimeLineAudioItem:(PLSTimeLineAudioItem *)audioItem;

/**
 删除最后一个音效元素
 */
- (void)removeLastAudioItemFromTimeline;

/**
 获取所有已添加到时间线上的 audioItem
 
 @return PLSTimeLineAudioItem array
 */
- (NSMutableArray <PLSTimeLineAudioItem *>*)getAllAddedAudioItems;

@end

