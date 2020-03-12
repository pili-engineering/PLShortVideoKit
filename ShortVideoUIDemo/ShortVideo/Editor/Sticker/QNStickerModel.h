//
//  QNStickerModel.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/28.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <CoreMedia/CoreMedia.h>

@class QNGIFStickerView, QNDrawView;
@interface QNStickerModel : NSObject


@property (nonatomic, strong, readonly) UIColor *randomColor;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CMTime startPositionTime;
@property (nonatomic, assign) CMTime endPositiontime;


@property (nonatomic, weak) UIView *colorView;
@property (nonatomic, weak) QNGIFStickerView *stickerView;


/********* GIF property ********/
// gif 播放一遍需要的时间
@property (nonatomic, assign) CMTime oneLoopDuration;
@property (nonatomic, strong) NSString *path;

/********* text property ********/
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;

/********* draw property ********/
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;


@end

