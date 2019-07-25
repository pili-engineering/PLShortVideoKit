//
//  PLSDrawBar.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/7/24.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSDrawModel.h"

NS_ASSUME_NONNULL_BEGIN
@class PLSDrawBar;
@protocol PLSDrawBarDelegate <NSObject>
- (void)editorDrawViewClear:(PLSDrawBar *)editorDrawView;
- (void)editorDrawViewCancel:(PLSDrawBar *)editorDrawView;
- (void)editorDrawViewDone:(PLSDrawBar *)editorDrawView;
- (void)editorDrawView:(PLSDrawBar *)editorDrawView addDrawModel:(PLSDrawModel *)model;


@end

@interface PLSDrawBar : UIView

@property (nonatomic, weak) id<PLSDrawBarDelegate> delegate;
@property (nonatomic, strong, readonly) NSMutableArray <PLSDrawModel *> *addedStickerModelArray;

- (instancetype)initWithFrame:(CGRect)frame videoDuration:(CMTime)duration;
- (void)deleteDrawModel:(PLSDrawModel *)model;
@end

NS_ASSUME_NONNULL_END
