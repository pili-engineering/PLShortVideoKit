//
//  PLSColumnListView.h
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/11/27.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 @abstract 列表视图类型
 */
typedef NS_ENUM(NSUInteger, PLSListViewType) {
    PLSNormalType,
    PLSTableHeaderType,
    PLSTableFooterType,
    PLSHeaderFooterType,
};

@class PLSColumnListView;
@protocol PLSColumnListViewDelegate <NSObject>

@optional
/**
 @abstract 点击列表的元素获取元素信息的回调
 */
- (void)columnListView:(PLSColumnListView *)columnListView didClickListIndex:(NSInteger)index;

@end
@interface PLSColumnListView : UITableView
@property (nonatomic, assign) id<PLSColumnListViewDelegate> listDelegate;
// tableHeaderView 仅在 PLSListViewType 为 PLSHeaderTableViewType 状态下有效


- (id)initWithFrame:(CGRect)frame listArray:(NSArray *)listArray titleArray:(NSArray *)titleArray listType:(PLSListViewType)listType;
- (void)updateListViewWithListArray:(NSArray *)listArray titleArray:(NSArray *)titleArray;

@end


// tableViewCell
@interface PLSTableListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *iconPromptLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)configLabelName:(NSString *)labelName image:(UIImage *)image width:(CGFloat)width;
@end
