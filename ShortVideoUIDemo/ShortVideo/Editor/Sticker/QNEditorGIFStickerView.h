//
//  QNEditorGIFStickerView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/28.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNStickerModel.h"


@class QNEditorGIFStickerView;
@protocol QNEditorGIFStickerViewDelegate <NSObject>

- (void)editorGIFStickerViewWillBeginDragging:(QNEditorGIFStickerView *)editorGIFStickerView;
- (void)editorGIFStickerViewWillEndDragging:(QNEditorGIFStickerView *)editorGIFStickerView;
- (void)editorGIFStickerViewDoneButtonClick:(QNEditorGIFStickerView *)editorGIFStickerView;
- (void)editorGIFStickerView:(QNEditorGIFStickerView *)editorGIFStickerView wantEntryEditing:(QNStickerModel *)model;
- (void)editorGIFStickerView:(QNEditorGIFStickerView *)editorGIFStickerView wantSeekPlayerTo:(CMTime)time;
- (void)editorGIFStickerView:(QNEditorGIFStickerView *)editorGIFStickerView addGifSticker:(QNStickerModel *)model;

@end

// 添加 GIF 动图的 UI 操作全部都封装在 QNEditorMusicView 中了
@interface QNEditorGIFStickerView : UIView

@property (nonatomic, weak) id<QNEditorGIFStickerViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat minViewHeight;
@property (nonatomic, strong, readonly) NSMutableArray <QNStickerModel *> *addedStickerModelArray;

- (id)initWithThumbImage:(NSArray<UIImage *>*)thumbArray videoDuration:(CMTime)duration;

- (void)setPlayingTime:(CMTime)currentTime;

- (void)startStickerEditing:(QNStickerModel *)stickerModel;

- (void)endStickerEditing:(QNStickerModel *)stickerModel;

- (void)deleteSticker:(QNStickerModel *)model;

@end


@interface StickerCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
