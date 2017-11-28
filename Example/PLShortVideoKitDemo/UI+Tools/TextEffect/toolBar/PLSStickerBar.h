//
//  PLSStickerBar.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLSStickerBarDelegate;

@interface PLSStickerBar : UIView;

@property (nonatomic, weak) id <PLSStickerBarDelegate> delegate;


/**
 初始化 指定贴图资源目录

 @param frame 位置
 @param resourcePath 资源目录
 @return self
 */
- (instancetype)initWithFrame:(CGRect)frame resourcePath:(NSString *)resourcePath;

@end

@protocol PLSStickerBarDelegate <NSObject>

- (void)stickerBar:(PLSStickerBar *)stickerBar didSelectImage:(UIImage *)image;

@end
