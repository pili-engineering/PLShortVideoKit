//
//  KWSDK_UI.m
//  KWKitDemo
//
//  Created by zhaoyichao on 2017/1/22.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import "KWSDK_UI.h"
#import "KWStickerCell.h"
#import "KWDistortionCell.h"
#import "KWFilterCell.h"
#import "KWStickerDownloadManager.h"
#import "KWPresentStickerRenderer.h"
#import "UIDevice+DeviceModel.h"
#import "KWSaveData.h"

static NSString *KWDistortionCellIdentifier = @"KWDistortionCellIdentifier";
static NSString *KWStickerCellIdentifier = @"KWStickerCellIdentifier";
static NSString *KWPresentStickerCollectionViewCellIdentifier = @"KWPresentStickerCollectionViewCellIdentifier";
static NSString *KWFilterCellIdentifier = @"KWFilterCellIdentifier";

@interface KWSDK_UI()<UICollectionViewDelegate,UICollectionViewDataSource>
#pragma mark -- Build the SDK's built-in UI

/**
 Current pop-up view
 */
@property (nonatomic, weak) UIView *currentPopView;

/**
 The view that will pop up
 */
@property (nonatomic, weak) UIView *NextPopView;

/**
 The current pop-up main menu view
 */
@property (nonatomic, strong) UIView *currentMainMenuPopView;

/**
 The main menu to be displayed
 */
@property (nonatomic, strong) UIView *NextMainMenuPopView;

/**
 Front and rear camera switch button
 */
@property (nonatomic, strong) UIButton *toggleBtn;

/**
 Close the video window button
 */
@property (nonatomic, strong) UIButton *closeVideoBtn;

/**
 Whether to hide the front and rear camera switch button
 */
@property (nonatomic, assign) BOOL isHiddenToggleBtn;

/**
 Whether to hide the close videowindow button
 */
@property (nonatomic, assign) BOOL isHiddenCloseVideoBtn;

/**
 Whether to hide the bottom left button
 */
@property (nonatomic, assign) BOOL isHiddenStickerSetBtn;

/**
 Whether to hide the bottom right button
 */
@property (nonatomic, assign) BOOL isHiddenRightBtn;

/**
 center button
 */
@property (nonatomic, strong) UIButton *offPhoneBtn;

/**
 Whether to hide the center button
 */
@property (nonatomic, assign) BOOL isHiddenOffPhoneBtn;

/**
 Open the stickers and other parameters set mirror button
 */
@property (nonatomic, strong) UIButton *openStickerSetBtn;

/**
 Open the filter selection menu button
 */
@property (nonatomic, strong) UIButton *openFilterSetBtn;

/**
 The navigation bar at the bottom of the screen
 */
@property (nonatomic, strong) UIScrollView *mainMenuView;

/**
 Sets the global beauty view
 */
@property (nonatomic, strong) UIView *filterGlobalView;

/**
 Button to open and close the big-eyed face-lift parameter
 */
@property (nonatomic, strong) UIButton *enableFilterParmasBtn;

/**
 Button to turn the new pull bar beauty parameters on and off
 */
@property (nonatomic, strong) UIButton *enableBeautifyFilterParmasBtn;

/**
 View to adjust the local beauty parameters
 */
@property (nonatomic, strong) UIView *beautifyFilterView;

/**
 eye magnifying parameter selection bar
 */
@property (nonatomic, strong) UISlider *sliderEyeMagnifying;

@property (nonatomic, strong) UILabel *labelEyeMagnifying;

/**
 chin slimming parameter selection bar
 */
@property (nonatomic, strong) UISlider *sliderChinSlimming;

@property (nonatomic, strong) UILabel *labelChinSlimming;


/**
 facial whitening parameter selection bar
 */
@property (nonatomic, strong) UISlider *NewBeautifySliderWhitening;

@property (nonatomic, strong) UILabel *NewBeautifyLabelWhitening;


/**
 skin smoothing parameter selection bar
 */
@property (nonatomic, strong) UISlider *NewBeautifySliderMicrodermabrasion;

@property (nonatomic, strong) UILabel *NewBeautifyLabelMicrodermabrasion;


/**
 skin tone saturation parameter selection bar
 */
@property (nonatomic, strong) UISlider *NewBeautifySliderSaturation;

@property (nonatomic, strong) UILabel *NewBeautifyLabelSaturation;


/**
 skin shinning tenderness parameters selection bar
 */
@property (nonatomic, strong) UISlider *NewBeautifySliderPinkistender;

@property (nonatomic, strong) UILabel *NewBeautifyLabelPinkistender;


/**
 New Beauty parameter View
 */
@property (nonatomic, strong) UIView *beautifyNewView;

@property (nonatomic, strong) UIView *presentStickerMenuView;

/**
 Sticker Select view
 */
@property (nonatomic, strong) UIView *stickerMenuView;

/**
 Select distorting mirror view
 */
@property (nonatomic, strong) UIView *distortionMenuView;


@property (nonatomic, strong) UIView *slideBeautifyMenuView;

/* Opens the beauty parameter settings button*/
@property (nonatomic, strong) UIButton *beautifyOptionsBtn;

/* Opens the button for the sticker setting */
@property (nonatomic, strong) UIButton *stickerOptionsBtn;

/**
 Open button distorting mirror set
 */
@property (nonatomic, strong) UIButton *distortionOptionsBtn;

/* Opens the button for the global beauty setting for the bar */
@property (nonatomic, strong) UIButton *slideGlobalBeautifyOptionsBtn;

/* Face trace point button */
@property (nonatomic, strong) UIButton *pointBtn;

//New beauty parameters menu button
@property (nonatomic, strong) UIButton *beautifyNewBtn;

@property (nonatomic, strong) UIButton *presentStickerBtn;


/* Sticker Selects the item collection control */
@property (nonatomic, strong) UICollectionView *stickersCollectionView;

/* Distorting mirror of choice collection of controls */
@property (nonatomic, strong) UICollectionView *distortionCollectionView;

/* Global beauty filter Selects the collection control */
@property (nonatomic, strong) UICollectionView *globalBeatifyFilterCollectionView;

@property (nonatomic, strong) UICollectionView *presentStickerCollectionView;

/* Beauty is turned on */
@property (nonatomic, strong) UILabel *beautifyEnableStateLab;


/* Pull bar beauty turned on */
@property (nonatomic, strong) UILabel *slideBeautifyEnableStateLab;

@property (nonatomic, assign) UIDeviceOrientation oldScreenMode;

/* presentSticker of the button */
@property (nonatomic, strong) UIButton *presentSwitchBtn;

@property (nonatomic, strong) UIButton *smiliesSwitchBtn;

/* Taking photos of the button */
@property (nonatomic, strong) UIButton *takePhotoBtn;

@property (nonatomic, strong) UILabel *smiliesStateText;

@property (nonatomic, strong) UIView *recordCircleView;

@property (nonatomic, strong) UIView *splashView;

@end


@implementation KWSDK_UI
{
    //隐藏菜单的响应View
    UIView *tapView;
    UIButton *btnBeautify1;
    UIButton *btnBeautify2;
    UIButton *btnBeautify3;
    UIButton *btnBeautify4;
}
KWSDK_UI *KWSdkUI;

+ (KWSDK_UI *)shareManagerUI
{
    
    //    static dispatch_once_t predicate;
    //    dispatch_once(&predicate, ^{
    if (KWSdkUI == nil) {
        KWSdkUI = [[KWSDK_UI alloc] init];
    }
    //    });
    return KWSdkUI;
}

- (void)setViewDelegate:(UIViewController *)delegate
{
    if (self) {
        self.actionViewController = delegate;
    }
}


/*
 * 生成内置UI
 */
- (void)initSDKUI
{
    self.oldScreenMode = UIDeviceOrientationUnknown;
    if (self.actionViewController != nil) {
        if (self.isClearOldUI) {
            [self clearAllViewsInController];
        }
        
        if (self.previewView) {
            [self.actionViewController.view addSubview:self.previewView];
        }
        
        tapView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_KW, ScreenHeight_KW)];
        tapView.userInteractionEnabled = YES;
        
        //隐藏状态栏（plist）
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewOnTap)];
        [tapView addGestureRecognizer:recognizer];
        
        [_actionViewController.view addSubview:tapView];
        
        [tapView setHidden:YES];
        
//        [_actionViewController.view addSubview:self.closeVideoBtn];
//        [_actionViewController.view addSubview:self.takePhotoBtn];
//        [_actionViewController.view addSubview:self.toggleBtn];
//        [_actionViewController.view addSubview:self.offPhoneBtn];
        [_actionViewController.view addSubview:self.presentSwitchBtn];

        
        [_actionViewController.view addSubview:self.smiliesSwitchBtn];
        
        [_actionViewController.view addSubview:self.openStickerSetBtn];
        
        
        // 大眼瘦脸
        [_actionViewController.view addSubview:self.beautifyFilterView];
        // 贴纸
        [_actionViewController.view addSubview:self.stickerMenuView];
        // 哈哈镜
        [_actionViewController.view addSubview:self.distortionMenuView];
        
        //  不需要滤镜
//        [_actionViewController.view addSubview:self.openFilterSetBtn];

        // 全局美颜
//        [_actionViewController.view addSubview:self.beautifyNewView];
        
        // 拉条美颜
//        [_actionViewController.view addSubview:self.slideBeautifyMenuView];
        
        // 礼物贴纸
        [_actionViewController.view addSubview:self.presentStickerMenuView];
        
        // global beauty
//        [_actionViewController.view addSubview:self.filterGlobalView];
        
        
        // 主界面菜单
        [_actionViewController.view addSubview:self.mainMenuView];
        
        [_actionViewController.view addSubview:self.smiliesStateText];
        
        [_actionViewController.view addSubview:self.recordCircleView];
        
        NSLog(@"%lf",[[UIScreen mainScreen] bounds].size.width);
        NSLog(@",%lf",[[UIScreen mainScreen] bounds].size.height);
        
        if ([[[UIDevice currentDevice] deviceModel] isEqualToString:@"iPhone 5"]) {
            //低频率捕捉人脸开关
            self.kwSdk.renderer.isLowFrequencyTracker = YES;
        }
        
        //初始化美颜参数
        [self initDefaultParams];
        [self lockFilterBeautifyView:NO];
//        [self lockSlideBeautifyView:NO];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stickersLoadedComplete:) name:@"KW_STICKERSLOADED_COMPLETE" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(colorfiltersLoadedComplete:) name:@"KW_COLORFILTERSLOADED_COMPLETE" object:nil];

    }
}

- (void)stickersLoadedComplete:(NSNotification *)noti
{
    
    [self.stickersCollectionView reloadData];
    [self.stickersCollectionView scrollsToTop];
    
    [self.presentStickerCollectionView reloadData];
    [self.presentStickerCollectionView scrollsToTop];
}

- (void)colorfiltersLoadedComplete:(NSNotification *)noti
{
    [self.globalBeatifyFilterCollectionView reloadData];
    [self.globalBeatifyFilterCollectionView scrollsToTop];
}

- (void)clearAllViewsInController
{
    for (UIView *subView in _actionViewController.view.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)viewOnTap
{
    /* If the current pop-up, then put away*/
    [self popAllView];
}

- (void)popAllView
{
    if (self.currentPopView != nil) {
        [self disableAllMainMenuBtn];
        if ([self.currentPopView isEqual:self.beautifyFilterView]) {
        }
        [self hideMenuSubView: self.currentPopView];
        self.currentPopView = nil;
    }
    
    if (self.currentMainMenuPopView != nil) {
        if ([self.currentMainMenuPopView isEqual:self.mainMenuView]) {
            [self pushmainMenuView:NO];
        }
        else
        {
            [self pushFilterGlobalView:NO];
        }
        //        [self performSelector:@selector(isHavePushed:) withObject:0 afterDelay:0.5];
        [self isHavePushed:NO];
    }
}

/**
 Switch the front and rear camera
 */
- (void)toggleCamera
{
    if (self.toggleBtnBlock != nil) {
        self.toggleBtnBlock();
    }
}

- (void)closeVideoWindow
{
    if (self.closeVideoBtnBlock != nil) {
        self.closeVideoBtnBlock();
    }
}


- (void)isHavePushed:(BOOL) isPushed
{
    if (!isPushed) {
        if (!self.isHiddenOffPhoneBtn) {
            [self.offPhoneBtn setAlpha:0];
        }
        [self.openFilterSetBtn setAlpha:0];
//        [self.openStickerSetBtn setAlpha:0];
        
        if (!self.isHiddenOffPhoneBtn) {
            [self.offPhoneBtn setHidden:isPushed];
        }
        
        [self.openFilterSetBtn setHidden:isPushed];
//        [self.openStickerSetBtn setHidden:isPushed];
        
        [UIView animateWithDuration:0.6 animations:^{
            if (!self.isHiddenOffPhoneBtn) {
                [self.offPhoneBtn setAlpha:1];
            }
            [self.openFilterSetBtn setAlpha:1];
//            [self.openStickerSetBtn setAlpha:1];
        }];
        [tapView setHidden:YES];
    }
    else
    {
        [tapView setHidden:NO];
        [self.offPhoneBtn setHidden:isPushed];
        [self.openFilterSetBtn setHidden:isPushed];
//        [self.openStickerSetBtn setHidden:isPushed];
    }
}


- (void)pushmainMenuView:(BOOL)isPop
{
    [self isHavePushed:YES];
    /* pop up */
    if (isPop) {
        self.currentMainMenuPopView = self.mainMenuView;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.filterGlobalView.frame;
            frame.origin.y = ScreenHeight_KW - 42;
            self.mainMenuView.frame = frame;
            [self stickerOptionsBtnOnClick:self.stickerOptionsBtn];
        }];
    }
    /* Put away */
    else
    {
        self.currentMainMenuPopView = nil;
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.filterGlobalView.frame;
            frame.origin.y = ScreenHeight_KW;
            self.mainMenuView.frame = frame;
        }];
    }
}

- (void)hideMenuSubView:(UIView *)view
{
    CGRect frame = view.frame;
    frame.origin.y = ScreenHeight_KW;
    view.frame = frame;
}


- (void)disableAllMainMenuBtn
{
    [self.beautifyOptionsBtn setSelected:NO];
    [self.stickerOptionsBtn setSelected:NO];
    [self.distortionOptionsBtn setSelected:NO];
    [self.beautifyNewBtn setSelected:NO];
    [self.slideGlobalBeautifyOptionsBtn setSelected:NO];
    [self.presentStickerBtn setSelected:NO];
    [self.pointBtn setSelected:NO];
}

- (void)resetScreemMode
{
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (iDeviceOrientation != self.oldScreenMode) {
        
        
        switch (iDeviceOrientation) {
            case UIDeviceOrientationPortrait:
            case UIDeviceOrientationPortraitUpsideDown:
                self.kwSdk.varWidth = ScreenWidth_KW;
                self.kwSdk.varHeight = ScreenHeight_KW;
                break;
                
            case UIDeviceOrientationLandscapeLeft:
            case UIDeviceOrientationLandscapeRight:
                self.kwSdk.varWidth = ScreenWidth_KW;
                self.kwSdk.varHeight = ScreenHeight_KW;
                break;
            default:
                self.kwSdk.varWidth = ScreenWidth_KW;
                self.kwSdk.varHeight = ScreenHeight_KW;
                break;
        }
        [self.kwSdk resetDistortionParams];
        [self resetSdkUI];
        self.oldScreenMode = iDeviceOrientation;
    }
}

/* Front and rear camera switch button */
- (UIButton *)toggleBtn
{
    if (!_toggleBtn) {
        _toggleBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 60 - 5, 0, 60, 60)];

        [_toggleBtn setImage:[UIImage imageNamed:@"switch"] forState:UIControlStateNormal];
        
//        _toggleBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
        [_toggleBtn addTarget:self action:@selector(toggleBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _toggleBtn;
}


/* Taking photos of the button */
- (UIButton *)takePhotoBtn
{
    if (!_takePhotoBtn) {
        _takePhotoBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 15 - 30, 15, 30, 24)];
        [_takePhotoBtn setImage:[UIImage imageNamed:@"takephoto_sys"] forState:UIControlStateNormal];
        [_takePhotoBtn addTarget:self action:@selector(takePhotoBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takePhotoBtn;
}

- (UIButton *)closeVideoBtn
{
    if (!_closeVideoBtn) {
        _closeVideoBtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 60, 60)];
        
        [_closeVideoBtn setImage:[UIImage imageNamed:@"closeVideo_sys"] forState:UIControlStateNormal];
        
//        [_closeVideoBtn setTitle:@"关闭" forState:UIControlStateNormal];
//        [_closeVideoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_closeVideoBtn.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
//        [_closeVideoBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
        [_closeVideoBtn addTarget:self action:@selector(closeVideoBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeVideoBtn;
}

/* center button */
- (UIButton *)offPhoneBtn
{
    if (!_offPhoneBtn) {
        _offPhoneBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 81) / 2, ScreenHeight_KW - 20 - 81, 81, 81)];
        
//        _offPhoneBtn.layer.cornerRadius = 40.5f;
//        _offPhoneBtn.layer.masksToBounds = YES;
        [_offPhoneBtn setBackgroundImage:[UIImage imageNamed:@"shoot"] forState:UIControlStateNormal];
//        [_offPhoneBtn setImage:[UIImage imageNamed:@"shoot"] forState:UIControlStateNormal];
        
        [_offPhoneBtn setAdjustsImageWhenHighlighted:NO];
        
        [_offPhoneBtn addTarget:self action:@selector(offPhoneBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.5;
        [_offPhoneBtn addGestureRecognizer:longPress];
    }
    return _offPhoneBtn;
}

/* Open the stickers and other parameters set mirror button*/
- (UIButton *)openStickerSetBtn
{
    if (!_openStickerSetBtn) {
        _openStickerSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 61, 180, 46, 46)];
        [_openStickerSetBtn setImage:[UIImage imageNamed:@"mask"] forState:UIControlStateNormal];
        _openStickerSetBtn.layer.cornerRadius = 23;
        _openStickerSetBtn.backgroundColor = [UIColor colorWithRed:116/255 green:116/255 blue:116/255 alpha:0.55];
        
        _openStickerSetBtn.titleLabel.font = [UIFont systemFontOfSize:8];

        CGSize imageSize = _openStickerSetBtn.imageView.frame.size;
        CGSize titleSize = _openStickerSetBtn.titleLabel.frame.size;
        CGFloat totalHeight = imageSize.height + titleSize.height + 3;
        
//        _openStickerSetBtn.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
//        _openStickerSetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);

        [_openStickerSetBtn addTarget:self action:@selector(openStickerSetBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openStickerSetBtn;
}


/* Open the filter selection menu button*/
- (UIButton *)openFilterSetBtn
{
    if (!_openFilterSetBtn) {
        _openFilterSetBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50 - 10, ScreenHeight_KW - 30 - 50, 50, 50)];
        
        [_openFilterSetBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
        
        _openFilterSetBtn.titleLabel.font = [UIFont systemFontOfSize:8];

        CGSize imageSize = _openFilterSetBtn.imageView.frame.size;
        CGSize titleSize = _openFilterSetBtn.titleLabel.frame.size;
        CGFloat totalHeight = imageSize.height + titleSize.height + 3;
        
        _openFilterSetBtn.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
        _openFilterSetBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0.0);
        
        
        [_openFilterSetBtn addTarget:self action:@selector(openFilterSetBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openFilterSetBtn;
}

/* The navigation bar at the bottom of the screen */
- (UIScrollView *)mainMenuView
{
    if (!_mainMenuView) {
        _mainMenuView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW , ScreenWidth_KW, 42)];
        
        [_mainMenuView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.9)];
        
        _mainMenuView.contentSize = CGSizeMake(ScreenWidth_KW / 5, 42);
        
        // 大眼 瘦脸入口
        [_mainMenuView addSubview:self.beautifyOptionsBtn];
        
        [_mainMenuView addSubview:self.stickerOptionsBtn];
        
        [_mainMenuView addSubview:self.distortionOptionsBtn];
        
        // 不使用全局美颜
//        [_mainMenuView addSubview:self.slideGlobalBeautifyOptionsBtn];
        // 不使用点阵
//        [_mainMenuView addSubview:self.pointBtn];
        // 不使用美颜
//        [_mainMenuView addSubview:self.beautifyNewBtn];
        
                [_mainMenuView addSubview:self.presentStickerBtn];
    }
    return _mainMenuView;
}

/* Sets the global beauty view */
- (UIView *)filterGlobalView
{
    if (!_filterGlobalView) {
        _filterGlobalView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 101)];
        [_filterGlobalView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
        [_filterGlobalView addSubview:self.globalBeatifyFilterCollectionView];
        
    }
    return _filterGlobalView;
}

/* Local beauty parameters adjustment */
- (UIView *)beautifyFilterView
{
    if (!_beautifyFilterView) {
        _beautifyFilterView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 175 + 52 + 15 - 90)];
        [_beautifyFilterView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.4)];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth_KW - 120) / 2,  8 , 120, 13)];
        if (IsEnglish) {
            [labTitle setText:@"Eye & Chin"];
        }
        else
        {
            [labTitle setText:@"大眼瘦脸"];
        }
        
        [labTitle setTextColor:[UIColor whiteColor]];
        [labTitle setFont:[UIFont systemFontOfSize:12.f]];
        [labTitle setTextAlignment:NSTextAlignmentCenter];
        [_beautifyFilterView addSubview:labTitle];
        
        [_beautifyFilterView addSubview:self.sliderEyeMagnifying];
        [_beautifyFilterView addSubview:self.sliderChinSlimming];
        
        UILabel *labTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 12 + 3 + 52 + 15, 100, 16)];
        [labTitle1 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle1 setTextColor:[UIColor whiteColor]];
        if (IsEnglish) {
            [labTitle1 setText:@"Eye magnifying"];
        }
        else
        {
            [labTitle1 setText:@"大眼"];
        }
        
        [labTitle1 setTextAlignment:NSTextAlignmentCenter];
        [_beautifyFilterView addSubview:labTitle1];
        
        UILabel *labTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 54 + 3 + 52 + 15, 100, 16)];
        [labTitle2 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle2 setTextColor:[UIColor whiteColor]];
        [labTitle2 setTextAlignment:NSTextAlignmentCenter];
        if (IsEnglish) {
            [labTitle2 setText:@"Chin slimming"];
        }
        else
        {
            [labTitle2 setText:@"瘦脸"];
        }
        
        [_beautifyFilterView addSubview:labTitle2];
        
        self.beautifyEnableStateLab = [[UILabel alloc]initWithFrame:CGRectMake(32, 12 + 3 + 52 - 39 +15, 40, 15)];
        [self.beautifyEnableStateLab setFont:[UIFont systemFontOfSize:15.f]];
        [self.beautifyEnableStateLab setTextColor:[UIColor whiteColor]];
        if (IsEnglish) {
            [self.beautifyEnableStateLab setText:@"On"];
        }
        else
        {
            [self.beautifyEnableStateLab setText:@"开"];
        }
        
        if (!IsEnglish) {
            labTitle1.frame = CGRectMake(0, 12 + 3 + 52 + 15, 125 - 60, 16);
            labTitle2.frame = CGRectMake(0, 54 + 3 + 52 + 15, 125 - 60, 16);
            
            self.sliderEyeMagnifying.frame = CGRectMake(120 - 60, 12 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 -30 + 60 - 20, 20);
            self.sliderChinSlimming.frame = CGRectMake(120 - 60, 54 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 - 30 + 60 - 20, 20);
        }
        
        
        UILabel *eyeLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50, 12 + 3 + 52 + 15, 50, 13)];
        self.labelEyeMagnifying = eyeLabel;
        [eyeLabel setText:[NSString stringWithFormat:@"%d",(int)self.sliderEyeMagnifying.value]];
        [eyeLabel setTextColor:[UIColor whiteColor]];
        [eyeLabel setFont:[UIFont systemFontOfSize:11.f]];
        [eyeLabel setTextAlignment:NSTextAlignmentCenter];
        [_beautifyFilterView addSubview:eyeLabel];
        
        
        UILabel *faceLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50, 54 + 3 + 52 + 15, 50, 13)];
        self.labelChinSlimming = faceLabel;
        [faceLabel setText:[NSString stringWithFormat:@"%d",(int)self.sliderChinSlimming.value]];
        [faceLabel setTextColor:[UIColor whiteColor]];
        [faceLabel setFont:[UIFont systemFontOfSize:11.f]];
        [faceLabel setTextAlignment:NSTextAlignmentCenter];
        [_beautifyFilterView addSubview:faceLabel];
        
        
//        [_beautifyFilterView addSubview:self.beautifyEnableStateLab];
        
        [_beautifyFilterView addSubview:self.enableFilterParmasBtn];
        
        
    }
    return _beautifyFilterView;
}

- (void)resetSdkUI
{
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
    if (iDeviceOrientation != self.oldScreenMode) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
            
            
            switch (iDeviceOrientation) {
                case UIDeviceOrientationPortrait:
                case UIDeviceOrientationPortraitUpsideDown:
                    [self resetWithUI:tapView frame:CGRectMake(0, 0, self.kwSdk.varWidth, self.kwSdk.varHeight)];
                    
                    [self resetWithUI:self.toggleBtn frame:CGRectMake((self.kwSdk.varWidth - 33) / 2 - 10, 11 - 10, 33 + 20, 28 + 20)];
                    
                    [self resetWithUI:self.closeVideoBtn frame:CGRectMake(15, 15, 100, 20)];
                    
                    [self resetWithUI:self.offPhoneBtn frame:CGRectMake((self.kwSdk.varWidth - 81) / 2, self.kwSdk.varHeight - 23 - 81, 81, 81)];
                    
                    [self resetWithUI:self.openFilterSetBtn frame:CGRectMake(self.kwSdk.varWidth - 38 - 44, self.kwSdk.varHeight - 45 - 38, 38, 38)];
                    
                    // 特效按钮的frame 17.07.17 60 （41，self.kwSdk.varHeight - 45 - 38, 38, 38）
                    [self resetWithUI:self.openStickerSetBtn frame:CGRectMake(self.kwSdk.varWidth - 61, 180, 46, 46)];
                    
                    [self resetWithUI:self.mainMenuView frame:CGRectMake(0, self.kwSdk.varHeight , self.kwSdk.varWidth, 42)];
                    
                    [self resetWithUI:self.filterGlobalView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 101)];
                    
                    [self resetWithUI:self.beautifyFilterView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 175 + 52 + 15 - 90)];
                    
                    [self resetWithUI:self.beautifyNewView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 111)];
                    
                    [self resetWithUI:self.stickerMenuView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 185)];
                    
                    [self resetWithUI:self.distortionMenuView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 185)];
                    
                    [self resetWithUI:self.slideBeautifyMenuView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 240)];
                    
                    [self resetWithUI:self.stickerOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6, 3, 46, 46)];
                    
                    [self resetWithUI:self.distortionOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 3 + 46 * 2, 3, 46, 46)];
                    
                    [self resetWithUI:self.beautifyOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 5 + 46 * 4, 3, 46, 46)];
                    
                    [self resetWithUI:self.beautifyNewBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 4 + 46 * 3, 6, 46, 46)];
                    
                    [self resetWithUI:self.slideGlobalBeautifyOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 5 + 46 * 4, 6, 46, 46)];
                    
                    break;
                    
                case UIDeviceOrientationLandscapeLeft:
                case UIDeviceOrientationLandscapeRight:
                    [self resetWithUI:tapView frame:CGRectMake(0, 0, self.kwSdk.varWidth, self.kwSdk.varHeight)];
                    
                    [self resetWithUI:self.toggleBtn frame:CGRectMake((self.kwSdk.varWidth - 33) / 2 - 10, 11 - 10, 33 + 20, 28 + 20)];
                    
                    [self resetWithUI:self.closeVideoBtn frame:CGRectMake(15, 15, 100, 20)];
                    
                    [self resetWithUI:self.offPhoneBtn frame:CGRectMake((self.kwSdk.varWidth - 81) / 2, self.kwSdk.varHeight - 23 - 81, 81, 81)];
                    
                    [self resetWithUI:self.openFilterSetBtn frame:CGRectMake(self.kwSdk.varWidth - 38 - 44, self.kwSdk.varHeight - 45 - 38, 38, 38)];
                    
                    // 特效按钮的frame 17.07.17 60 （41, self.kwSdk.varHeight - 80, 38, 38）
                    [self resetWithUI:self.openStickerSetBtn frame:CGRectMake(self.kwSdk.varWidth - 61, 180, 46, 46)];
                    
                    [self resetWithUI:self.mainMenuView frame:CGRectMake(0, self.kwSdk.varHeight , self.kwSdk.varWidth, 42)];
                    
                    [self resetWithUI:self.filterGlobalView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 101)];
                    
                    [self resetWithUI:self.beautifyFilterView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 175 + 52 + 15 - 90)];
                    
                    [self resetWithUI:self.beautifyNewView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 111)];
                    
                    [self resetWithUI:self.stickerMenuView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 185)];
                    
                    [self resetWithUI:self.distortionMenuView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 185)];
                    
                    [self resetWithUI:self.slideBeautifyMenuView frame:CGRectMake(0, self.kwSdk.varHeight, self.kwSdk.varWidth, 240)];
                    
                    [self resetWithUI:self.stickerOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6, 3, 46, 46)];
                    
                    [self resetWithUI:self.distortionOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 3 + 46 * 2, 3, 46, 46)];
                    
                    [self resetWithUI:self.beautifyOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 5 + 46 * 4, 3, 46, 46)];
                    
                    [self resetWithUI:self.beautifyNewBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 4 + 46 * 3, 6, 46, 46)];
                    
                    [self resetWithUI:self.slideGlobalBeautifyOptionsBtn frame:CGRectMake((self.kwSdk.varWidth - 46 * 5) / 6 * 5 + 46 * 4, 6, 46, 46)];
                    break;
                default:
                    
                    break;
            }
            
            /* agora 特有偏移效果 */
//                    [self setLeftBtn:CGPointMake(20,-20)];
//                    [self setRightBtn:CGPointMake(-20,-20)];
            
        });
    }
}

- (void)resetWithUI:(UIView *) sender frame:(CGRect) frame
{
    sender.frame = frame;
}


//New Beauty Parameters View
- (UIView *)beautifyNewView
{
    if(!_beautifyNewView)
    {
        _beautifyNewView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 111)];
        [_beautifyNewView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.2)];
        
        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth_KW - 100) / 2, 5, 100, 13)];
        if (IsEnglish) {
            [labTitle setText:@"Beautification1"];
        }
        else
        {
            [labTitle setText:@"全局美颜1"];
        }
        
        [labTitle setTextColor:[UIColor whiteColor]];
        [labTitle setFont:[UIFont systemFontOfSize:12.f]];
        [labTitle setTextAlignment:NSTextAlignmentCenter];
        [_beautifyNewView addSubview:labTitle];
        
        btnBeautify1 = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 4) / 5, 32, 46, 46)];
        btnBeautify1.layer.cornerRadius = 23;
        btnBeautify1.layer.masksToBounds = YES;
        [btnBeautify1 setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
        [btnBeautify1 setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateSelected];
        [btnBeautify1 setBackgroundImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [btnBeautify1 setBackgroundImage:[UIImage imageNamed:@"huangquan"] forState:UIControlStateSelected];
        btnBeautify1.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        btnBeautify1.tag = 0;
        [btnBeautify1 addTarget:self action:@selector(btnBeautifyOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_beautifyNewView addSubview:btnBeautify1];
        
        btnBeautify2 = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 4) / 5 * 2 + 46, 32, 46, 46)];
        btnBeautify2.layer.cornerRadius = 23;
        btnBeautify2.layer.masksToBounds = YES;
        [btnBeautify2 setBackgroundImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [btnBeautify2 setBackgroundImage:[UIImage imageNamed:@"huangquan"] forState:UIControlStateSelected];
        [btnBeautify2 setTitle:@"1" forState:UIControlStateNormal];
        btnBeautify2.tag = 1;
        [btnBeautify2 setSelected:YES];
        [btnBeautify2 addTarget:self action:@selector(btnBeautifyOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_beautifyNewView addSubview:btnBeautify2];
        
        btnBeautify3 = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 4) / 5 * 3 + 46 * 2, 32, 46, 46)];
        btnBeautify3.layer.cornerRadius = 23;
        btnBeautify3.layer.masksToBounds = YES;
        [btnBeautify3 setBackgroundImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [btnBeautify3 setBackgroundImage:[UIImage imageNamed:@"huangquan"] forState:UIControlStateSelected];
        [btnBeautify3 setTitle:@"2" forState:UIControlStateNormal];
        btnBeautify3.tag = 2;
        [btnBeautify3 addTarget:self action:@selector(btnBeautifyOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_beautifyNewView addSubview:btnBeautify3];
        
        btnBeautify4 = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 4) / 5 * 4 + 46 * 3, 32, 46, 46)];
        btnBeautify4.layer.cornerRadius = 23;
        btnBeautify4.layer.masksToBounds = YES;
        [btnBeautify4 setBackgroundImage:[UIImage imageNamed:@"huiquan"] forState:UIControlStateNormal];
        [btnBeautify4 setBackgroundImage:[UIImage imageNamed:@"huangquan"] forState:UIControlStateSelected];
        [btnBeautify4 setTitle:@"3" forState:UIControlStateNormal];
        btnBeautify4.tag = 3;
        [btnBeautify4 addTarget:self action:@selector(btnBeautifyOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_beautifyNewView addSubview:btnBeautify4];
        
    }
    return _beautifyNewView;
}



/* 拉条新美颜 选择view */
- (UIView *)slideBeautifyMenuView
{
    if (!_slideBeautifyMenuView) {
        _slideBeautifyMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 240)];
        _slideBeautifyMenuView.userInteractionEnabled = YES;
        [_slideBeautifyMenuView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.2)];
        
        [_slideBeautifyMenuView addSubview:self.NewBeautifySliderWhitening];
        [_slideBeautifyMenuView addSubview:self.NewBeautifySliderMicrodermabrasion];
        [_slideBeautifyMenuView addSubview:self.NewBeautifySliderSaturation];
        [_slideBeautifyMenuView addSubview:self.NewBeautifySliderPinkistender];

        UILabel *labTitle = [[UILabel alloc] initWithFrame:CGRectMake((ScreenWidth_KW - 120) / 2,  8 , 120, 13)];
        
        if (IsEnglish) {
            [labTitle setText:@"Skin"];
        }
        else
        {
            [labTitle setText:@"美颜"];
        }
        
        [labTitle setTextColor:[UIColor whiteColor]];
        [labTitle setFont:[UIFont systemFontOfSize:12.f]];
        [labTitle setTextAlignment:NSTextAlignmentCenter];
        [_slideBeautifyMenuView addSubview:labTitle];
        
        
        UILabel *labTitle1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 12 + 3 + 52 + 15, 100, 16)];
        [labTitle1 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle1 setTextColor:[UIColor whiteColor]];
        if (IsEnglish) {
            [labTitle1 setText:@"Skin whitening"];
        }
        else
        {
            [labTitle1 setText:@"美白"];
        }
        ;
        [labTitle1 setTextAlignment:NSTextAlignmentCenter];
        [_slideBeautifyMenuView addSubview:labTitle1];
        
        UILabel *labTitle2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 54 + 3 + 52 + 15, 100, 16)];
        [labTitle2 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle2 setTextColor:[UIColor whiteColor]];
        [labTitle2 setTextAlignment:NSTextAlignmentCenter];
        if (IsEnglish) {
            [labTitle2 setText:@"Blemish removal"];
        }
        else
        {
            [labTitle2 setText:@"磨皮"];
        }
        [_slideBeautifyMenuView addSubview:labTitle2];
        
        UILabel *labTitle3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 95 + 3 +52 +15, 100, 16)];
        [labTitle3 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle3 setTextColor:[UIColor whiteColor]];
        [labTitle3 setTextAlignment:NSTextAlignmentCenter];
        if (IsEnglish) {
            [labTitle3 setText:@"Skin saturation"];
        }
        else
        {
            [labTitle3 setText:@"饱和"];
        }
        
        [_slideBeautifyMenuView addSubview:labTitle3];
        
        UILabel *labTitle4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 137 + 3 + 52 +15, 100, 16)];
        [labTitle4 setFont:[UIFont systemFontOfSize:11.f]];
        [labTitle4 setTextColor:[UIColor whiteColor]];
        [labTitle4 setTextAlignment:NSTextAlignmentCenter];
        if (IsEnglish) {
            [labTitle4 setText:@"Skin tenderness"];
        }
        else
        {
            [labTitle4 setText:@"粉嫩"];
        }
        [_slideBeautifyMenuView addSubview:labTitle4];
        
        self.slideBeautifyEnableStateLab = [[UILabel alloc]initWithFrame:CGRectMake(32, 12 + 3 + 52 - 39 +15, 40, 15)];
        [self.slideBeautifyEnableStateLab setFont:[UIFont systemFontOfSize:15.f]];
        [self.slideBeautifyEnableStateLab setTextColor:[UIColor whiteColor]];
        if (IsEnglish) {
            [self.slideBeautifyEnableStateLab setText:@"Off"];
        }
        else
        {
            [self.slideBeautifyEnableStateLab setText:@"关"];
        }
        
        if (!IsEnglish) {
            self.NewBeautifySliderWhitening.frame = CGRectMake(120 -60, 12 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 -30 + 60 - 20, 20);
            self.NewBeautifySliderMicrodermabrasion.frame = CGRectMake(120 -60, 54 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 -30 + 60 - 20, 20);
            self.NewBeautifySliderSaturation.frame = CGRectMake(120 -60, 96 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 -30 + 60 - 20, 20);
            self.NewBeautifySliderPinkistender.frame = CGRectMake(120 -60, 138 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 -30 + 60 - 20, 20);
            
            labTitle1.frame = CGRectMake(0, 12 + 3 + 52 + 15, 125 - 60 , 16);
            labTitle2.frame = CGRectMake(0,  54 + 3 + 52 + 15, 125 - 60, 16);
            labTitle3.frame = CGRectMake(0, 96 + 3 + 52 + 15, 125 - 60, 16);
            labTitle4.frame = CGRectMake(0, 138 + 3 + 52 + 15, 125 - 60, 16);
        }
        
        
        
        UILabel *countLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50, 12 + 3 + 52 + 15, 50, 13)];
        self.NewBeautifyLabelWhitening = countLabel1;
        [countLabel1 setText:[NSString stringWithFormat:@"%d",(int)self.NewBeautifySliderWhitening.value]];
        [countLabel1 setTextColor:[UIColor whiteColor]];
        [countLabel1 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel1 setTextAlignment:NSTextAlignmentCenter];
        [_slideBeautifyMenuView addSubview:countLabel1];
        
        UILabel *countLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50, 54 + 3 + 52 + 15, 50, 13)];
        self.NewBeautifyLabelMicrodermabrasion = countLabel2;
        [countLabel2 setText:[NSString stringWithFormat:@"%d",(int)self.NewBeautifySliderMicrodermabrasion.value]];
        [countLabel2 setTextColor:[UIColor whiteColor]];
        [countLabel2 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel2 setTextAlignment:NSTextAlignmentCenter];
        [_slideBeautifyMenuView addSubview:countLabel2];
        
        UILabel *countLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50, 96 + 3 + 52 + 15, 50, 13)];
        self.NewBeautifyLabelSaturation = countLabel3;
        [countLabel3 setText:[NSString stringWithFormat:@"%d",(int)self.NewBeautifySliderSaturation.value]];
        [countLabel3 setTextColor:[UIColor whiteColor]];
        [countLabel3 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel3 setTextAlignment:NSTextAlignmentCenter];
        [_slideBeautifyMenuView addSubview:countLabel3];
        
        UILabel *countLabel4 = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 50, 138 + 3 + 52 + 15, 50, 13)];
        self.NewBeautifyLabelPinkistender = countLabel4;
        [countLabel4 setText:[NSString stringWithFormat:@"%d",(int)self.NewBeautifySliderPinkistender.value]];
        [countLabel4 setTextColor:[UIColor whiteColor]];
        [countLabel4 setFont:[UIFont systemFontOfSize:11.f]];
        [countLabel4 setTextAlignment:NSTextAlignmentCenter];
        [_slideBeautifyMenuView addSubview:countLabel4];
        
//        [_slideBeautifyMenuView addSubview:self.slideBeautifyEnableStateLab];
        
        [_slideBeautifyMenuView addSubview:self.enableBeautifyFilterParmasBtn];
    }
    return _slideBeautifyMenuView;
}

/* 开启和关闭大眼瘦脸美颜参数的按钮 */
- (UIButton *)enableFilterParmasBtn
{
    if (!_enableFilterParmasBtn) {
        _enableFilterParmasBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 43) / 2, 30, 43, 43)];
        
        [_enableFilterParmasBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        
        [_enableFilterParmasBtn setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
        
        [_enableFilterParmasBtn setSelected:YES];
        
        [_enableFilterParmasBtn setHidden:YES];
        
        _enableFilterParmasBtn.layer.cornerRadius = 21.5;
        
        _enableFilterParmasBtn.layer.masksToBounds = YES;
        
        [_enableFilterParmasBtn addTarget:self action:@selector(enableFilterParmasBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enableFilterParmasBtn;
}

/* 开启拉条 美颜参数的按钮 */
- (UIButton *)enableBeautifyFilterParmasBtn
{
    if (!_enableBeautifyFilterParmasBtn) {
        _enableBeautifyFilterParmasBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 43) / 2, 30, 43, 43)];
        
        [_enableBeautifyFilterParmasBtn setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        
        [_enableBeautifyFilterParmasBtn setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
        
        [_enableBeautifyFilterParmasBtn setSelected:YES];
        
        _enableFilterParmasBtn.layer.cornerRadius = 21.5;
        
        _enableBeautifyFilterParmasBtn.layer.masksToBounds = YES;
        
        [_enableBeautifyFilterParmasBtn addTarget:self action:@selector(enableBeautifyFilterParmasBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enableBeautifyFilterParmasBtn;
}

/* 大眼参数选择条 */
- (UISlider *)sliderEyeMagnifying
{
    if (!_sliderEyeMagnifying) {
        _sliderEyeMagnifying = [[UISlider alloc]initWithFrame:CGRectMake(120 - 10, 12 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 - 30 - 20, 20)];
        
        //大脸指定可变最小值
        _sliderEyeMagnifying.minimumValue = 0;
        
        //大眼指定可变最大值
        //        _sliderEyeMagnifying.maximumValue = 0.3;
        _sliderEyeMagnifying.maximumValue = 100;
        
        //大眼指定初始值

        if (![KWSaveData floatForKey:@"sliderEyeMagnifying"]) {
            _sliderEyeMagnifying.value = 10;
            [KWSaveData setFloat:10 forKey:@"sliderEyeMagnifying"];
            
        }else{
            _sliderEyeMagnifying.value = [KWSaveData floatForKey:@"sliderEyeMagnifying"];
            NSLog(@"_sliderEyeMagnifying.value --- %f", _sliderEyeMagnifying.value);
        }
        
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_EYEMAGNIFYING value:_sliderEyeMagnifying.value];
        
        [_sliderEyeMagnifying setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        
        [_sliderEyeMagnifying setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_sliderEyeMagnifying setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        
        [_sliderEyeMagnifying setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_sliderEyeMagnifying addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderEyeMagnifying;
}

/* 瘦脸参数选择条 */
- (UISlider *)sliderChinSlimming
{
    if (!_sliderChinSlimming) {
        _sliderChinSlimming = [[UISlider alloc]initWithFrame:CGRectMake(120 - 10, 54 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 - 30 - 20, 20)];
        
        //瘦脸指定可变最小值
        _sliderChinSlimming.minimumValue = 0;
        
        //瘦脸指定可变最大值
        //        _sliderChinSlimming.maximumValue = 1.00f;
        _sliderChinSlimming.maximumValue = 100;
        
        //瘦脸指定初始值
        //        _sliderChinSlimming.value = 1.90 - 0.97;
        
        if (![KWSaveData floatForKey:@"sliderChinSlimming"]) {
            
            _sliderChinSlimming.value = 20;
            [KWSaveData setFloat:20 forKey:@"sliderChinSlimming"];
            
        }else{
            
            _sliderChinSlimming.value = [KWSaveData floatForKey:@"sliderChinSlimming"];
        }
        
        
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_CHINSLIMING value:_sliderChinSlimming.value];
        [_sliderChinSlimming setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        [_sliderChinSlimming setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_sliderChinSlimming setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        [_sliderChinSlimming setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_sliderChinSlimming addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _sliderChinSlimming;
}
//newBeautifyUpdateValue

/* 美白参数选择条 */
- (UISlider *)NewBeautifySliderWhitening
{
    if (!_NewBeautifySliderWhitening) {
        _NewBeautifySliderWhitening = [[UISlider alloc]initWithFrame:CGRectMake(120 - 10, 12 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 -30 -20, 20)];
        
        //美白指定可变最小值
        _NewBeautifySliderWhitening.minimumValue = 0;
        
        
        //美白指定可变最大值
        _NewBeautifySliderWhitening.maximumValue = 100;
        
        
        //美白指定初始值
        
        if (![KWSaveData floatForKey:@"NewBeautifySliderWhitening"]) {
            
            _NewBeautifySliderWhitening.value = 70;
            
            [KWSaveData setFloat:70 forKey:@"NewBeautifySliderWhitening"];
            
        }else{
            
            _NewBeautifySliderWhitening.value = [KWSaveData floatForKey:@"NewBeautifySliderWhitening"];
        }
        
        
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_SKINWHITENING value:_NewBeautifySliderWhitening.value];
        
        [_NewBeautifySliderWhitening setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderWhitening setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_NewBeautifySliderWhitening setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        
        [_NewBeautifySliderWhitening setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderWhitening addTarget:self action:@selector(newBeautifyUpdateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _NewBeautifySliderWhitening;
}

/* 磨皮参数选择条 */
- (UISlider *)NewBeautifySliderMicrodermabrasion
{
    if (!_NewBeautifySliderMicrodermabrasion) {
        _NewBeautifySliderMicrodermabrasion = [[UISlider alloc]initWithFrame:CGRectMake(120 - 10, 54 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 - 30 - 20, 20)];
        
        //磨皮指定可变最小值
        _NewBeautifySliderMicrodermabrasion.minimumValue = 0;
        
        //磨皮指定可变最大值
        _NewBeautifySliderMicrodermabrasion.maximumValue = 100;
        
        //磨皮指定初始值
        
        //美白指定初始值
        
        if (![KWSaveData floatForKey:@"NewBeautifySliderMicrodermabrasion"]) {
            
            _NewBeautifySliderMicrodermabrasion.value = 30;

            [KWSaveData setFloat:30 forKey:@"NewBeautifySliderMicrodermabrasion"];
            
        }else{
            
            _NewBeautifySliderMicrodermabrasion.value = [KWSaveData floatForKey:@"NewBeautifySliderMicrodermabrasion"];
        }
        
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_BLEMISHREMOVAL value:_NewBeautifySliderMicrodermabrasion.value];
        
        [_NewBeautifySliderMicrodermabrasion setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderMicrodermabrasion setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_NewBeautifySliderMicrodermabrasion setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        
        [_NewBeautifySliderMicrodermabrasion setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderMicrodermabrasion addTarget:self action:@selector(newBeautifyUpdateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _NewBeautifySliderMicrodermabrasion;
}

/* 饱和参数选择条 */
- (UISlider *)NewBeautifySliderSaturation
{
    if (!_NewBeautifySliderSaturation) {
        _NewBeautifySliderSaturation = [[UISlider alloc]initWithFrame:CGRectMake(120 - 10, 96 + 52 + 15, ScreenWidth_KW - 67 - 32 - 20 - 30 -20, 20)];
        
        //饱和指定可变最小值
        _NewBeautifySliderSaturation.minimumValue =  0;
        
        //饱和指定可变最大值
        _NewBeautifySliderSaturation.maximumValue = 100;
        
        //饱和指定初始值
        
        
        if (![KWSaveData floatForKey:@"NewBeautifySliderSaturation"]) {
            
            _NewBeautifySliderSaturation.value = 0;

            [KWSaveData setFloat:0 forKey:@"NewBeautifySliderSaturation"];
            
        }else{
            
            _NewBeautifySliderSaturation.value = [KWSaveData floatForKey:@"NewBeautifySliderSaturation"];
        }
        
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_SKINSATURATION value:_NewBeautifySliderSaturation.value];
        
        
        [_NewBeautifySliderSaturation setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderSaturation setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_NewBeautifySliderSaturation setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        
        [_NewBeautifySliderSaturation setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderSaturation addTarget:self action:@selector(newBeautifyUpdateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _NewBeautifySliderSaturation;
}

/* 粉嫩参数选择条 */
- (UISlider *)NewBeautifySliderPinkistender
{
    if (!_NewBeautifySliderPinkistender) {
        _NewBeautifySliderPinkistender = [[UISlider alloc]initWithFrame:CGRectMake(120 - 10, 138 + 52 + 15 , ScreenWidth_KW - 67 - 32 - 20 - 30 - 20, 20)];
        
        //磨皮指定可变最小值
        _NewBeautifySliderPinkistender.minimumValue =  0;
        
        //磨皮指定可变最大值
        _NewBeautifySliderPinkistender.maximumValue = 100;
        
        //磨皮指定初始值
        if (![KWSaveData floatForKey:@"NewBeautifySliderPinkistender"]) {
            
            _NewBeautifySliderPinkistender.value = 20;
            [KWSaveData setFloat:20 forKey:@"NewBeautifySliderPinkistender"];
            
        }else{
            
            _NewBeautifySliderPinkistender.value = [KWSaveData floatForKey:@"NewBeautifySliderPinkistender"];
        }
        
        
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_SKINTENDERNESS value:_NewBeautifySliderPinkistender.value];
        
        
        [_NewBeautifySliderPinkistender setMinimumTrackImage:[UIImage imageNamed:@"wire"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderPinkistender setMaximumTrackImage:[UIImage imageNamed:@"wire drk"] forState:UIControlStateNormal];
        
        //注意这里要加UIControlStateHightlighted的状态，否则当拖动滑块时滑块将变成原生的控件
        [_NewBeautifySliderPinkistender setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateHighlighted];
        
        [_NewBeautifySliderPinkistender setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        
        [_NewBeautifySliderPinkistender addTarget:self action:@selector(newBeautifyUpdateValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _NewBeautifySliderPinkistender;
}

/* 贴纸选择view */
- (UIView *)stickerMenuView
{
    if (!_stickerMenuView) {
        
        _stickerMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 220)];
        
        [_stickerMenuView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.4)];
        
        _stickerMenuView.userInteractionEnabled = YES;
        
        UILabel *stickerLabel = [[UILabel alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 120) / 2., 8, 120, 13)];
        
        if (IsEnglish) {
            stickerLabel.text = @"Stickers";
        }else{
            stickerLabel.text = @"贴纸";
        }
        stickerLabel.textAlignment = NSTextAlignmentCenter;
        stickerLabel.font = [UIFont systemFontOfSize:12];
        stickerLabel.textColor = [UIColor whiteColor];
        
        [_stickerMenuView addSubview:stickerLabel];
        [_stickerMenuView addSubview:self.stickersCollectionView];
    }
    return _stickerMenuView;
}

/* 哈哈镜选择view */
- (UIView *)distortionMenuView
{
    if (!_distortionMenuView) {
        _distortionMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 185)];
        
        _distortionMenuView.userInteractionEnabled = YES;
        
        [_distortionMenuView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.5)];
        
        [_distortionMenuView addSubview:self.distortionCollectionView];
    }
    return _distortionMenuView;
}

/* 礼物贴纸选择view */
- (UIView *)presentStickerMenuView
{
    if (!_presentStickerMenuView) {
        _presentStickerMenuView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight_KW, ScreenWidth_KW, 185)];
        
        _presentStickerMenuView.userInteractionEnabled = YES;
        
        [_presentStickerMenuView setBackgroundColor:RGBACOLOR(0, 0, 0, 0.2)];
        
        [_presentStickerMenuView addSubview:self.presentStickerCollectionView];
    }
    return _presentStickerMenuView;
}

/* 打开贴纸设置的 按钮 */
- (UIButton *)stickerOptionsBtn
{
    if (!_stickerOptionsBtn) {
        _stickerOptionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _stickerOptionsBtn.frame = CGRectMake((ScreenWidth_KW - 46 * 5) / 6 + 10, 0, 46, 42);
        
        [_stickerOptionsBtn setImage:[UIImage imageNamed:@"tags drk"] forState:UIControlStateNormal];
        
        [_stickerOptionsBtn setImage:[UIImage imageNamed:@"tags"] forState:UIControlStateSelected];
        
        [_stickerOptionsBtn addTarget:self action:@selector(stickerOptionsBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stickerOptionsBtn;
}

/* 打开哈哈镜设置的 按钮 */
- (UIButton *)distortionOptionsBtn
{
    if (!_distortionOptionsBtn) {
        _distortionOptionsBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 5) / 6 * 3 + 46 * 2, 0, 46, 46)];
        [_distortionOptionsBtn setImage:[UIImage imageNamed:@"distorting mirror drk"] forState:UIControlStateNormal];
        
        [_distortionOptionsBtn setImage:[UIImage imageNamed:@"distorting mirror"] forState:UIControlStateSelected];
        
        [_distortionOptionsBtn addTarget:self action:@selector(distortionOptionsBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _distortionOptionsBtn;
}

/* 打开美颜参数设置的 按钮 */
- (UIButton *)beautifyOptionsBtn
{
    if (!_beautifyOptionsBtn) {
        _beautifyOptionsBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 5) / 6 * 5 + 46 * 4, 0, 46, 42)];
        [_beautifyOptionsBtn setImage:[UIImage imageNamed:@"beauty drk"] forState:UIControlStateNormal];
        
        [_beautifyOptionsBtn setImage:[UIImage imageNamed:@"beauty"] forState:UIControlStateSelected];
        
        [_beautifyOptionsBtn addTarget:self action:@selector(beautifyOptionsBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautifyOptionsBtn;
}

/* 美颜参数设置 */
- (UIButton *)beautifyNewBtn
{
    if (!_beautifyNewBtn) {
        
        _beautifyNewBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 5) / 6 * 4 + 46 * 3, 6, 46, 46)];
        
        [_beautifyNewBtn setImage:[UIImage imageNamed:@"meiyan"] forState:UIControlStateNormal];
        
        [_beautifyNewBtn setImage:[UIImage imageNamed:@"meiyanliang"] forState:UIControlStateSelected];
        
        [_beautifyNewBtn addTarget:self action:@selector(beautifyNewBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _beautifyNewBtn;
}

/* 点阵 按钮 */
- (UIButton *)pointBtn
{
    if (!_pointBtn) {
        _pointBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 5) / 6 * 6 + 46 * 5, 6, 46, 46)];
        [_pointBtn setImage:[UIImage imageNamed:@"face drk"] forState:UIControlStateNormal];
        [_pointBtn setImage:[UIImage imageNamed:@"face"] forState:UIControlStateSelected];
//        [_pointBtn setHidden:YES];
        [_pointBtn addTarget:self action:@selector(pointBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pointBtn;
}


/* 打开拉条全局美颜参数设置的 按钮 */
- (UIButton *)slideGlobalBeautifyOptionsBtn
{
    if (!_slideGlobalBeautifyOptionsBtn) {
        _slideGlobalBeautifyOptionsBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 5) / 6 * 5 + 46 * 4 - 10, 0, 46, 42)];
        
        [_slideGlobalBeautifyOptionsBtn setImage:[UIImage imageNamed:@"quanjumeiyan"] forState:UIControlStateNormal];
        
        [_slideGlobalBeautifyOptionsBtn setImage:[UIImage imageNamed:@"quanjumeiyanliang"] forState:UIControlStateSelected];
        
        [_slideGlobalBeautifyOptionsBtn addTarget:self action:@selector(slideGlobalBeautifyOptionsBtnOnClick:)  forControlEvents:UIControlEventTouchUpInside];
    }
    return _slideGlobalBeautifyOptionsBtn;
}

/* 礼物贴纸参数设置菜单按钮 （暂时弃用） */
- (UIButton *)presentStickerBtn
{
    if (!_presentStickerBtn) {
        
        _presentStickerBtn = [[UIButton alloc]initWithFrame:CGRectMake((ScreenWidth_KW - 46 * 5) / 6 * 6 + 46 * 5, 6, 46, 46)];
        
        [_presentStickerBtn setImage:[UIImage imageNamed:@"presentSticker_sys"] forState:UIControlStateNormal];
        
        [_presentStickerBtn setImage:[UIImage imageNamed:@"presentStickerDown_sys"] forState:UIControlStateSelected];
        
        [_presentStickerBtn addTarget:self action:@selector(presentStickerBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentStickerBtn;
}

/* 礼物贴纸 启动按钮 */
- (UIButton *)presentSwitchBtn
{
    if (!_presentSwitchBtn) {
        _presentSwitchBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 61, 60, 46, 46)];
        
        [_presentSwitchBtn setImage:[UIImage imageNamed:@"presentSticker_sys"] forState:UIControlStateNormal];
        
        [_presentSwitchBtn setImage:[UIImage imageNamed:@"presentStickerDown_sys"] forState:UIControlStateHighlighted];
        
        [_presentSwitchBtn setImage:[UIImage imageNamed:@"presentStickerDown_sys"] forState:UIControlStateSelected];
        
        [_presentSwitchBtn setImage:[UIImage imageNamed:@"presentStickerDown_sys"] forState:UIControlStateDisabled];
        
        [_presentSwitchBtn addTarget:self action:@selector(presentSwitchBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presentSwitchBtn;
}

/* 表情贴纸 开关按钮 */
- (UIButton *)smiliesSwitchBtn
{
    if (!_smiliesSwitchBtn) {
        _smiliesSwitchBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth_KW - 61, 120, 46, 46)];
        
        [_smiliesSwitchBtn setImage:[UIImage imageNamed:@"smiliesSticker_sys"] forState:UIControlStateNormal];
        
        [_smiliesSwitchBtn setImage:[UIImage imageNamed:@"smiliesStickerDown_sys"] forState:UIControlStateHighlighted];
        
        [_smiliesSwitchBtn setImage:[UIImage imageNamed:@"smiliesStickerDown_sys"] forState:UIControlStateSelected];
        
        [_smiliesSwitchBtn setImage:[UIImage imageNamed:@"smiliesStickerDown_sys"] forState:UIControlStateDisabled];
        
        [_smiliesSwitchBtn addTarget:self action:@selector(smiliesSwitchBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _smiliesSwitchBtn;
}

/* 表情开关打开时 显示的 UI提示 */
- (UILabel *)smiliesStateText
{
    if (!_smiliesStateText) {
        _smiliesStateText = [[UILabel alloc]init];
        
        _smiliesStateText.frame = CGRectMake((ScreenWidth_KW - 100) / 2, (ScreenHeight_KW - 20) / 2, 100, 20);
        
        [_smiliesStateText setFont:[UIFont systemFontOfSize:18.f]];
        
        [_smiliesStateText setTextColor:[UIColor whiteColor]];
        
        [_smiliesStateText setText:@"请张大嘴巴"];
        
        [_smiliesStateText setHidden:YES];
    }
    return _smiliesStateText;
}

-(UIView *)recordCircleView{
    if (!_recordCircleView) {
        _recordCircleView=[[UIView alloc]init];
        _recordCircleView.bounds = CGRectMake(0, 0, 6.84, 6.84);
        _recordCircleView.center = self.offPhoneBtn.center;
        _recordCircleView.backgroundColor = [UIColor cyanColor];
        _recordCircleView.layer.cornerRadius = _recordCircleView.bounds.size.width / 2.;
        _recordCircleView.hidden = YES;
    }
    return _recordCircleView;
}

-(UIView *)splashView{
    if (!_splashView) {
        _splashView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _splashView.alpha = 0;
        [_actionViewController.view addSubview:_splashView];
    }
    return _splashView;
}

#pragma mark -- 按钮点击事件处理

- (void)toggleBtnOnClick:(UIButton *)sender
{
    //先将未到时间执行前的任务取消
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(toggleCamera) object:sender];
    [self performSelector:@selector(toggleCamera) withObject:sender afterDelay:0.3f];
    
}

- (void)closeVideoBtnOnClick:(UIButton *)sender
{
    [self closeVideoWindow];
}

- (void)takePhotoBtnOnClick:(UIButton *)sender
{

}

- (void)offPhoneBtnOnClick:(UIButton *)sender
{
    self.splashView.backgroundColor = [UIColor whiteColor];
    [self splashScreen];
    
    [self.offPhoneBtn setHighlighted:NO];

    if ([self.delegate respondsToSelector:@selector(didClickOffPhoneButton)]) {
        [self.delegate didClickOffPhoneButton];
    }
}

- (void)openStickerSetBtnOnClick:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    if (!sender.isSelected) {
        [self viewOnTap];
    }
    else{
        [self pushmainMenuView:YES];
    }
}

- (void)openFilterSetBtnOnClick:(UIButton *)sender
{
    [self pushFilterGlobalView:YES];
}

- (void)updateValue:(UISlider *)sender
{
    if ([sender isEqual:self.sliderEyeMagnifying]) {
        self.labelEyeMagnifying.text = [NSString stringWithFormat:@"%d",(int)sender.value];
        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_EYEMAGNIFYING value:sender.value];
        [KWSaveData setFloat:sender.value forKey:@"sliderEyeMagnifying"];
        
        if (sender.value == 0) {
            [KWSaveData setFloat:0.01 forKey:@"sliderEyeMagnifying"];
        }
    }
    else if([sender isEqual:self.sliderChinSlimming])
    {
        self.labelChinSlimming.text = [NSString stringWithFormat:@"%d",(int)sender.value];

        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_CHINSLIMING value:sender.value];
        [KWSaveData setFloat:sender.value forKey:@"sliderChinSlimming"];
        if (sender.value == 0) {
            [KWSaveData setFloat:0.01 forKey:@"sliderChinSlimming"];
            
        }

    }
}

- (void)newBeautifyUpdateValue:(UISlider *)sender
{
    if ([sender isEqual:self.NewBeautifySliderWhitening]) {
        self.NewBeautifyLabelWhitening.text = [NSString stringWithFormat:@"%d",(int)sender.value];

        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_SKINWHITENING value:sender.value];
        [KWSaveData setFloat:sender.value forKey:@"NewBeautifySliderWhitening"];
        if (sender.value == 0) {
            [KWSaveData setFloat:0.01 forKey:@"NewBeautifySliderWhitening"];
            
        }
    }
    else if([sender isEqual:self.NewBeautifySliderMicrodermabrasion])
    {
        self.NewBeautifyLabelMicrodermabrasion.text = [NSString stringWithFormat:@"%d",(int)sender.value];

        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_BLEMISHREMOVAL value:sender.value];
        [KWSaveData setFloat:sender.value forKey:@"NewBeautifySliderMicrodermabrasion"];
        if (sender.value == 0) {
            [KWSaveData setFloat:0.01 forKey:@"NewBeautifySliderMicrodermabrasion"];
            
        }
    }
    
    else if ([sender isEqual:self.NewBeautifySliderSaturation]) {
        self.NewBeautifyLabelSaturation.text = [NSString stringWithFormat:@"%d",(int)sender.value];

        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_SKINSATURATION value:sender.value];
        [KWSaveData setFloat:sender.value forKey:@"NewBeautifySliderSaturation"];
        if (sender.value == 0) {
            [KWSaveData setFloat:0.01 forKey:@"NewBeautifySliderSaturation"];
            
        }
    }
    else if([sender isEqual:self.NewBeautifySliderPinkistender])
    {
        self.NewBeautifyLabelPinkistender.text = [NSString stringWithFormat:@"%d",(int)sender.value];

        [self.kwSdk onNewBeautyParamsChanged:KW_NEWBEAUTY_TYPE_SKINTENDERNESS value:sender.value];
        [KWSaveData setFloat:sender.value forKey:@"NewBeautifySliderPinkistender"];
        if (sender.value == 0) {
            [KWSaveData setFloat:0.01 forKey:@"NewBeautifySliderPinkistender"];
            
        }
    }
}

- (void)beautifyOptionsBtnOnClick:(UIButton *)sender
{
    [self.kwSdk onEnableDrawPoints:NO];
    [self actionMainMenuChange:sender];
}

- (void)stickerOptionsBtnOnClick:(UIButton *)sender
{
    [self.kwSdk onEnableDrawPoints:NO];
    [self actionMainMenuChange:sender];
}

- (void)distortionOptionsBtnOnClick:(UIButton *)sender
{
    [self.kwSdk onEnableDrawPoints:NO];
    [self actionMainMenuChange:sender];
}

- (void)slideGlobalBeautifyOptionsBtnOnClick:(UIButton *)sender
{
    [self.kwSdk onEnableDrawPoints:NO];
    [self actionMainMenuChange:sender];
}

- (void)beautifyNewBtnOnClick:(UIButton *)sender
{
    [self.kwSdk onEnableDrawPoints:NO];
    [self actionMainMenuChange:sender];
}

- (void)presentStickerBtnOnClick:(UIButton *)sender
{
    [self.kwSdk onEnableDrawPoints:NO];
    [self actionMainMenuChange:sender];
}

- (void)pointBtnOnClick:(UIButton *)sender
{
    //开启描点
    [self.kwSdk onEnableDrawPoints:!sender.isSelected];
    
    //关闭二级弹窗
    [self actionMainMenuChange:sender];
    
    //更新 美颜参数设置的UI状态
    [self.enableFilterParmasBtn setSelected:YES];
    [self enableFilterParmasBtnOnClick:self.enableFilterParmasBtn];
    
    //刷新列表选择项状态
    [self.stickersCollectionView reloadData];
    
    [self.distortionCollectionView reloadData];
    
    [self.presentStickerCollectionView reloadData];
    
    //关闭美颜功能
    [self.kwSdk onEnableBeauty:self.enableFilterParmasBtn.isSelected];
}

- (void)smiliesSwitchBtnOnClick:(UIButton *)sender
{
    [sender setSelected:!sender.isSelected];
    [self.kwSdk onEnableSmiliesSticker:sender.isSelected];
    [self.smiliesStateText setHidden:!sender.isSelected];
    
}

- (void)presentSwitchBtnOnClick:(UIButton *)sender
{
    if (!sender.isSelected) {
        [sender setSelected:YES];
        
        [self.kwSdk.renderer removeFilter:self.kwSdk.filters[2]];
        
        [((KWPresentStickerRenderer *)self.kwSdk.filters[2]) setSticker:nil];
        
        
        self.kwSdk.currentPresentStickerIndex = 1;
        KWSticker *lastSticker = self.kwSdk.presentStickers[self.kwSdk.currentPresentStickerIndex];
        //设置播放次数
        [lastSticker setPlayCount:1];
        //贴纸帧数置零 将贴纸重新播放
        for (KWStickerItem *item in lastSticker.items) {
            item.currentFrameIndex = 0;
            item.accumulator = 0;
        }
        [((KWPresentStickerRenderer *)self.kwSdk.filters[2]) setSticker:lastSticker];
        //设置播放结束后的自定义动作
        __weak typeof (self) __weakSelf = self;
        //礼物贴纸 默认设置为跟脸 渲染
        ((KWPresentStickerRenderer *)self.kwSdk.filters[2]).needTrackData = YES;
        ((KWPresentStickerRenderer *)self.kwSdk.filters[2]).presentStickerRendererPlayOverBlock = ^()
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [__weakSelf.presentSwitchBtn setSelected:NO];
            });
            
            //            [((KWPresentStickerRenderer *)(__weakSelf.kwSdk.filters[2])).sticker setPlayCount:0];
            //移除相应filter
            [__weakSelf.kwSdk.renderer removeFilter:__weakSelf.kwSdk.filters[2]];
            
        };
        
        if (self.kwSdk.currentPresentStickerIndex >= 0 && self.kwSdk.currentPresentStickerIndex < self.kwSdk.presentStickers.count + 1)
        {
            [(KWPresentStickerRenderer *)self.kwSdk.filters[2] setSticker:self.kwSdk.presentStickers[self.kwSdk.currentPresentStickerIndex]];
            
            [self.kwSdk.renderer addFilter:self.kwSdk.filters[2]];
        }
        else {
            [(KWPresentStickerRenderer *)self.kwSdk.filters[2] setSticker:nil];
        }
        
    }
}

- (void)actionMainMenuChange:(UIButton *)sender
{
    /* 更新按钮状态 */
    BOOL isSelected = sender.isSelected;
    [self disableAllMainMenuBtn];
    if (isSelected) {
        [sender setSelected:NO];
    }
    else
    {
        [sender setSelected:YES];
    }
    
    if ([sender isEqual:self.beautifyOptionsBtn])
    {
        self.NextPopView = self.beautifyFilterView;
        
        [self.enableFilterParmasBtn setHidden:!sender.isSelected];
    }
    else if ([sender isEqual:self.stickerOptionsBtn]) {
        self.NextPopView = self.stickerMenuView;
    }
    else if ([sender isEqual:self.distortionOptionsBtn]) {
        self.NextPopView = self.distortionMenuView;
        
    }
    else if ([sender isEqual:self.beautifyNewBtn])
    {
        self.NextPopView = self.beautifyNewView;
        
    }
    else if ([sender isEqual:self.pointBtn]) {
        self.NextPopView = nil;
        
    }
    else if([sender isEqual:self.slideGlobalBeautifyOptionsBtn])
    {
        self.NextPopView = self.slideBeautifyMenuView;
    }
    else if([sender isEqual:self.presentStickerBtn])
    {
        self.NextPopView = self.presentStickerMenuView;
    }
//    else if([sender isEqual:self.stickerOptionsBtn])
//    {
//        self.NextPopView = self.stickerMenuView;
//    }
    [self lockMenuBtn:NO];
    
    if (self.currentPopView != nil) {
        if (self.NextPopView != nil) {
            /* 当前弹出窗口 与 即将弹出窗口不同*/
            if (![self.currentPopView isEqual:self.NextPopView]) {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [self hideMenuSubView:self.currentPopView];
                    
                    [self showMenuSubView:self.NextPopView];
                } completion:^(BOOL finished) {
                    
                    [self lockMenuBtn:YES];
                    
                }];
            }
            /* 当前弹出窗口 与 即将弹出窗口相同*/
            else
            {
                //判断是否被选中 如果非选中状态 则隐藏当前窗口
                if (!sender.isSelected) {
                    [UIView animateWithDuration:0.1 animations:^{
                        [self hideMenuSubView:self.currentPopView];
                    } completion:^(BOOL finished) {
                        [self lockMenuBtn:YES];
                    }];
                }
                else
                {
                    [UIView animateWithDuration:0.3 animations:^{
                        [self showMenuSubView:self.currentPopView];
                    } completion:^(BOOL finished) {
                        [self lockMenuBtn:YES];
                    }];
                    
                    
                }
            }
        }
        else
        {
            
            [UIView animateWithDuration:0.1 animations:^{
                [self hideMenuSubView:self.currentPopView];
            } completion:^(BOOL finished) {
                [self lockMenuBtn:YES];
            }];
        }
        
    }
    else
    {
        if (self.NextPopView != nil) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self showMenuSubView:self.NextPopView];
            } completion:^(BOOL finished) {
                [self lockMenuBtn:YES];
            }];
            
        }
        else
        {
            [self lockMenuBtn:YES];
        }
    }
    
    self.currentPopView = self.NextPopView;
    self.NextPopView = nil;
    
}

- (void)lockMenuBtn:(BOOL)isEnable
{
    [self.beautifyOptionsBtn setEnabled:isEnable];
    
    [self.stickerOptionsBtn setEnabled:isEnable];
    
    [self.distortionOptionsBtn setEnabled:isEnable];
    
    [self.beautifyNewBtn setEnabled:isEnable];
    
    [self.pointBtn setEnabled:isEnable];
    
    [self.slideGlobalBeautifyOptionsBtn setEnabled:isEnable];
    
    [self.presentStickerBtn setEnabled:isEnable];
}

- (void)showMenuSubView:(UIView *)view
{
    
    [view setHidden:NO];
    CGRect frame = view.frame;
    
    /* 大眼瘦脸参数设置框 */
    if ([view isEqual:self.beautifyFilterView]) {
        frame.origin.y = ScreenHeight_KW - 175 - 42 - 52 - 15 + 90;
    }
    else if([view isEqual:self.beautifyNewView])
    {
        frame.origin.y = ScreenHeight_KW - 111 - 42;
    }
    else if([view isEqual:self.slideBeautifyMenuView])
    {
        frame.origin.y = ScreenHeight_KW - 240 - 42;
    }
    else
    {
        frame.origin.y = ScreenHeight_KW - 185 - 42;
        
    }
    view.frame = frame;
}



- (void)enableFilterParmasBtnOnClick:(UIButton *)sender
{
    [KWSaveData setValue:[NSNumber numberWithBool:sender.isSelected] forKey:@"lockFilterBeautifyView"];

    [self lockFilterBeautifyView:sender.isSelected];
}


//拉条美颜
- (void)enableBeautifyFilterParmasBtnOnClick:(UIButton *)sender
{
    [KWSaveData setValue:[NSNumber numberWithBool:sender.isSelected] forKey:@"lockSlideBeautifyView"];
    
    [self lockSlideBeautifyView:sender.isSelected];

}

//换挡美颜
- (void)btnBeautifyOnClick:(UIButton *)sender
{
    for (id btnItem in self.beautifyNewView.subviews)
    {
        if ([btnItem isKindOfClass:[UIButton class]])
        {
            if ([btnItem isEqual:sender]) {
                [((UIButton *)btnItem) setSelected:YES];
            }
            else
            {
                [((UIButton *)btnItem) setSelected:NO];
            }
        }
    }
    if (sender.tag > 0) {
        [self lockSlideBeautifyView:YES];
        
        [((KWBeautifyFilter *)(self.kwSdk.beautifyNewFilters[0])) setBeautifyLevel:(float)sender.tag];
        [self.kwSdk.renderer addFilter:self.kwSdk.beautifyNewFilters[0]];
        
    }
    else
    {
        [self.kwSdk.renderer removeFilter:self.kwSdk.beautifyNewFilters[0]];
    }
}

- (void)pushFilterGlobalView:(BOOL)isPop
{
    [self isHavePushed:YES];
    /* 弹出 */
    if (isPop) {
        self.currentMainMenuPopView = self.filterGlobalView;
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.filterGlobalView.frame;
            frame.origin.y = ScreenHeight_KW - 101;
            self.filterGlobalView.frame = frame;
        }];
    }
    /* 收起 */
    else
    {
        self.currentMainMenuPopView = nil;
        [UIView animateWithDuration:0.1 animations:^{
            CGRect frame = self.filterGlobalView.frame;
            frame.origin.y = ScreenHeight_KW;
            self.filterGlobalView.frame = frame;
        }];
    }
}

- (void)splashScreen{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.splashView.alpha = 0.8;
        [UIView animateWithDuration:0.5 animations:^{
            self.splashView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.splashView removeFromSuperview];
            self.splashView = nil;
        }];
    });
}

#pragma mark -- 按钮点击事件处理 END

#pragma mark -- 自定义UI参数设置

- (void) setOffPhoneBtnHidden:(BOOL)isHidden
{
    self.isHiddenOffPhoneBtn = isHidden;
    [self.offPhoneBtn setHidden:isHidden];
}

- (void) setToggleBtnHidden:(BOOL)isHidden
{
    self.isHiddenToggleBtn = isHidden;
    [self.toggleBtn setHidden:isHidden];
}

- (void) setCloseVideoBtnHidden:(BOOL)isHidden
{
    self.isHiddenCloseVideoBtn = isHidden;
    [self.closeVideoBtn setHidden:isHidden];
}

/*
 * 设置是否隐藏 主屏幕 内置UI 下方左边按钮 */
- (void) setLeftBtHidden:(BOOL)isHidden
{
    self.isHiddenStickerSetBtn = isHidden;
    [self.openStickerSetBtn setHidden:isHidden];
}


/*
 * 设置是否隐藏 主屏幕 内置UI 下方右边按钮
 */
- (void) setRightBtnHidden:(BOOL)isHidden
{
    self.isHiddenRightBtn = isHidden;
    [self.openFilterSetBtn setHidden:isHidden];
}

/*
 * 设置 内置UI 下方左边按钮的 坐标偏移量
 */
- (void)setLeftBtn:(CGPoint)point
{
    CGRect frame = self.openStickerSetBtn.frame;
    frame.origin.x = frame.origin.x + point.x;
    frame.origin.y = frame.origin.y + point.y;
    self.openStickerSetBtn.frame = frame;
}

/*
 * 设置 内置UI 下方右边按钮的 坐标偏移量
 */
- (void)setRightBtn:(CGPoint)point
{
    CGRect frame = self.openFilterSetBtn.frame;
    frame.origin.x = frame.origin.x + point.x;
    frame.origin.y = frame.origin.y + point.y;
    self.openFilterSetBtn.frame = frame;
}



#pragma mark -- 自定义UI参数设置 END

- (void)changeBeautifyMethodType:(NSInteger) type
{
    if (type == 0) {
        
        [self btnBeautifyOnClick:btnBeautify1];
        [self lockSlideBeautifyView:YES];
        
    }
    else
    {
        
        [self btnBeautifyOnClick:btnBeautify1];
        
        [self lockSlideBeautifyView:NO];
        
    }
}

- (void)initDefaultParams
{
    //大眼瘦脸开关
    if ([KWSaveData valueForKey:@"lockFilterBeautifyView"] == nil) {
        
        [self lockFilterBeautifyView:NO];
        [KWSaveData setValue:[NSNumber numberWithBool:NO] forKey:@"lockFilterBeautifyView"];
        
    }else{

        [self lockFilterBeautifyView:[[KWSaveData valueForKey:@"lockFilterBeautifyView"] boolValue]];

    };
    
    //全局美颜开关
//    if ([KWSaveData valueForKey:@"lockSlideBeautifyView"] == nil) {
//        
//        [self lockSlideBeautifyView:NO];
//        [KWSaveData setValue:[NSNumber numberWithBool:NO] forKey:@"lockSlideBeautifyView"];
//        
//    }else{
//        
//        [self lockSlideBeautifyView:[[KWSaveData valueForKey:@"lockSlideBeautifyView"] boolValue]];
//        
//    };
}

//是否关闭拉条美颜
- (void)lockSlideBeautifyView:(BOOL)isLocked
{
    [self.kwSdk onEnableNewBeauty:!isLocked];
    
    [self.NewBeautifySliderWhitening setEnabled:!isLocked];
    
    [self.NewBeautifySliderMicrodermabrasion setEnabled:!isLocked];
    
    [self.NewBeautifySliderSaturation setEnabled:!isLocked];
    
    [self.NewBeautifySliderPinkistender setEnabled:!isLocked];
    
    [self.enableBeautifyFilterParmasBtn setSelected:!isLocked];
}


//是否关闭拉条大眼瘦脸
- (void)lockFilterBeautifyView:(BOOL)isLocked
{
    [self.kwSdk onEnableBeauty:!isLocked];
    [self.sliderEyeMagnifying setEnabled:!isLocked];
    [self.sliderChinSlimming setEnabled:!isLocked];
    [self.enableFilterParmasBtn setSelected:!isLocked];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        [[KWStickerDownloadManager sharedInstance] downloadStickers:self.kwSdk.stickers withAnimation:^(NSInteger index) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index + 2 inSection:0];
            KWStickerCell *cell = (KWStickerCell*)[self.stickersCollectionView cellForItemAtIndexPath:indexPath];
            [cell startDownload];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.stickersCollectionView reloadItemsAtIndexPaths:@[indexPath]];
            });
            
            
        } successed:^(KWSticker *sticker, NSInteger index) {
            sticker.downloadState = KWStickerDownloadStateDownoadDone;
            [self.kwSdk.stickers replaceObjectAtIndex:index withObject:sticker];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                for (NSIndexPath *path in self.stickersCollectionView.indexPathsForVisibleItems) {
                    if (index == path.item) {
                        [self.stickersCollectionView  reloadData];
                        break;
                    }
                }
                
                
            });
        } failed:^(KWSticker *sticker, NSInteger index) {
            sticker.downloadState = KWStickerDownloadStateDownoadNot;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.stickersCollectionView reloadData];
                // TODO: 提示用户网络不给力
            });
        }];
        
    }
}

#pragma mark -- 设置SDK内置UI END

#pragma mark -- 设置collectionDelegate

/* 定义展示的UICollectionViewCell的个数 */
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    NSInteger count = 0;
    if (collectionView == self.stickersCollectionView) {
        if (section == 0) {
            count = self.kwSdk.stickers.count + 2;
        }
    }
    else if(collectionView == self.distortionCollectionView)
    {
        if (section == 0) {
            count = [self.kwSdk.distortionTitleInfosArr count];
        }
    }
    else if(collectionView == self.globalBeatifyFilterCollectionView)
    {
        if (section == 0) {
            count = [self.kwSdk.colorFilters count] + 1;
        }
    }
    else if(collectionView == self.presentStickerCollectionView)
    {
        if (section == 0) {
            count = self.kwSdk.presentStickers.count + 2;
        }
    }
    
    return count;
}
/* 定义展示的Section的个数 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

/* 每个UICollectionView展示的内容 */
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell;
    //    KWStickerCell *cell;
    //    KWFilterCell *textCell;
    
    if (collectionView == self.stickersCollectionView) {
        
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:KWStickerCellIdentifier forIndexPath:indexPath];
        
        [cell sizeToFit];
        
        if (indexPath.item <= 1) {
            
            [((KWStickerCell *)cell) setSticker:nil index:indexPath.item];
            
        }else{
            
            KWSticker *sticker = self.kwSdk.stickers[indexPath.item - 2];
            
            [((KWStickerCell *)cell)setSticker:sticker index:indexPath.item];
            
        }
        
        if (self.kwSdk.currentStickerIndex == indexPath.item - 2) {
            [((KWStickerCell *)cell) hideBackView:NO];
            
        }else{
            [((KWStickerCell *)cell) hideBackView:YES];
            
        }
        
    }
    else if(collectionView == self.distortionCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:KWDistortionCellIdentifier forIndexPath:indexPath];
        
        [cell sizeToFit];
        
        ((KWDistortionCell *)cell).imgView.image = [UIImage imageNamed:self.kwSdk.distortionTitleInfosArr[indexPath.item]];
        if (indexPath.row == 0) {
            [cell setSelected:YES];
        }
    }
    else if(collectionView == self.globalBeatifyFilterCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:KWFilterCellIdentifier forIndexPath:indexPath];
        
        [cell sizeToFit];
        
        
        
        if (indexPath.item == 0) {
            [((KWFilterCell *)cell) setName:nil andIcon:nil index:indexPath.item];
            
        }else{
            
            NSString *name;
            UIImage *icon;
            
            if ([self.kwSdk.colorFilters[indexPath.item - 1] isKindOfClass:[KWColorFilter class]]) {
                name = ((KWColorFilter *)self.kwSdk.colorFilters[indexPath.item - 1]).colorFilterName;
                
                icon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",((KWColorFilter *)self.kwSdk.colorFilters[indexPath.item - 1]).colorFilterDir,@"thumb.png"]];
            }
            else
            {
                name = NSStringFromClass([self.kwSdk.colorFilters[indexPath.item - 1] class]);
                
                NSString *iconPath = [[[[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"filter"] stringByAppendingPathComponent:name] stringByAppendingPathComponent:@"thumb.png"];
                icon = [UIImage imageWithContentsOfFile:iconPath];
            }
            
                
                [((KWFilterCell *)cell) setName:name andIcon:icon index:indexPath.item];

        }
        
        
        if (self.kwSdk.currentFilterIndex == indexPath.item - 1) {
            [((KWFilterCell *)cell) hideBackView:NO];
            
        }else{
            [((KWFilterCell *)cell) hideBackView:YES];
            
        }
        
        
//        if (indexPath.row == 0) {
//            icon = [UIImage imageNamed:@"cancel"];
//            name = @"Origin";
//        }
//        else
//        {
        
                
//                NSString *colorFilterPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"filter"];
                
                
                //                icon = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",self.kwSdk.colorFilters[indexPath.item - 1],@"thumb.png"]];
                
                
//                icon = [UIImage imageWithContentsOfFile:iconPath];
//            }
//        }
        
        
//        ((KWFilterCell *)cell).imageView.image = icon;
//        
//        [((KWFilterCell *)cell).label setText:name];
//        
//        
//        if (indexPath.row == 0) {
//            [cell setSelected:YES];
//        }
    }
    else if(collectionView == self.presentStickerCollectionView)
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:KWPresentStickerCollectionViewCellIdentifier forIndexPath:indexPath];
        
        [cell sizeToFit];
        
        
        
        if (indexPath.item <= 1) {
            
            [((KWStickerCell *)cell) setSticker:nil index:indexPath.item];
            
        }else{
            
            KWSticker *sticker = self.kwSdk.presentStickers[indexPath.item - 2];
            
            [((KWStickerCell *)cell) setSticker:sticker index:indexPath.item];
            
        }
        
        if (self.kwSdk.currentPresentStickerIndex == indexPath.item - 2) {
            [((KWStickerCell *)cell) hideBackView:NO];
            
        }else{
            [((KWStickerCell *)cell) hideBackView:YES];
            
        }
    }
    
    return cell;
}

/* UICollectionView被选中时调用的方法 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.stickersCollectionView) {
        
        if (indexPath.item == 1) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"一键下载" message:@"可一键下载所有贴纸哦^_^" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            [alertView show];
            return;
        }
        
        //选中同一个cell不做处理
        if (self.kwSdk.currentStickerIndex == indexPath.item - 2) {
            return;
        }
        
        if (indexPath.item > 1) {
            
            KWSticker *sticker = self.kwSdk.stickers[indexPath.item - 2];
            NSLog(@"已选择%@贴纸",sticker.stickerName);
            
            if (sticker.isDownload == NO) {
                
                
                [[KWStickerDownloadManager sharedInstance] downloadSticker:sticker index:indexPath.item - 2 withAnimation:^(NSInteger index) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index + 2 inSection:0];
                    KWStickerCell *cell = (KWStickerCell*)[self.stickersCollectionView cellForItemAtIndexPath:indexPath];
                    [cell startDownload];
                    
                } successed:^(KWSticker *sticker, NSInteger index) {
                    
                    sticker.downloadState = KWStickerDownloadStateDownoadDone;
                    [self.kwSdk.stickers replaceObjectAtIndex:index withObject:sticker];
                    //回到主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        
                        if (collectionView) {
                            
                            for (NSIndexPath *path in collectionView.indexPathsForVisibleItems) {
                                if (index == path.item) {
                                    [collectionView reloadData];
                                    break;
                                }
                            }
                            
                            
                        }
                        
                        
                    });
                    
                } failed:^(KWSticker *sticker, NSInteger index) {
                    sticker.downloadState = KWStickerDownloadStateDownoadNot;
                    //回到主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectionView reloadData];
                        
                        // TODO: 提示用户网络不给力
                    });
                }];
            
                return;
            }
        }
        
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.kwSdk.currentStickerIndex + 2 inSection:0];
        KWStickerCell *lastCell = (KWStickerCell *)[collectionView cellForItemAtIndexPath:lastPath];
        [lastCell hideBackView:YES];
        
        //渲染指定贴纸
        [self.kwSdk onStickerChanged:indexPath.item - 2];
        //        [self.kwSdk onPresentStickerChanged:indexPath.item - 2];
        
        //显示选中cell的背景
        KWStickerCell *cell = (KWStickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [cell hideBackView:NO];
        
        //不刷新会导致背景框显示错误
        [collectionView reloadItemsAtIndexPaths:@[indexPath,lastPath]];
        
    }else if (collectionView == self.distortionCollectionView) {
        
        [self.kwSdk onDistortionChanged:indexPath.row - 1];
        UICollectionViewCell *defaultCell;
        NSIndexPath *defaultCellIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        defaultCell = [collectionView cellForItemAtIndexPath:defaultCellIndexPath];
        if (defaultCell.isSelected) {
            [defaultCell setSelected:NO];
        }
        
    }else if (collectionView == self.globalBeatifyFilterCollectionView) {
        [self selectFilterAtIndex:indexPath.item];
        
        //选中同一个cell不做处理
        if (self.kwSdk.currentFilterIndex == indexPath.item - 1) {
            return;
        }

        
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.kwSdk.currentFilterIndex + 1 inSection:0];
        KWFilterCell *lastCell = (KWFilterCell *)[collectionView cellForItemAtIndexPath:lastPath];
        [lastCell hideBackView:YES];
        
        [self.kwSdk onFilterChanged:indexPath.row - 1];
        
        
        //显示选中cell的背景
        KWFilterCell *cell = (KWFilterCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [cell hideBackView:NO];
        
        //不刷新会导致背景框显示错误
        [collectionView reloadItemsAtIndexPaths:@[indexPath,lastPath]];
    }
    else if (collectionView == self.presentStickerCollectionView)
    {
        if (indexPath.item == 1) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"一键下载" message:@"可一键下载所有贴纸哦^_^" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"下载", nil];
            [alertView show];
            return;
        }
        
        //选中同一个cell不做处理
        if (self.kwSdk.currentPresentStickerIndex == indexPath.item - 2) {
            return;
        }
        
        if (indexPath.item > 1) {
            
            KWSticker *sticker = self.kwSdk.presentStickers[indexPath.item - 2];
            if (sticker.isDownload == NO) {
                
                
                [[KWStickerDownloadManager sharedInstance] downloadSticker:sticker index:indexPath.item - 2 withAnimation:^(NSInteger index) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index + 2 inSection:0];
                    KWStickerCell *cell = (KWStickerCell*)[self.presentStickerCollectionView cellForItemAtIndexPath:indexPath];
                    [cell startDownload];
                    
                } successed:^(KWSticker *sticker, NSInteger index) {
                    
                    sticker.downloadState = KWStickerDownloadStateDownoadDone;
                    [self.kwSdk.presentStickers replaceObjectAtIndex:index withObject:sticker];
                    //回到主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectionView reloadData];
                        
                    });
                    
                } failed:^(KWSticker *sticker, NSInteger index) {
                    sticker.downloadState = KWStickerDownloadStateDownoadNot;
                    //回到主线程刷新
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [collectionView reloadData];
                        
                        // TODO: 提示用户网络不给力
                    });
                }];
                
                
                return;
            }
        }
        
        //隐藏上次选中cell的背景
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:self.kwSdk.currentPresentStickerIndex + 2 inSection:0];
        KWStickerCell *lastCell = (KWStickerCell *)[collectionView cellForItemAtIndexPath:lastPath];
        [lastCell hideBackView:YES];
        
        //渲染指定贴纸
        //        [self.kwSdk onStickerChanged:indexPath.item - 2];
        [self.kwSdk onPresentStickerChanged:indexPath.item - 2];
        
        //显示选中cell的背景
        KWStickerCell *cell = (KWStickerCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [cell hideBackView:NO];
        
        //不刷新会导致背景框显示错误
        [collectionView reloadItemsAtIndexPaths:@[indexPath,lastPath]];
    }
}


/* 贴纸选择项集合控件 */
- (UICollectionView *)stickersCollectionView
{
    if (!_stickersCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionCell 的大小
        flowLayout.itemSize = CGSizeMake((ScreenWidth_KW)/7, (ScreenWidth_KW)/7);
        //定义每个UICollectionCell 横向的间距
        flowLayout.minimumLineSpacing = 10;
        //定义每个UICollectionCell 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个UICollectionCell 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 20, 40, 20);//上左下右
        
        _stickersCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth_KW, 200) collectionViewLayout:flowLayout];

        //注册cell
        [_stickersCollectionView registerClass:[KWStickerCell class] forCellWithReuseIdentifier:KWStickerCellIdentifier];
        
        //设置代理
        _stickersCollectionView.delegate = self;
        _stickersCollectionView.dataSource = self;
        
        //背景颜色
        _stickersCollectionView.backgroundColor = [UIColor clearColor];
//        _stickersCollectionView.backgroundColor = RGBACOLOR(0, 0, 0, 0.4);

        //自适应大小
        _stickersCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _stickersCollectionView;
}

/* 哈哈镜选择项集合控件 */
- (UICollectionView *)distortionCollectionView
{
    if (!_distortionCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionCell 的大小
        flowLayout.itemSize = CGSizeMake((ScreenWidth_KW)/7, (ScreenWidth_KW)/7);
        //定义每个UICollectionCell 横向的间距
        flowLayout.minimumLineSpacing = 10;
        //定义每个UICollectionCell 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个UICollectionCell 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);//上左下右
        
        _distortionCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_KW, 185) collectionViewLayout:flowLayout];
        
        //注册cell
        [_distortionCollectionView registerClass:[KWDistortionCell class] forCellWithReuseIdentifier:KWDistortionCellIdentifier];
        
        //设置代理
        _distortionCollectionView.delegate = self;
        
        _distortionCollectionView.dataSource = self;
        
        //背景颜色
        _distortionCollectionView.backgroundColor = [UIColor clearColor];
        //自适应大小
        _distortionCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _distortionCollectionView;
}

/* 全局美颜滤镜选择项集合控件*/
- (UICollectionView *)globalBeatifyFilterCollectionView
{
    if (!_globalBeatifyFilterCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        //定义每个UICollectionView 的大小
        flowLayout.itemSize = CGSizeMake((ScreenWidth_KW)/7, (ScreenWidth_KW)/7);
        
        //        flowLayout.itemSize = CGSizeMake(40, 40);
        //定义每个UICollectionView 横向的间距
        flowLayout.minimumLineSpacing = 15;
        
        //定义每个UICollectionView 纵向的间距
        flowLayout.minimumInteritemSpacing = 15;
        
        //定义每个UICollectionView 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(21, 16, 24, 21);//上左下右
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//滑动方向
        
        _globalBeatifyFilterCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_KW, 101) collectionViewLayout:flowLayout];
        
        //注册cell
        [_globalBeatifyFilterCollectionView registerClass:[KWFilterCell class] forCellWithReuseIdentifier:KWFilterCellIdentifier];
        
        //设置代理
        _globalBeatifyFilterCollectionView.delegate = self;
        
        _globalBeatifyFilterCollectionView.dataSource = self;
        
        //背景颜色
        _globalBeatifyFilterCollectionView.backgroundColor = [UIColor clearColor];
        
        //自适应大小
        _globalBeatifyFilterCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _globalBeatifyFilterCollectionView;
}

/*  */
-(UICollectionView *)presentStickerCollectionView
{
    if (!_presentStickerCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        //定义每个UICollectionCell 的大小
        //        flowLayout.itemSize = CGSizeMake(ScreenWidth_KW*(49/ScreenWidth_KW), ScreenWidth_KW*(49/ScreenWidth_KW));
        //        flowLayout.itemSize = CGSizeMake(49, 49);
        flowLayout.itemSize = CGSizeMake((ScreenWidth_KW)/7, (ScreenWidth_KW)/7);
        //定义每个UICollectionCell 横向的间距
        flowLayout.minimumLineSpacing = 10;
        //定义每个UICollectionCell 纵向的间距
        flowLayout.minimumInteritemSpacing = 10;
        //定义每个UICollectionCell 的边距距
        flowLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);//上左下右
        
        _presentStickerCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth_KW, 185) collectionViewLayout:flowLayout];
        
        //注册cell
        [_presentStickerCollectionView registerClass:[KWStickerCell class] forCellWithReuseIdentifier:KWPresentStickerCollectionViewCellIdentifier];
        
        //设置代理
        _presentStickerCollectionView.delegate = self;
        _presentStickerCollectionView.dataSource = self;
        
        //背景颜色
        _presentStickerCollectionView.backgroundColor = [UIColor clearColor];
        _presentStickerCollectionView.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        
        //自适应大小
        _presentStickerCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _presentStickerCollectionView;
}

+ (void)releaseManager
{
    [KWSDK_UI shareManagerUI].currentPopView = nil;
    
    [KWSDK_UI shareManagerUI].NextPopView = nil;
    
    [KWSDK_UI shareManagerUI].currentMainMenuPopView = nil;
    
    [KWSDK_UI shareManagerUI].NextMainMenuPopView = nil;
    
    [KWSDK_UI shareManagerUI].toggleBtn = nil;
    
    [KWSDK_UI shareManagerUI].closeVideoBtn = nil;
    
    [KWSDK_UI shareManagerUI].offPhoneBtn = nil;
    
    [KWSDK_UI shareManagerUI].openStickerSetBtn = nil;
    
    [KWSDK_UI shareManagerUI].openFilterSetBtn = nil;
    
    [KWSDK_UI shareManagerUI].mainMenuView = nil;
    
    [KWSDK_UI shareManagerUI].filterGlobalView = nil;
    
    [KWSDK_UI shareManagerUI].enableFilterParmasBtn = nil;
    
    [KWSDK_UI shareManagerUI].enableBeautifyFilterParmasBtn = nil;
    
    [KWSDK_UI shareManagerUI].beautifyFilterView = nil;
    
    [KWSDK_UI shareManagerUI].sliderEyeMagnifying = nil;
    
    [KWSDK_UI shareManagerUI].sliderChinSlimming = nil;
    
    [KWSDK_UI shareManagerUI].NewBeautifySliderWhitening = nil;
    
    [KWSDK_UI shareManagerUI].NewBeautifySliderMicrodermabrasion = nil;
    
    [KWSDK_UI shareManagerUI].NewBeautifySliderSaturation = nil;
    
    [KWSDK_UI shareManagerUI].NewBeautifySliderPinkistender = nil;
    
    [KWSDK_UI shareManagerUI].beautifyNewView = nil;
    
    [KWSDK_UI shareManagerUI].presentStickerMenuView = nil;
    
    [KWSDK_UI shareManagerUI].stickerMenuView = nil;
    
    [KWSDK_UI shareManagerUI].distortionMenuView = nil;
    
    [KWSDK_UI shareManagerUI].slideBeautifyMenuView = nil;
    
    [KWSDK_UI shareManagerUI].beautifyOptionsBtn = nil;
    
    [KWSDK_UI shareManagerUI].stickerOptionsBtn = nil;
    
    [KWSDK_UI shareManagerUI].distortionOptionsBtn = nil;
    
    [KWSDK_UI shareManagerUI].slideGlobalBeautifyOptionsBtn = nil;
    
    [KWSDK_UI shareManagerUI].pointBtn = nil;
    
    [KWSDK_UI shareManagerUI].beautifyNewBtn = nil;
    
    [KWSDK_UI shareManagerUI].presentStickerBtn = nil;
    
    [KWSDK_UI shareManagerUI].stickersCollectionView = nil;
    
    [KWSDK_UI shareManagerUI].distortionCollectionView = nil;
    
    [KWSDK_UI shareManagerUI].globalBeatifyFilterCollectionView = nil;
    
    [KWSDK_UI shareManagerUI].presentStickerCollectionView = nil;
    
    [KWSDK_UI shareManagerUI].beautifyEnableStateLab = nil;
    
    [KWSDK_UI shareManagerUI].slideBeautifyEnableStateLab = nil;
    
    [KWSDK_UI shareManagerUI].presentSwitchBtn = nil;
    
    [KWSDK_UI shareManagerUI].smiliesSwitchBtn = nil;
    
    [KWSDK_UI shareManagerUI].takePhotoBtn = nil;
    
    [KWSDK_UI shareManagerUI].toggleBtnBlock = nil;
    
    [KWSDK_UI shareManagerUI].closeVideoBtnBlock = nil;
    
    [KWSDK_UI shareManagerUI].actionViewController = nil;
    
    [KWSDK_UI shareManagerUI].previewView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KW_STICKERSLOADED_COMPLETE" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KW_COLORFILTERSLOADED_COMPLETE" object:nil];
    
    
    KWSdkUI = nil;
}

- (void)setCloseBtnEnable:(BOOL) enable
{
    [self.closeVideoBtn setEnabled:enable];
}

-(void)selectFilterAtIndex:(NSInteger)index
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.globalBeatifyFilterCollectionView.collectionViewLayout;
    CGFloat offset = index * (layout.itemSize.width + layout.minimumLineSpacing) - (width - layout.itemSize.width) / 2. + layout.minimumLineSpacing;
    offset = MIN(self.globalBeatifyFilterCollectionView.contentSize.width - width, MAX(0, offset));
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.globalBeatifyFilterCollectionView setContentOffset:CGPointMake(offset, 0) animated:NO];
        }];
    });
    
    
//    CGFloat divideX = (index + 1) * layout.minimumLineSpacing + index * layout.itemSize.width;
//    [UIView animateWithDuration:0.1 animations:^{
//        self.divideView.frame = CGRectMake(divideX, CGRectGetHeight(self.collectionView.frame) - 5, layout.itemSize.width, 5);
//    }];
}


#pragma mark - GestureRecognizer
- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    [self.offPhoneBtn setHighlighted:NO];

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            if ([self.delegate respondsToSelector:@selector(didBeginLongPressOffPhoneButton)]) {
                [self.delegate didBeginLongPressOffPhoneButton];
            }
            
            self.recordCircleView.hidden = NO;
            
            [UIView animateWithDuration:0.4 animations:^{
                              
                self.recordCircleView.transform = CGAffineTransformMakeScale(10, 10);

            }completion:nil];
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            if ([self.delegate respondsToSelector:@selector(didEndLongPressOffPhoneButton)]) {
                [self.delegate didEndLongPressOffPhoneButton];
            }
            
            [UIView animateWithDuration:0.4 animations:^{
                self.recordCircleView.transform = CGAffineTransformIdentity;
                
            }completion:^(BOOL finished) {
                self.recordCircleView.hidden = YES;

            }];
          
        }
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [self popAllView];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KW_STICKERSLOADED_COMPLETE" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"KW_COLORFILTERSLOADED_COMPLETE" object:nil];
    tapView = nil;
    btnBeautify1 = nil;
    btnBeautify2 = nil;
    btnBeautify3 = nil;
    btnBeautify4 = nil;
    
    KWSdkUI = nil;
}

@end
