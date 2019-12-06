//
//  QNRecordingProgress.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/9.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    QNProgressStyleNormal,
    QNProgressStyleDelete,
} QNProgressStyle;


@interface QNRecordingProgress : UIView

- (void)setLastProgressToStyle:(QNProgressStyle)style;
- (void)setLastProgressToWidth:(CGFloat)width;

- (void)deleteLastProgress;
- (void)deleteAllProgress;
- (void)addProgressView;

- (void)stopShining;
- (void)startShining;

@end

NS_ASSUME_NONNULL_END
