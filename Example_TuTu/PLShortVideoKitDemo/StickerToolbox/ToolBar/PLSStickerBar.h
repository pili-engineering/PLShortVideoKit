//
//  PLSStickerBar.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

#define isiPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/** 贴图资源路径 */
#define kStickersPath @"sticker.bundle"
#define bundleStickerImageNamed(name) [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@", kStickersPath, name]]


@class PLSStickerBar;
@protocol PLSStickerBarDelegate <NSObject>

- (void)stickerBar:(PLSStickerBar *)stickerBar didSelectImage:(NSURL *)url;

@end

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

