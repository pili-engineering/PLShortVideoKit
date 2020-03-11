//
//  QNEditorDrawStickerView.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/7/18.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNStickerModel.h"
#import "QNDrawView.h"

NS_ASSUME_NONNULL_BEGIN

@class QNEditorDrawStickerView;
@protocol QNEditorDrawStickerViewDelegate <NSObject>
- (void)editorDrawStickerViewClear:(QNEditorDrawStickerView *)editorDrawStickerView;
- (void)editorDrawStickerViewCancel:(QNEditorDrawStickerView *)editorDrawStickerView;
- (void)editorDrawStickerViewDone:(QNEditorDrawStickerView *)editorDrawStickerView;
- (void)editorDrawStickerView:(QNEditorDrawStickerView *)editorDrawStickerView addDrawSticker:(QNStickerModel *)model;

@end

@interface QNEditorDrawStickerView : UIView

@property (nonatomic, weak) id<QNEditorDrawStickerViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat minViewHeight;
@property (nonatomic, strong, readonly) NSMutableArray <QNStickerModel *> *addedStickerModelArray;

- (instancetype)initWithVideoDuration:(CMTime)duration;
- (void)deleteSticker:(QNStickerModel *)model;

@end

NS_ASSUME_NONNULL_END
