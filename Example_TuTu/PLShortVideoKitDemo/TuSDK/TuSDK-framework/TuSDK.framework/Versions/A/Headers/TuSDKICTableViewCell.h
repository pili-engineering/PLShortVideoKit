//
//  TuSDKICTableViewCell.h
//  TuSDK
//
//  Created by Clear Hu on 14/10/28.
//  Copyright (c) 2014年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  表格行视图
 */
@interface TuSDKICTableViewCell : UITableViewCell
// 初始化
+ (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 *  初始化视图
 */
- (void)lsqInitView;
@end

/**
 *  表格行视图扩展
 */
@interface UITableViewCell(UITableViewCellExtend)
/**
 *  需要重置视图
 */
- (void)viewNeedRest;

/**
 *  视图需要显示 (当动态计算CELL高度完成时调用)
 */
- (void)viewNeedShowed;
@end
