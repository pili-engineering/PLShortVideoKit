//
//  TuSDKPFPaintBezierPath.h
//  TuSDKGeeV1
//
//  Created by tutu on 2019/4/22.
//  Copyright © 2019 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/**
 自定义bezier类
 @since v3.1.0
 */
@interface TuSDKPFPaintBezierPath : UIBezierPath

/**
 *  曲线颜色
 *  @since v3.1.0
 */
@property (nonatomic, strong) UIColor *color;

/**
 *  是否撤销
 *  @since v3.1.0
 */
@property (nonatomic, assign) BOOL isUndo;


/**
 *  points---曲线上面所有的点
 *  @since v3.1.0
 */
@property (nonatomic, strong) NSArray *points;


/**
 插值法让曲线更加平滑

 @since v3.1.0
 @param granularity 插入的值得个数
 @return 新的曲线
 */
- (TuSDKPFPaintBezierPath *)smoothedPath:(int)granularity;

@end

NS_ASSUME_NONNULL_END
