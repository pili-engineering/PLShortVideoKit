//
//  PLSVideoEditingController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/11/17.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSVideoEditingController.h"
#import "PLSToolBarCommon.h"
#import "PLSEditToolbar.h"
#import "PLSStickerBar.h"
#import "PLSTextBar.h"
#import "UIView+PLSLightFrame.h"

@interface PLSVideoEditingController () <PLSEditToolbarDelegate, PLSStickerBarDelegate, PLSTextBarDelegate, PLSPhotoEditDelegate>
{
    UIButton *_progressHUD;
    UIView *_HUDContainer;
    UIActivityIndicatorView *_HUDIndicatorView;
    UILabel *_HUDLabel;
    
    UIView *_edit_naviBar;
    /** 底部栏菜单 */
    PLSEditToolbar *_edit_toolBar;
    
    /** 贴图菜单 */
    PLSStickerBar *_edit_sticker_toolBar;
    
    /** 单击手势 */
    UITapGestureRecognizer *singleTapRecognizer;
}

/** 默认编辑屏幕方向 */
@property (nonatomic, assign) UIInterfaceOrientation orientation;

/** 隐藏控件 */
@property (nonatomic, assign) BOOL isHideNaviBar;

@end

@implementation PLSVideoEditingController

- (instancetype)init {
    return [self initWithOrientation:UIInterfaceOrientationPortrait];
}

- (instancetype)initWithOrientation:(UIInterfaceOrientation)orientation {
    self = [super init];
    if (self) {
        _orientation = orientation;
        
        _oKButtonTitleColorNormal = [UIColor colorWithRed:(26/255.0) green:(173/255.0) blue:(25/255.0) alpha:1.0];
        _cancelButtonTitleColorNormal = [UIColor colorWithWhite:0.8f alpha:1.f];
        _isHiddenStatusBar = YES;
        _oKButtonTitle = @"完成";
        _cancelButtonTitle = @"取消";
        _processHintStr = @"正在处理...";
        
        _operationType = PLSVideoEditOperationType_All;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configEditingView];
    [self configCustomNaviBar];
    [self configBottomToolBar];
}

#pragma mark - private
- (void)showProgressHUDText:(NSString *)text isTop:(BOOL)isTop {
    [self hideProgressHUD];
    
    if (!_progressHUD) {
        _progressHUD = [UIButton buttonWithType:UIButtonTypeCustom];
        [_progressHUD setBackgroundColor:[UIColor clearColor]];
        _progressHUD.frame = [UIScreen mainScreen].bounds;
        
        _HUDContainer = [[UIView alloc] init];
        _HUDContainer.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width - 120) / 2, ([[UIScreen mainScreen] bounds].size.height - 90) / 2, 120, 90);
        _HUDContainer.layer.cornerRadius = 8;
        _HUDContainer.clipsToBounds = YES;
        _HUDContainer.backgroundColor = [UIColor darkGrayColor];
        _HUDContainer.alpha = 0.7;
        
        _HUDIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _HUDIndicatorView.frame = CGRectMake(45, 15, 30, 30);
        
        _HUDLabel = [[UILabel alloc] init];
        _HUDLabel.frame = CGRectMake(0,40, 120, 50);
        _HUDLabel.textAlignment = NSTextAlignmentCenter;
        _HUDLabel.font = [UIFont systemFontOfSize:15];
        _HUDLabel.textColor = [UIColor whiteColor];
        
        [_HUDContainer addSubview:_HUDLabel];
        [_HUDContainer addSubview:_HUDIndicatorView];
        [_progressHUD addSubview:_HUDContainer];
    }
    
    _HUDLabel.text = text ? text : self.processHintStr;
    
    [_HUDIndicatorView startAnimating];
    UIView *view = isTop ? [[UIApplication sharedApplication] keyWindow] : self.view;
    [view addSubview:_progressHUD];
}

- (void)showProgressHUDText:(NSString *)text {
    [self showProgressHUDText:text isTop:NO];
}

- (void)showProgressHUD {
    [self showProgressHUDText:nil];
}

- (void)hideProgressHUD {
    if (_progressHUD) {
        [_HUDIndicatorView stopAnimating];
        [_progressHUD removeFromSuperview];
    }
}

#pragma mark -- 编辑
- (void)setVideoURL:(NSURL *)url timeRange:(CMTimeRange)timeRange placeholderImage:(UIImage *)image; {
    _asset = [AVURLAsset assetWithURL:url];
    _placeholderImage = image;
    _timeRange = timeRange;
    [self setVideoAsset:_asset timeRange:timeRange placeholderImage:image];
}

- (void)setVideoAsset:(AVAsset *)asset timeRange:(CMTimeRange)timeRange placeholderImage:(UIImage *)image {
    _asset = asset;
    _placeholderImage = image;
    _timeRange = timeRange;
    [_editingView setVideoAsset:asset timeRange:timeRange  placeholderImage:image];
}

#pragma mark - 创建视图
- (void)configEditingView {
    _editingView = [[PLSVideoEditingView alloc] initWithFrame:self.view.bounds];
    _editingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _editingView.editDelegate = self;
    _editingView.videoLayerOrientation = self.videoLayerOrientation;
    if (_videoEdit) {
        _editingView.photoEditData = _videoEdit.editData;
        [self setVideoAsset:_videoEdit.editAsset timeRange:_timeRange placeholderImage:_videoEdit.editPreviewImage];
    } else {
        [self setVideoAsset:_asset timeRange:_timeRange placeholderImage:_placeholderImage];
    }
    
    /** 单击的 Recognizer */
    singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singlePressed)];
    /** 点击的次数 */
    singleTapRecognizer.numberOfTapsRequired = 1; // 单击
    /** 给view添加一个手势监测 */
    [self.view addGestureRecognizer:singleTapRecognizer];
    
    [self.view addSubview:_editingView];
}

- (void)configCustomNaviBar {
    CGFloat margin = 5, topbarHeight = kCustomTopbarHeight;
    CGFloat buttonHeight = topbarHeight;
    
    _edit_naviBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, topbarHeight)];
    _edit_naviBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    _edit_naviBar.backgroundColor = [UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:0.7];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    CGFloat editCancelWidth = [self.cancelButtonTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width + margin*4;
    UIButton *_edit_cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, editCancelWidth, buttonHeight)];
    _edit_cancelButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_edit_cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    _edit_cancelButton.titleLabel.font = font;
    [_edit_cancelButton setTitleColor:self.cancelButtonTitleColorNormal forState:UIControlStateNormal];
    [_edit_cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat editOkWidth = [self.oKButtonTitle boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.width + margin*4;
    
    UIButton *_edit_finishButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - editOkWidth, 0, editOkWidth, buttonHeight)];
    _edit_finishButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [_edit_finishButton setTitle:self.oKButtonTitle forState:UIControlStateNormal];
    _edit_finishButton.titleLabel.font = font;
    [_edit_finishButton setTitleColor:self.oKButtonTitleColorNormal forState:UIControlStateNormal];
    [_edit_finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [_edit_naviBar addSubview:_edit_finishButton];
    [_edit_naviBar addSubview:_edit_cancelButton];
    
    [self.view addSubview:_edit_naviBar];
}

- (void)configBottomToolBar {
    PLSEditToolbarType toolbarType = 0;
    if (self.operationType&PLSVideoEditOperationType_draw) {
        toolbarType |= PLSEditToolbarType_draw;
    }
    if (self.operationType&PLSVideoEditOperationType_sticker) {
        toolbarType |= PLSEditToolbarType_sticker;
    }
    if (self.operationType&PLSVideoEditOperationType_text) {
        toolbarType |= PLSEditToolbarType_text;
    }
    
    _edit_toolBar = [[PLSEditToolbar alloc] initWithType:toolbarType];
    _edit_toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _edit_toolBar.delegate = self;
    [_edit_toolBar setDrawSliderColorAtIndex:1]; /** 红色 */
    /** 绘画颜色一致 */
    [_editingView setDrawColor:[_edit_toolBar drawSliderCurrentColor]];
    [self.view addSubview:_edit_toolBar];
}

#pragma mark - 顶部栏(action)
- (void)singlePressed {
    _isHideNaviBar = !_isHideNaviBar;
    [self changedBarState];
}

- (void)cancelButtonClick {
    if ([self.delegate respondsToSelector:@selector(VideoEditingController:didCancelPhotoEdit:)]) {
        [self.delegate VideoEditingController:self didCancelPhotoEdit:self.videoEdit];
    }
}

- (void)finishButtonClick {
    [self showProgressHUD];
    /** 取消贴图激活 */
    [_editingView stickerDeactivated];
    
    /** 处理编辑图片 */
    __block PLSVideoEdit *videoEdit = nil;
    NSDictionary *data = [_editingView photoEditData];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_editingView exportAsynchronouslyWithTrimVideo:^(NSURL *trimURL, NSError *error) {
                    videoEdit = [[PLSVideoEdit alloc] initWithEditAsset:weakSelf.asset editFinalURL:trimURL data:data];
                    if (error) {
                        [[[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil] show];
                    }
                    if ([weakSelf.delegate respondsToSelector:@selector(VideoEditingController:didFinishPhotoEdit:)]) {
                        [weakSelf.delegate VideoEditingController:weakSelf didFinishPhotoEdit:videoEdit];
                    }
                    [weakSelf hideProgressHUD];
                }];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf.delegate respondsToSelector:@selector(VideoEditingController:didFinishPhotoEdit:)]) {
                    [weakSelf.delegate VideoEditingController:weakSelf didFinishPhotoEdit:videoEdit];
                }
                [weakSelf hideProgressHUD];
            });
        }
    });
}

#pragma mark - PLSEditToolbarDelegate 底部栏(action)
/** 一级菜单点击事件 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar mainDidSelectAtIndex:(NSUInteger)index {
    /** 取消贴图激活 */
    [_editingView stickerDeactivated];
    
    switch (index) {
        case PLSEditToolbarType_draw:
        {
            /** 打开绘画 */
            _editingView.drawEnable = !_editingView.drawEnable;
        }
            break;
        case PLSEditToolbarType_sticker:
        {
            [self singlePressed];
            [self changeStickerMenu:YES];
        }
            break;
        case PLSEditToolbarType_text:
        {
            [self showTextBarController:nil];
        }
            break;
        default:
            break;
    }
}

/** 二级菜单点击事件-撤销 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar subDidRevokeAtIndex:(NSUInteger)index {
    switch (index) {
        case PLSEditToolbarType_draw:
        {
            [_editingView drawUndo];
        }
            break;
        case PLSEditToolbarType_sticker:
            break;
        case PLSEditToolbarType_text:
            break;
        default:
            break;
    }
}

/** 二级菜单点击事件-按钮 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar subDidSelectAtIndex:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case PLSEditToolbarType_draw:
            break;
        case PLSEditToolbarType_sticker:
            break;
        case PLSEditToolbarType_text:
            break;
        default:
            break;
    }
}

/** 撤销允许权限获取 */
- (BOOL)editToolbar:(PLSEditToolbar *)editToolbar canRevokeAtIndex:(NSUInteger)index {
    BOOL canUndo = NO;
    switch (index) {
        case PLSEditToolbarType_draw:
        {
            canUndo = [_editingView drawCanUndo];
        }
            break;
        case PLSEditToolbarType_sticker:
            break;
        case PLSEditToolbarType_text:
            break;
        default:
            break;
    }
    
    return canUndo;
}

/** 二级菜单滑动事件-绘画 */
- (void)editToolbar:(PLSEditToolbar *)editToolbar drawColorDidChange:(UIColor *)color {
    [_editingView setDrawColor:color];
}

#pragma mark - PLSStickerBarDelegate
- (void)stickerBar:(PLSStickerBar *)stickerBar didSelectImage:(UIImage *)image {
    if (image) {
        [_editingView createStickerImage:image];
    }
    [self singlePressed];
}

#pragma mark - PLSTextBarDelegate
/** 完成回调 */
- (void)textBarController:(PLSTextBar *)textBar didFinishText:(PLSText *)text {
    if (text) {
        /** 判断是否更改文字 */
        if (textBar.showText) {
            [_editingView changeSelectStickerText:text];
        } else {
            [_editingView createStickerText:text];
        }
    } else {
        if (textBar.showText) { /** 文本被清除，删除贴图 */
            [_editingView removeSelectStickerView];
        }
    }
    [self textBarControllerDidCancel:textBar];
}
/** 取消回调 */
- (void)textBarControllerDidCancel:(PLSTextBar *)textBar {
    /** 显示顶部栏 */
    _isHideNaviBar = NO;
    [self changedBarState];
    /** 更改文字情况才重新激活贴图 */
    if (textBar.showText) {
        [_editingView activeSelectStickerView];
    }
    [textBar resignFirstResponder];
    
    [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        textBar.y = self.view.height;
    } completion:^(BOOL finished) {
        [textBar removeFromSuperview];
    }];
}

#pragma mark - PLSPhotoEditDelegate
#pragma mark - PLSPhotoEditDrawDelegate
/** 开始绘画 */
- (void)photoEditDrawBegan {
    _isHideNaviBar = YES;
    [self changedBarState];
}

/** 结束绘画 */
- (void)photoEditDrawEnded {
    /** 撤销生效 */
    if (_editingView.drawCanUndo) [_edit_toolBar setRevokeAtIndex:PLSEditToolbarType_draw];
    
    _isHideNaviBar = NO;
    [self changedBarState];
}

#pragma mark - PLSPhotoEditStickerDelegate
/** 点击贴图 isActive=YES 选中的情况下点击 */
- (void)photoEditStickerDidSelectViewIsActive:(BOOL)isActive {
    _isHideNaviBar = NO;
    [self changedBarState];
    if (isActive) { /** 选中的情况下点击 */
        PLSText *text = [_editingView getSelectStickerText];
        if (text) {
            [self showTextBarController:text];
        }
    }
}

#pragma mark - private
- (void)changedBarState {
    /** 隐藏贴图菜单 */
    [self changeStickerMenu:NO];
    
    [UIView animateWithDuration:.25f animations:^{
        CGFloat alpha = _isHideNaviBar ? 0.f : 1.f;
        _edit_naviBar.alpha = alpha;
        _edit_toolBar.alpha = alpha;
    }];
}

- (void)changeStickerMenu:(BOOL)isChanged {
    if (isChanged) {
        [self.view addSubview:self.edit_sticker_toolBar];
        CGRect frame = self.edit_sticker_toolBar.frame;
        frame.origin.y = self.view.height-frame.size.height;
        [UIView animateWithDuration:.25f animations:^{
            self.edit_sticker_toolBar.frame = frame;
        }];
    } else {
        if (_edit_sticker_toolBar.superview == nil) return;
        
        CGRect frame = self.edit_sticker_toolBar.frame;
        frame.origin.y = self.view.height;
        [UIView animateWithDuration:.25f animations:^{
            self.edit_sticker_toolBar.frame = frame;
        } completion:^(BOOL finished) {
            [_edit_sticker_toolBar removeFromSuperview];
            _edit_sticker_toolBar = nil;
        }];
    }
}

- (void)showTextBarController:(PLSText *)text {
    PLSTextBar *textBar = [[PLSTextBar alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, self.view.height) layout:^(PLSTextBar *textBar) {
        textBar.oKButtonTitleColorNormal = self.oKButtonTitleColorNormal;
        textBar.cancelButtonTitleColorNormal = self.cancelButtonTitleColorNormal;
        textBar.oKButtonTitle = self.oKButtonTitle;
        textBar.cancelButtonTitle = self.cancelButtonTitle;
        textBar.customTopbarHeight = kCustomTopbarHeight;
    }];
    textBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    textBar.showText = text;
    textBar.delegate = self;
    
    [self.view addSubview:textBar];
    
    [textBar becomeFirstResponder];
    [UIView animateWithDuration:0.25f animations:^{
        textBar.y = 0;
    } completion:^(BOOL finished) {
        /** 隐藏顶部栏 */
        _isHideNaviBar = YES;
        [self changedBarState];
    }];
}

#pragma mark - 贴图菜单（懒加载）
- (PLSStickerBar *)edit_sticker_toolBar {
    if (_edit_sticker_toolBar == nil) {
        CGFloat w=self.view.width, h=175.f;
        _edit_sticker_toolBar = [[PLSStickerBar alloc] initWithFrame:CGRectMake(0, self.view.height, w, h) resourcePath:self.stickerPath];
        _edit_sticker_toolBar.delegate = self;
    }
    return _edit_sticker_toolBar;
}

#pragma mark - 状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.isHiddenStatusBar;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask mask = UIInterfaceOrientationMaskPortrait;
    switch (self.orientation) {
        case UIInterfaceOrientationLandscapeLeft:
            mask = UIInterfaceOrientationMaskLandscape;
            break;
        case UIInterfaceOrientationLandscapeRight:
            mask = UIInterfaceOrientationMaskLandscape;
            break;
        default:
            break;
    }
    return mask;
}

#pragma mark -- dealloc
- (void)dealloc {
    [self hideProgressHUD];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
