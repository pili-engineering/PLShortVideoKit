//
//  PLSTextBar.h
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLShortVideoKit/PLShortVideoKit.h"

@protocol PLSTextBarDelegate;

@interface PLSTextBar : UIView

/** 需要显示的文字 */
@property (nonatomic, copy) PLSText *showText;

/** 样式 */
@property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
@property (nonatomic, strong) UIColor *cancelButtonTitleColorNormal;
@property (nonatomic, copy) NSString *oKButtonTitle;
@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, assign) CGFloat customTopbarHeight;

/** 代理 */
@property (nonatomic, weak) id<PLSTextBarDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame layout:(void (^)(PLSTextBar *textBar))layoutBlock;

@end

@protocol PLSTextBarDelegate <NSObject>

/** 完成回调 */
- (void)textBarController:(PLSTextBar *)textBar didFinishText:(PLSText *)text;
/** 取消回调 */
- (void)textBarControllerDidCancel:(PLSTextBar *)textBar;

@end
