//
//  TuSDKPFSimpleProcessor.h
//  TuSDK
//
//  Created by Yanlin on 12/2/15.
//  Copyright © 2015 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TuSDKPFBrush.h"
#import "TuSDKTSScreen+Extend.h"

#ifndef lsqSmudgProcessor_Define
#define lsqSmudgProcessor_Define

#define lsq_PIXEL_PER_POINT     [UIScreen scale]

#define lsq_BYTES_PER_PIXEL     4
#define lsq_BITS_PER_COMPONENT 8

#define lsq_TILE_SIZE 30

#define lsq_rgbaDataIndex(width, x, y)    ((width) * (y) + (x)) * lsq_BYTES_PER_PIXEL

#endif

/**
 *  涂抹功能处理基类
 */
@interface TuSDKPFSimpleProcessor : NSObject
{
    @protected
    
    // 涂抹的画布
    CGContextRef _smudgeContext;
    
    // 笔刷的画布，用来给笔刷染色
    CGContextRef _brushContext;
    
    // 导入图片
    UIImage *_originalImage;
    
    int _imageDataSize;
    
    // 导入图片的RGBA数据，用来取色
    unsigned char *_originalData;
    
    // 导入图片的信息
    int _imageWidth;
    
    int _imageHeight;
    
    TuSDKPFBrush *_currentBrush;
    
    // 笔刷图片
    UIImage *_brushImage;
    
    // 笔刷尺寸
    CGFloat _brushSize;
    
    // 实际绘制时的笔刷缩放系数
    CGFloat _brushScale;
}

/**
 *  当前笔刷
 */
@property (nonatomic, retain) TuSDKPFBrush *currentBrush;

/**
 *  笔刷粗细
 */
@property (nonatomic) CGFloat brushSize;

/**
 *  默认撤销的最大次数 (默认: 5)
 */
@property (nonatomic, assign) NSUInteger maxUndoCount;

/**
 *  该图所在的imageView的 size，用来计算对应到图片上的相对位置
 */
@property (nonatomic, assign) CGSize  originIVSize;


/**
 *  设置绘制底图
 *
 *  @return scaledImage
 */
-(void)setImage: (UIImage *)scaledImage;

/**
 *  保存当前画面进入绘制历史
 */
- (void)saveCurrentAsHistory;

/**
 *  重做上一条操作，并返回预览图像
 *  @return image 重做操作后的画布图像
 */
- (UIImage *)getRedoData;

/**
 *  撤销上一步操作，并返回预览图像
 *
 *  @return image 撤销操作后的画布图像
 */
- (UIImage *)getUndoData;

/**
 * 允许重做的次数
 */
- (NSUInteger)getRedoCount;

/**
 * 允许撤销的次数
 */
- (NSUInteger)getUndoCount;

#pragma mark - image function

// 生成画布
- (CGContextRef)createBitmapContextWithSizeOfImage: (UIImage*)image drawImage:(BOOL)draw;

// 生成画布
- (CGContextRef)createBitmapContextWithWidth: (int)width andHeight: (int)height;

#pragma mark - draw at touch position

/**
 *  开始绘制
 */
- (void)touchesBegan;

/**
 *  在触摸点绘制
 *
 *  @param currentTouchPoint  当前触点
 *  @param previousTouchPoint 上一个触点
 *
 *  @return image 预览图
 */
- (UIImage *)drawAtCurrentPoint: (CGPoint)currentTouchPoint
                           from: (CGPoint)previousTouchPoint;


/**
 *  获取绘制图层的图片
 */
- (UIImage *)getSmudgeImage;

/**
 *  获取预览图
 *
 *  @param includeSmudge 是否包含涂抹效果
 *
 *  @return image 图片
 */
- (UIImage *)getPreviewImage:(BOOL)includeSmudge;

/**
 *  销毁数据
 */
- (void)destroy;
/**
 *  销毁历史记录
 */
- (void)destroyHistory;
@end
