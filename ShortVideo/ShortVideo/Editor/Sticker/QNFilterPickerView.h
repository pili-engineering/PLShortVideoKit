//
//  QNFilterPickerView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/19.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QNFilterGroup;
@class QNFilterPickerView;
@protocol QNFilterPickerViewDelegate <NSObject>

- (void)filterView:(QNFilterPickerView *)filterView didSelectedFilter:(NSString *)colorImagePath;

@end


NS_ASSUME_NONNULL_BEGIN

@interface QNFilterPickerView : UIView

@property (nonatomic, weak) id<QNFilterPickerViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat minViewHeight;
@property (nonatomic, strong, readonly) QNFilterGroup *filterGroup;

- (instancetype)initWithFrame:(CGRect)frame hasTitle:(BOOL)hasTitle;

- (void)updateSelectFilterIndex;

@end

NS_ASSUME_NONNULL_END
