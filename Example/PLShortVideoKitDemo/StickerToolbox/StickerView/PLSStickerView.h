//
//  PLSStickerView.h
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PLSStickerView;
@protocol PLSStickerViewDelegate <NSObject>

@optional
- (void)stickerViewClose:(PLSStickerView *)stickerView;

@end

/**
 * 贴纸类型
 */
typedef NS_ENUM(NSInteger, StickerType){
    StickerType_SubTitle,     // 文字
    StickerType_Sticker,      // 图片
    StickerType_GIFAnimation, // GIF
};

@interface PLSStickerView : UIImageView

#pragma mark - UI
@property (nonatomic) UIButton *closeBtn;
@property (nonatomic) UIImageView *dragBtn;
@property (nonatomic, assign) id <PLSStickerViewDelegate> delegate;
@property (nonatomic, readonly) NSURL *stickerURL;

#pragma mark -
@property (nonatomic, assign) StickerType type;
// 选中后出现边框
@property (nonatomic, assign, getter=isSelected) BOOL select;

#pragma mark - Functions

// 创建文字贴纸
- (instancetype)initSubTextSticker:(UIImage *)image;

// 创建图片贴纸
- (instancetype)initImageSticker:(NSURL *)imgURL;

// 创建 GIF 贴纸
- (instancetype)initGifSticker:(NSURL *)gifURL;

/**
 根据气泡类型，设置字符显示区域
 （需要用户根据自己的气泡设置显示区域）
 @param name 气泡名称
 */
- (void)calcInputRectWithImgName:(NSString *)name;

- (void)close:(id)sender;

#pragma mark - Reserved

@property (nonatomic, assign) CGFloat oriScale;

@property (nonatomic, assign) CGAffineTransform oriTransform;

@end
