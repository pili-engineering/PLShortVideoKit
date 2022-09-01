//
//  UIView+QNAlert.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "UIView+QNAlert.h"

@implementation UIView (Alert)

#define loadingTag 999999
#define fullLoadingTag 888888
#define errorViewTag 666666
#define tipTag 47298749


- (JGProgressHUD *)prototypeHUD {
    JGProgressHUD *oldHUD = (JGProgressHUD *)[self viewWithTag:tipTag];
    if (oldHUD) {
        [oldHUD dismissAnimated:NO];
    }
    JGProgressHUD *HUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    HUD.interactionType = JGProgressHUDInteractionTypeBlockAllTouches;
    JGProgressHUDFadeZoomAnimation *an = [JGProgressHUDFadeZoomAnimation animation];
    HUD.animation = an;
    HUD.delegate = self;
    HUD.square = NO;
    HUD.tag=tipTag;
    return HUD;
}

- (JGProgressHUD *)loadingHUD {
    JGProgressHUD *oldHUD = (JGProgressHUD *)[self viewWithTag:loadingTag];
    if (oldHUD) {
        [oldHUD dismissAnimated:NO];
    }
    JGProgressHUD *HUD=[self prototypeHUD];
    HUD.square = NO;
    HUD.tag = loadingTag;
    return HUD;
}

#pragma mark--Loading

//! 加载{图片}
- (void)showImageLoadingWithTip:(NSString *)tip image:(NSString *)imageName {
    JGProgressHUD *HUD = [self loadingHUD];
    HUD.textLabel.text = tip;
    HUD.textLabel.font = [UIFont systemFontOfSize:14];
    [HUD showInView:self];
}

//! 加载{默认加载}
- (void)showNormalLoadingWithTip:(NSString *)tip {
    [self showImageLoadingWithTip:tip image:nil];
}

- (void)showLoadingHUD {
    [self showNormalLoadingWithTip:@""];
}

//! 可取消加载{文字+默认加载}
- (void)showNormalLongLoadingWithTip:(NSString *)tip cancelTip:(NSString *)cancelTip {
    JGProgressHUD *HUD = [self loadingHUD];
    HUD.textLabel.text = tip;
    HUD.textLabel.font = [UIFont systemFontOfSize:14];
    
    __block BOOL confirmationAsked = NO;
    
    HUD.tapOnHUDViewBlock = ^(JGProgressHUD *h) {
        if (confirmationAsked) {
            [h dismiss];
        } else {
            h.indicatorView = [[JGProgressHUDErrorIndicatorView alloc] init];
            h.textLabel.text = cancelTip;
            confirmationAsked = YES;
            
            CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
            an.fromValue = @(0.0f);
            an.toValue = @(0.5f);
            
            an.repeatCount = HUGE_VALF;
            an.autoreverses = YES;
            
            an.duration = 0.75f;
            
            h.HUDView.layer.shadowColor = QN_MAIN_COLOR.CGColor;
            h.HUDView.layer.shadowOffset = CGSizeZero;
            h.HUDView.layer.shadowOpacity = 0.0f;
            h.HUDView.layer.shadowRadius = 8.0f;
            
            [h.HUDView.layer addAnimation:an forKey:@"glow"];
            
            __weak __typeof(h) wH = h;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (wH && confirmationAsked) {
                    confirmationAsked = NO;
                    __strong __typeof(wH) sH = wH;
                    
                    sH.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] init];
                    sH.textLabel.text = tip;
                    [h.HUDView.layer removeAnimationForKey:@"glow"];
                }
            });
        }
    };
    
    HUD.tapOutsideBlock = ^(JGProgressHUD *h) {
        if (confirmationAsked) {
            confirmationAsked = NO;
            h.indicatorView = [[JGProgressHUDIndeterminateIndicatorView alloc] init];
            h.textLabel.text = tip;
            [h.HUDView.layer removeAnimationForKey:@"glow"];
        }
    };
    [HUD showInView:self];
}

//! 进度加载
- (void)showProgressLoadingWithTip:(NSString *)tip {
}

//! 加载成功（+文字）
- (void)showSuccessTip:(NSString *)tip {
    tip = [@"😆\n\n" stringByAppendingString:tip];
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.position = JGProgressHUDPositionCenter;
    HUD.indicatorView = nil;
    HUD.textLabel.text = tip;
    HUD.textLabel.font = [UIFont systemFontOfSize:14];
    [HUD showInView:self];
    [HUD dismissAfterDelay:2.0];
}

//! 加载失败（+文字）
- (void)showFailTip:(NSString *)tip {
    tip = [@"😂\n\n" stringByAppendingString:tip];
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.position = JGProgressHUDPositionCenter;
    HUD.indicatorView = nil;
    HUD.textLabel.text = tip;
    HUD.textLabel.font = [UIFont systemFontOfSize:14];
    [HUD showInView:self];
    [HUD dismissAfterDelay:2.0];
}

//! 隐藏加载
- (void)hiddenLoading {
    JGProgressHUD *hud = (JGProgressHUD *)[self viewWithTag:loadingTag];
    [hud dismiss];
}

- (void)hideLoadingHUD {
    [self hiddenLoading];
}

#pragma mark--Alert

//! 警告（标题+副标题+默认图片）
- (void)showWarningTip:(NSString *)title message:(NSString *)message {
    [self showImageTip:title message:message image:@"failure"];
}

//! 警告（文字+默认图片）
- (void)showWarningTip:(NSString *)tip {
    [self showWarningTip:tip message:nil];
}

//! 提示（只文字）
- (void)showTip:(NSString *)tip {
    [self showTip:tip position:JGProgressHUDPositionCenter];
}

//! 提示（只文字+位置）
- (void)showTip:(NSString *)tip position:(JGProgressHUDPosition)position {
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.position = position;
    HUD.indicatorView = nil;
    HUD.textLabel.text = tip;
    HUD.textLabel.font = [UIFont systemFontOfSize:14];
    [HUD showInView:self];
    [HUD dismissAfterDelay:2.0];
}

//! 提示（文字+图片）
- (void)showImageTip:(NSString *)tip image:(NSString *)imageName {
    [self showImageTip:tip message:nil image:imageName];
}

//! 提示（文字+副标题+图片）
- (void)showImageTip:(NSString *)tip message:(NSString *)message image:(NSString *)imageName {
    UIImageView *imageView= [[UIImageView alloc] init];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = QN_MAIN_COLOR;
    JGProgressHUD *HUD = [self prototypeHUD];
    HUD.indicatorView = [[JGProgressHUDIndicatorView alloc] initWithContentView:imageView];
    HUD.textLabel.text = tip;
    HUD.textLabel.font = [UIFont systemFontOfSize:14];
    HUD.detailTextLabel.text = message;
    [HUD showInView:self];
    [HUD dismissAfterDelay:2.0];
}

- (void)showFullLoading {
    [self showFullLoadingWithTip:@""];
}

- (void)showFullLoadingWithTip:(NSString *)tip {
    UIView *loadingView = [self viewWithTag:fullLoadingTag];
    if (loadingView) {
//        [loadingView removeFromSuperview];
//        loadingView = nil;
        return;
    }
    loadingView = [[UIView alloc] initWithFrame:self.bounds];
    loadingView.tag = fullLoadingTag;
    [self addSubview:loadingView];
    [loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    MMMaterialDesignSpinner *spinner = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    spinner.center = loadingView.center;
    spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    spinner.tintColor = QN_MAIN_COLOR;// [YIMStyleManager blackColor:0.4];
    [loadingView addSubview:spinner];
    [self bringSubviewToFront:loadingView];
    [spinner startAnimating];
    
    if (tip.length) {
     
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 150, 20)];
        loadingLabel.text = tip;
        loadingLabel.textColor= QN_MAIN_COLOR;//[YIMStyleManager blackColor:0.4];
        loadingLabel.textAlignment=NSTextAlignmentCenter;
        loadingLabel.font=[UIFont systemFontOfSize:12];
        loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        [loadingView addSubview:loadingLabel];
        [loadingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(spinner.mas_bottom).mas_offset(40);
            make.leading.trailing.mas_equalTo(loadingView);
            make.height.mas_equalTo(@20);
        }];
    }
}

- (void)hideFullLoading {
    __block UIView *loadingView = [self viewWithTag:fullLoadingTag];
    if (loadingView) {
        [UIView transitionWithView:self duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^(void) {
            [loadingView removeFromSuperview];
        } completion:^(BOOL finished) {
            loadingView = nil;
        }];
    }
}

- (void)showRetryWithTip:(NSString *)tip retryAction:(void (^)(void))block {
    [self showErrorWithTip:tip tipImage:@"bg_error" buttonTitle:NSLocalizedString(@"刷新", "刷新") retryAction:block];
}

- (void)showErrorWithTip:(NSString *)tip tipImage:(NSString *)imageName buttonTitle:(NSString *)title retryAction:(void (^)(void))block {
    [self hideErroMsgView];
    
    UIView *errorView = [UIView new];
    errorView.backgroundColor = [UIColor whiteColor];
    errorView.tag = errorViewTag;
    [self addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    UILabel *tipLabel = [UILabel new];
    tipLabel.text = tip;
    tipLabel.numberOfLines = 0;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15];
    tipLabel.textColor = [self subTitleColor];
    [errorView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(errorView);
        make.left.mas_equalTo(errorView).mas_offset(10);
        make.right.mas_equalTo(errorView).mas_offset(-10);
        make.height.mas_equalTo(30);
    }];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *tipImageView = [UIImageView new];
    tipImageView.image = image;
    [errorView addSubview:tipImageView];
    [tipImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tipLabel.mas_top).mas_equalTo(-30);
        make.centerX.mas_equalTo(errorView);
        make.width.mas_equalTo(image.size.width);
        make.height.mas_equalTo(image.size.height);
    }];
    
    UIButton *retryBtn = [UIButton new];
    [retryBtn setTitle:title forState:UIControlStateNormal];
    [retryBtn setTitleColor:[self subTitleColor] forState:UIControlStateNormal];
    retryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    retryBtn.layer.borderColor = [self subTitleColor].CGColor;
    retryBtn.layer.borderWidth = 1.;
    retryBtn.layer.cornerRadius = 15.;
    [errorView addSubview:retryBtn];
    [retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipLabel.mas_bottom).mas_offset(8);
        make.centerX.mas_equalTo(tipLabel);
        make.size.mas_equalTo(CGSizeMake(120, 30));
    }];
    
    [self bringSubviewToFront:errorView];
}

- (void)hideErroMsgView {
    UIView *errorView = [self viewWithTag:errorViewTag];
    if (errorView) {
        [errorView removeFromSuperview];
        errorView = nil;
    }
}

- (UIColor *)mainColor {
    return [UIColor colorWithRed:0.160 green:0.736 blue:0.727 alpha:1.000];
}

- (UIColor *)titleColor {
    return [UIColor colorWithRed:60./255. green:60./255. blue:60./255. alpha:1.];
}

- (UIColor *)subTitleColor {
    return [UIColor colorWithRed:101./255. green:101./255. blue:101./255. alpha:1.];
}

@end
