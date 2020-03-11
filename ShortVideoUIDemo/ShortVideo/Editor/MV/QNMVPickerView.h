//
//  QNMVPickerView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/5/14.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNMVModel.h"

@class QNMVPickerView;
@protocol QNMVPickerViewDelegate <NSObject>

- (void)mvPickerView:(QNMVPickerView *)pickerView didSelectColorDir:(NSString *)colorDir alphaDir:(NSString *)alphaDir;

@end

NS_ASSUME_NONNULL_BEGIN

@interface QNMVPickerView : UIView

@property (nonatomic, weak) id<QNMVPickerViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat minViewHeight;

@end

NS_ASSUME_NONNULL_END
