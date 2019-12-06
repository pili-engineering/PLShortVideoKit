//
//  QNEditorTextStickerView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/5/16.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNStickerModel.h"
#import "QNTextStickerView.h"


@class QNEditorTextStickerView;
@protocol QNEditorTextStickerViewDelegate <NSObject>

- (void)editorTextStickerViewWillBeginDragging:(QNEditorTextStickerView *)editorTextStickerView;
- (void)editorTextStickerViewWillEndDragging:(QNEditorTextStickerView *)editorTextStickerView;
- (void)editorTextStickerViewDoneButtonClick:(QNEditorTextStickerView *)editorTextStickerView;
- (void)editorTextStickerView:(QNEditorTextStickerView *)editorTextStickerView wantEntryEditing:(QNStickerModel *)model;
- (void)editorTextStickerView:(QNEditorTextStickerView *)editorTextStickerView wantSeekPlayerTo:(CMTime)time;
- (void)editorTextStickerView:(QNEditorTextStickerView *)editorTextStickerView addTextSticker:(QNStickerModel *)model;

@end

@interface QNEditorTextStickerView : UIView

@property (nonatomic, weak) id<QNEditorTextStickerViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat minViewHeight;
@property (nonatomic, strong, readonly) NSMutableArray <QNStickerModel *> *addedStickerModelArray;

- (id)initWithThumbImage:(NSArray<UIImage *>*)thumbArray videoDuration:(CMTime)duration;

- (void)setPlayingTime:(CMTime)currentTime;

- (void)startStickerEditing:(QNStickerModel *)stickerModel;

- (void)endStickerEditing:(QNStickerModel *)stickerModel;

- (void)deleteSticker:(QNStickerModel *)model;

@end
