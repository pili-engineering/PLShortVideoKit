//
//  TuSDKICTableView.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/28.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  表格视图
 */
@interface TuSDKICTableView : UITableView{
@protected
    /**
     *  缓存标记 (初始化时自动创建: [NSString stringWithFormat:@"%@Cell", [self class]])
     */
    NSString *_cellIdentifier;
}
/**
 *  缓存标记 (初始化时自动创建: [NSString stringWithFormat:@"%@Cell", [self class]])
 */
@property (nonatomic, readonly) NSString *cellIdentifier;

/**
 *  初始化(使用全屏大小)
 *
 *  @return table 表格视图 (默认以屏幕高宽 style = UITableViewStylePlain 初始化)
 */
+ (instancetype)table;

/**
 *  初始化(使用屏幕宽度)
 *
 *  @param height 高度
 *
 *  @return table 表格视图
 */
+ (instancetype)tableWithHeight:(float)height;

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *
 *  @return frame 表格视图 默认以style = UITableViewStylePlain 初始化
 */
+ (instancetype)initWithFrame:(CGRect)frame;

/**
 *  初始化
 *
 *  @param frame 坐标长宽
 *  @param style 表格样式
 *
 *  @return frame 表格视图
 */
+ (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

/**
 *  初始化视图
 */
- (void)lsqInitView;

/**
 *  使用tableHeaderView占位顶部
 *
 *  @param height 头部高度
 */
- (void)setTopHeight:(float)height;

/**
 *  取消默认选中状态
 *
 *  @param enable 是否取消选中
 */
- (void)deselectRow:(BOOL)enable;

/**
 *  取消选中行视图
 */
- (void)deselectRow;

/**
 *  设置行视图选中状态
 *
 *  @param selected  是否选中
 *  @param indexPath 索引
 */
- (void)setCellSelected:(BOOL)selected rowAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  刷新数据，同时记录已选中状态
 */
- (void)reloadDataSaveSelected;
@end
