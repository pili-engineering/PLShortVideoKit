//
//  UIImage+PLSClip.h
//  PLShortVideoKit
//
//  Created by suntongmian on 2017/5/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PLSClip)

/**
 *  裁剪图片
 *
 *  @param orginalRect     原始图片大小
 *  @param clipRect        需要裁剪成的图片大小
 *  @param imageBackBlock  完成裁剪后的回调
 */
- (void)imageOrginalRect:(CGRect)orginalRect clipRect:(CGRect)clipRect completeBlock:(void (^)(UIImage *))imageBackBlock;


+ (UIImage *)scaleImage:(UIImage *)image maxDataSize:(NSUInteger)dataSize;

@end
