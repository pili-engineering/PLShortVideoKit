//
//  QNSelectButtonView.h
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/26.
//  Copyright © 2019 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QNSelectButtonView;
@protocol QNSelectButtonViewDelegate <NSObject>

- (void)buttonView:(QNSelectButtonView *)buttonView didSelectedTitleIndex:(NSInteger)titleIndex;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QNSelectButtonView : UIView

@property (nonatomic, assign) id<QNSelectButtonViewDelegate> rateDelegate;

@property (nonatomic, strong) NSArray *staticTitleArray;
@property (nonatomic, strong) NSArray *scrollTitleArr;

@property (nonatomic, strong) NSMutableArray *totalLabelArray;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) CGFloat space;

- (instancetype)initWithFrame:(CGRect)frame defaultIndex:(NSInteger)defaultIndex;

@end

NS_ASSUME_NONNULL_END
