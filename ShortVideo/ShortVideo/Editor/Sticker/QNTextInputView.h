//
//  QNTextInputView.h
//  ShortVideo
//
//  Created by hxiongan on 2019/5/16.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <UIKit/UIKit.h>



@class QNTextInputView;
@protocol QNTextInputViewDelegate <NSObject>

- (void)textInputCancelEditing:(QNTextInputView *)textInputView;
- (void)textInputView:(QNTextInputView *)textInputView finishEditingWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font;

@end

@interface QNTextInputView : UIView

@property (nonatomic, weak) id<QNTextInputViewDelegate> delegate;

- (void)setFont:(UIFont *)font textColor:(UIColor *)textColor;

- (void)startEditingWithText:(NSString *)text;

@end


@interface QNColorButton : UIButton

@end
