//
//  TransitionModelSelectView.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLSTextModel) {
    PLSTextModelBigTitle, // 大标题
    PLSTextModelchapter, // 章节
    PLSTextModelSimple,   // 简约
    PLSTextModelQuote,    // 引用
    PLSTextModelDetail,   // 标题和副标题
    PLSTextModelTail,     // 片尾
};

@interface TextModeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, assign) PLSTextModel model;

@end


@class TransitionModelSelectView;
@protocol TransitionModelSelectViewDelegate
<
NSObject
>

- (void)modelSelectedView:(TransitionModelSelectView *)selectView selectModel:(PLSTextModel)model;

- (void)modelSelectedViewEditButtonAction:(TransitionModelSelectView *)selectView;

- (void)modelSelectedViewSureButtonAction:(TransitionModelSelectView *)selectView;

@end

@interface TransitionModelSelectView : UIView

@property (nonatomic, weak)id<TransitionModelSelectViewDelegate>delegate;

@end
