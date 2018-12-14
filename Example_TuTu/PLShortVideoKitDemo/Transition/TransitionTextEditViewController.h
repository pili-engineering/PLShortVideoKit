//
//  TransitionTextEditViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionModelSelectView.h"

@class TransitionTextEditViewController;
@protocol TransitionTextEditViewControllerDelegate
<
NSObject
>

- (void)editViewController:(TransitionTextEditViewController *)editController completeWithModel:(PLSTextModel)model textInfo:(NSDictionary *)textDics;

@end

@interface TransitionTextEditViewController : UITableViewController

@property (nonatomic, weak) id<TransitionTextEditViewControllerDelegate> delegate;

@property (nonatomic, assign) CGFloat scale;

- (id)initWithDic:(NSDictionary *)dics model:(PLSTextModel)model;

@end



@class PropertyPickerView;
@protocol PropertyPickerViewDelegate
<
NSObject
>

- (void)pickerView:(PropertyPickerView *)pickerView disSelectedIndex:(NSInteger)index;

@end

@interface PropertyPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<PropertyPickerViewDelegate>delegate;

@property (nonatomic, strong) UIPickerView *pickerView;

- (id)initWithItem:(NSArray<NSString *> *)item;

- (void)show;
- (void)hide;

@end
