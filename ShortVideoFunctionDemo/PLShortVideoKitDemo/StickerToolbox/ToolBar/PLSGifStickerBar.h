//
//  PLSGifStickerBar.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2019/4/3.
//  Copyright © 2019年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLSStickerBar.h"


@class PLSGifStickerBar;
@protocol PLSGifStickerBarDelegate <NSObject>

- (void)gifStickerBar:(PLSGifStickerBar *)stickerBar didSelectImage:(NSURL *)url;

@end

@interface PLSGifStickerBar : UIView;


@property (nonatomic, weak) id <PLSGifStickerBarDelegate> delegate;


/**
 初始化 指定贴图资源目录
 
 @param frame 位置
 @param resourcePath 资源目录
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame resourcePath:(NSString *)resourcePath;

@end
