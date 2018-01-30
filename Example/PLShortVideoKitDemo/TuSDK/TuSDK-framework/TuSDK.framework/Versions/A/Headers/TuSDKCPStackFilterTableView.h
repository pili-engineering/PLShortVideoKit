//
//  TuSDKCPStackFilterTableView.h
//  TuSDK
//
//  Created by Jimmy Zhao on 16/9/22.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import "TuSDKICTableView.h"
#import "TuSDKCPGroupFilterItemCellBase.h"

@protocol TuSDKCPStackFilterTableViewInterface;
/**
 *  滤镜分组列表行视图委托
 */
@protocol TuSDKCPStackFilterTableViewDelegate <NSObject>
/**
 *  选中一个行视图
 *
 *  @param tableView 滤镜分组列表
 *  @param cell      滤镜分组元素视图
 *  @param mode      滤镜分组元素
 *  @param indexPath 索引
 *
 *  @return BOOL 是否允许选中
 */
- (BOOL)onTuSDKCPGroupFilterTableView:(UIView<TuSDKCPStackFilterTableViewInterface> *)tableView
                         selectedCell:(UITableViewCell<TuSDKCPGroupFilterItemCellInterface> *)cell
                                model:(TuSDKCPGroupFilterItem *)mode
                            indexPath:(NSIndexPath *)indexPath;
@end
#pragma mark - TuSDKCPStackFilterTableViewInterface
/**
 *  滤镜分组列表接口
 */
@protocol TuSDKCPStackFilterTableViewInterface <NSObject>
/**
 *  滤镜分组列表行视图委托
 */
@property (nonatomic, weak) id<TuSDKCPStackFilterTableViewDelegate> delegate;

/**
 *  滤镜分组元素类型
 */
@property (nonatomic)lsqGroupFilterAction action;

/**
 *  滤镜分组元素视图类 (默认:TuSDKCPGroupFilterItemCell, 需要继承 UITableViewCell<TuSDKCPGroupFilterItemCellInterface>)
 */
@property (nonatomic, strong) Class cellViewClazz;

/**
 *  滤镜分组元素视图类 (默认:TuSDKCPGroupFilterGroupCellBase, 需要继承 UITableViewCell<TuSDKCPGroupFilterItemCellInterface>)
 */
@property (nonatomic, strong) Class stackViewClazz;

/**
 *  行视图宽度
 */
@property (nonatomic)CGFloat cellWidth;

/**
 *  折叠视图宽度
 */
@property (nonatomic)CGFloat stackViewWidth;

/**
 *  当前选中的分区 （ —1 表示没有选中任何分区）
 */
@property (nonatomic)NSInteger selectedSection;

/**
 *  数据列表
 */
@property (nonatomic, retain) NSArray *modeList;

/**
 * 选中的滤镜
 */

@property (nonatomic, retain) TuSDKFilterOption *lasOpt;
/**
 *  选中的单元格数据列表
 */
@property (nonatomic, retain) NSArray<TuSDKFilterOption *> *cellItemDatas;

/**
 *  是否允许选择列表
 */
@property (nonatomic) BOOL allowsSelection;

/**
 *  是否显示第一次选择后的图标
 */
@property (nonatomic) BOOL displaySelectionIcon;

/**
 *  滤镜分组视图委托
 */
@property (nonatomic, weak) id<TuSDKCPGroupFilterGroupCellDelegate> groupDelegate;

/**
 *  滤镜任务
 */
@property (nonatomic, assign) id<TuSDKTKFiltersTaskInterface> filterTask;

/**
 *  选中索引
 *
 *  @param position 索引
 *  @param toCenter 是否滚动到中心位置
 *  @param reload   是否刷新数据
 */
- (void)selectPostion:(NSUInteger)position scrollToCenter:(BOOL)toCenter reload:(BOOL)reload;

/**
 *  刷新数据
 */
- (void)reloadData;

- (NSIndexPath *)indexPathForSelectedRow;
- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)deleteRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation;
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;
@end

#pragma mark - TuSDKCPStackFilterTableView
/**
 *  滤镜分组列表
 */
@interface TuSDKCPStackFilterTableView : UIView<UITableViewDataSource, UITableViewDelegate, TuSDKCPStackFilterTableViewInterface>
/**
 *  滤镜分组元素类型
 */
@property (nonatomic)lsqGroupFilterAction action;

/**
 *  滤镜分组元素视图类 (默认:TuSDKCPGroupFilterItemCellBase, 需要继承 UITableViewCell<TuSDKCPGroupFilterItemCellInterface>)
 */
@property (nonatomic, strong) Class cellViewClazz;

/**
 *  滤镜列表区头视图类 (默认:TuSDKCPGroupFilterGroupCellBase, 需要继承 UITableViewCell<TuSDKCPGroupFilterItemCellInterface>)
 */
@property (nonatomic, strong) Class stackViewClazz;

/**
 *  滤镜分组列表行视图委托
 */
@property (nonatomic, weak) id<TuSDKCPStackFilterTableViewDelegate> delegate;

/**
 *  行视图宽度
 */
@property (nonatomic)CGFloat cellWidth;

/**
 *  表头视图宽度
 */
@property (nonatomic)CGFloat stackViewWidth;

/**
 *  当前选中的分区 （ —1 表示没有选中任何分区）
 */
@property (nonatomic)NSInteger selectedSection;

/**
 *  数据列表
 */
@property (nonatomic, retain) NSArray *modeList;

/**
 * 选中的滤镜
 */
@property (nonatomic, retain) TuSDKFilterOption *lasOpt;

/**
 *  选中的单元格数据列表
 */
@property (nonatomic, retain) NSArray<TuSDKFilterOption *> *cellItemDatas;

/**
 *  列表视图
 */
@property (nonatomic, readonly)TuSDKICTableView *tableView;

/**
 *  是否允许选择列表
 */
@property (nonatomic) BOOL allowsSelection;

/**
 *  是否显示第一次选择后的图标
 */
@property (nonatomic) BOOL displaySelectionIcon;

/**
 *  滤镜分组视图委托
 */
@property (nonatomic, weak) id<TuSDKCPGroupFilterGroupCellDelegate> groupDelegate;

/**
 *  滤镜任务
 */
@property (nonatomic, assign) id<TuSDKTKFiltersTaskInterface> filterTask;

@end
