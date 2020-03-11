//
//  QNEditorMusicView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/22.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CoreMedia.h>
#import "QNMusicModel.h"
#import "QNMusicPickerView.h"

@class QNEditorMusicView;
@protocol QNEditorMusicViewDelegate <NSObject>

- (void)editorMusicViewWillBeginDragging:(QNEditorMusicView *)musicView;
- (void)editorMusicViewWillEndDragging:(QNEditorMusicView *)musicView;
- (void)editorMusicViewWillShowPickerMusicView:(QNEditorMusicView *)musicView;
- (void)editorMusicViewWillHidePickerMusicView:(QNEditorMusicView *)musicView;
- (void)editorMusicViewDoneButtonClick:(QNEditorMusicView *)musicView;
- (void)editorMusicView:(QNEditorMusicView *)musciView wantSeekPlayerTo:(CMTime)time;
- (void)editorMusicView:(QNEditorMusicView *)musciView updateMusicInfo:(NSArray<QNMusicModel *> *)musicModelArray;

@end

// 添加音乐的 UI 操作全部都封装在 QNEditorMusicView 中了
@interface QNEditorMusicView : UIView

@property (nonatomic, weak) id<QNEditorMusicViewDelegate> delegate;

@property (nonatomic, readonly) CGFloat minViewHeight;
@property (nonatomic, readonly) BOOL musicPickerViewIsShow;
@property (nonatomic, strong, readonly) NSMutableArray <QNMusicModel *> *addedQNMusicModelArray;


- (id)initWithThumbImage:(NSArray<UIImage *>*)thumbArray videoDuration:(CMTime)duration;

- (void)setPlayingTime:(CMTime)currentTime;

- (void)hideMusicPickerView;

@end



@interface MusicAddedCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLabel;

@end
