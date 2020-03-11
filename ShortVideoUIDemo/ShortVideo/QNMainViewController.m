//
//  QNMainViewController.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNMainViewController.h"

#import "QNRecordingViewController.h"         // 拍摄
#import "QNTranscodeViewController.h"         // 转码
#import "QNMixRecordingViewController.h"      // 合拍
#import "QNPuzzleViewController.h"            // 视频拼图
#import "QNFunctionViewController.h"          // 功能清单
#import "QNSettingsViewController.h"          // 参数配置

// 相册获取
#import "QBImagePickerController.h"
#import "QNPhotoCollectionViewController.h"

// banners
#import "QNProductViewController.h"
#import "QNDocumentViewController.h"

#define QN_MAIN_BUTTON_SIZE 78.0

typedef enum : NSUInteger {
    QNActionTypeEdit,
    QNActionTypeMixRecording,
} QNActionType;

@interface QNMainViewController ()
<
QBImagePickerControllerDelegate,
SDCycleScrollViewDelegate
>

@property (nonatomic, strong) UIImpactFeedbackGenerator *clickFeedback;
@property (nonatomic, assign) QNActionType action;

@property (nonatomic, strong) SDCycleScrollView *bannerScrollView;
@property (nonatomic, strong) UIPageControl *pageController;

@property (nonatomic, strong) NSMutableArray *defaultArrays;
@property (nonatomic, strong) NSArray *infoNames;
@end

@implementation QNMainViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-  (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.infoNames = [NSMutableArray arrayWithArray:[self getSettingInfos]];
    self.defaultArrays = [NSMutableArray arrayWithArray:[self configureGlobalSettings]];
    
    if (@available(iOS 10.0, *)) {
        self.clickFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
        [self.clickFeedback prepare];
    }
    
    [self layoutInfoView];
    
    [self layoutButtonsView];
}

#pragma mark - info view layout

- (void)layoutInfoView {
    
    CGFloat space = 26;
    if (QN_iPhoneX || QN_iPhoneXR || QN_iPhoneXSMAX) {
        space = 42;
    }
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);

    NSArray *imageNames = @[@"qn_banner01",@"qn_banner02"];
    
    self.bannerScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, space, viewWidth, 0.9 * viewWidth) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    self.bannerScrollView.delegate = self;
    self.bannerScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    [self.view addSubview:_bannerScrollView];
    self.bannerScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.bannerScrollView.autoScrollTimeInterval = 1.5;
    self.bannerScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qn_logo"]];
    logoImageView.frame = CGRectMake(20, 26 + space, 83, 22);
    [self.view addSubview:logoImageView];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 54, 20 + space, 34, 34)];
    [settingButton setImage:[UIImage imageNamed:@"qn_main_setting"] forState:(UIControlStateNormal)];
    [settingButton addTarget:self action:@selector(clickSettingButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:settingButton];
    
    UIImageView *fengeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qn_fenge"]];
    CGFloat fengeHeight = 0.112 * viewWidth;
    fengeImageView.frame = CGRectMake(0, CGRectGetHeight(self.bannerScrollView.frame) + space - fengeHeight, viewWidth, fengeHeight);
    [self.view addSubview:fengeImageView];
}

#pragma mark - button view layout

- (void)layoutButtonsView {
    
    // 拍摄
    UIButton *recordingButton = [[UIButton alloc] init];
    recordingButton.adjustsImageWhenHighlighted = NO;
    [recordingButton setBackgroundImage:[UIImage imageNamed:@"qn_main_camera"] forState:(UIControlStateNormal)];
    [recordingButton addTarget:self action:@selector(clickRecordingButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:recordingButton];


    // 编辑
    UIButton *videoEditButton = [[UIButton alloc] init];
    videoEditButton.adjustsImageWhenHighlighted = NO;
    [videoEditButton setBackgroundImage:[UIImage imageNamed:@"qn_main_edit"] forState:(UIControlStateNormal)];
    [videoEditButton addTarget:self action:@selector(clickVideoEditButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:videoEditButton];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGSize buttonSize = CGSizeMake((viewWidth - 78)/2, 0.6 *(viewWidth - 78)/2);
    
    CGFloat ratio = 0.6;
    if (QN_iPhoneX || QN_iPhoneXR) {
        ratio = 0.8;
    } else if (QN_iPhoneXSMAX) {
        ratio = 1.0;
    }
    
    [recordingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.left.equalTo(self.view.mas_left).offset(26);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100 * ratio);
    }];

    [videoEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(buttonSize);
        make.right.equalTo(self.view.mas_right).offset(-26);
        make.bottom.equalTo(self.view.mas_bottom).offset(-100 * ratio);
    }];

    
    // 合拍
    UIButton *mixRecordingButton = [[UIButton alloc] init];
    mixRecordingButton.adjustsImageWhenHighlighted = NO;
    [mixRecordingButton setBackgroundImage:[UIImage imageNamed:@"qn_main_merge"] forState:(UIControlStateNormal)];
    [mixRecordingButton addTarget:self action:@selector(mixRecordingButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:mixRecordingButton];

    UILabel *mixRecordingLabel = [[UILabel alloc] init];
    mixRecordingLabel.font = [UIFont systemFontOfSize:14];
    mixRecordingLabel.textAlignment = NSTextAlignmentCenter;
    mixRecordingLabel.textColor = [UIColor blackColor];
    mixRecordingLabel.text = @"素材合拍";
    [self.view addSubview:mixRecordingLabel];
    
    // 拼图
    UIButton *puzzleButton = [[UIButton alloc] init];
    puzzleButton.adjustsImageWhenHighlighted = NO;
    [puzzleButton setBackgroundImage:[UIImage imageNamed:@"qn_main_puzzle"] forState:(UIControlStateNormal)];
    [puzzleButton addTarget:self action:@selector(clickPuzzleButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:puzzleButton];

    UILabel *puzzleLabel = [[UILabel alloc] init];
    puzzleLabel.font = [UIFont systemFontOfSize:14];
    puzzleLabel.textAlignment = NSTextAlignmentCenter;
    puzzleLabel.textColor = [UIColor blackColor];
    puzzleLabel.text = @"视频拼图";
    [self.view addSubview:puzzleLabel];
    
    
    // 拼接
    UIButton *appendButton = [[UIButton alloc] init];
    appendButton.adjustsImageWhenHighlighted = NO;
    [appendButton setBackgroundImage:[UIImage imageNamed:@"qn_main_append"] forState:(UIControlStateNormal)];
    [appendButton addTarget:self action:@selector(clickAppendButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:appendButton];

    UILabel *appendLabel = [[UILabel alloc] init];
    appendLabel.font = [UIFont systemFontOfSize:14];
    appendLabel.textAlignment = NSTextAlignmentCenter;
    appendLabel.textColor = [UIColor blackColor];
    appendLabel.text = @"素材拼接";
    [self.view addSubview:appendLabel];
    
    
    // 清单
    UIButton *featureButton = [[UIButton alloc] init];
    featureButton.adjustsImageWhenHighlighted = NO;
    [featureButton setBackgroundImage:[UIImage imageNamed:@"qn_main_list"] forState:(UIControlStateNormal)];
    [featureButton addTarget:self action:@selector(clickFeatureButton:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:featureButton];

    UILabel *featureLabel = [[UILabel alloc] init];
    featureLabel.font = [UIFont systemFontOfSize:14];
    featureLabel.textAlignment = NSTextAlignmentCenter;
    featureLabel.textColor = [UIColor blackColor];
    featureLabel.text = @"功能清单";
    [self.view addSubview:featureLabel];
    
    int widthValue = (self.view.bounds.size.width - 52 - 60) / 4;
    CGSize size = CGSizeMake(widthValue, widthValue);
    
    CGFloat ratioSpace = 0.75;
    if (QN_iPhoneX || QN_iPhoneXR) {
        ratioSpace = 0.8;
    } else if (QN_iPhoneP) {
        ratioSpace = 0.85;
    } else if (QN_iPhoneXSMAX) {
        ratioSpace = 1.0;
    }

    // Masonry layout
    [mixRecordingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(size);
        make.left.equalTo(self.view.mas_left).offset(26);
        make.top.equalTo(self.view.mas_top).offset(500 * ratioSpace);
    }];

    [mixRecordingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(mixRecordingButton);
        make.top.equalTo(mixRecordingButton.mas_bottom).offset(6);
    }];
    
    [puzzleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(size);
        make.left.equalTo(mixRecordingButton.mas_right).offset(20);
        make.centerY.equalTo(mixRecordingButton.centerY);
    }];

    [puzzleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(puzzleButton);
        make.top.equalTo(puzzleButton.mas_bottom).offset(6);
    }];
    
    [appendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(size);
        make.left.equalTo(puzzleButton.mas_right).offset(20);
        make.centerY.equalTo(puzzleButton.centerY);
    }];

    [appendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(appendButton);
        make.top.equalTo(appendButton.mas_bottom).offset(6);
    }];

    [featureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(size);
        make.right.equalTo(self.view.mas_right).offset(-26);
        make.centerY.equalTo(appendButton.centerY);
    }];

    [featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(featureButton);
        make.top.equalTo(featureButton.mas_bottom).offset(6);
    }];
}

#pragma mark - button action

// 拍摄
- (void)clickRecordingButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];
    QNRecordingViewController *recordingController = [[QNRecordingViewController alloc] init];
    recordingController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:recordingController animated:YES completion:nil];
}

// 转码编辑
- (void)clickVideoEditButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];
    
    self.action = QNActionTypeEdit;
    [self showImagePickerWithMediaType:(QBImagePickerMediaTypeVideo) maxSelectedCount:1 minSelectedCount:1];
}

// 合拍
- (void)mixRecordingButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];
    
    self.action = QNActionTypeMixRecording;
    [self showImagePickerWithMediaType:(QBImagePickerMediaTypeVideo) maxSelectedCount:1 minSelectedCount:1];
}

// 视频拼图
- (void)clickPuzzleButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];

    QNPuzzleViewController *puzzleController = [[QNPuzzleViewController alloc] init];
    puzzleController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:puzzleController animated:YES completion:nil];
}

// 素材拼接
- (void)clickAppendButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];

    QNPhotoCollectionViewController *photoViewController = [[QNPhotoCollectionViewController alloc] init];
    photoViewController.mediaType = PHAssetMediaTypeVideo;
    photoViewController.maxSelectCount = 10;
    photoViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoViewController animated:YES completion:nil];
}

// 功能清单
- (void)clickFeatureButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];

    QNFunctionViewController *functionController = [[QNFunctionViewController alloc] init];
    functionController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:functionController animated:YES completion:nil];
}

// 参数配置
- (void)clickSettingButton:(UIButton *)button {
    [self.clickFeedback impactOccurred];
    [self.clickFeedback prepare];
    
    QNSettingsViewController *settingsController = [[QNSettingsViewController alloc] init];
    settingsController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:settingsController animated:YES completion:nil];
}

#pragma mark - SDCycleScrollViewDelegate

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    if (index == 0) {
        QNProductViewController *productViewController = [[QNProductViewController alloc] init];
        productViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:productViewController animated:YES completion:nil];
    }
    if (index == 1) {
        QNDocumentViewController *documentViewController = [[QNDocumentViewController alloc] init];
        documentViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:documentViewController animated:YES completion:nil];
    }
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
    
}

#pragma mark - QBImagePickerController

- (void)showImagePickerWithMediaType:(QBImagePickerMediaType)mediaType maxSelectedCount:(NSUInteger)maxCount minSelectedCount:(NSUInteger)minCount {
    QBImagePickerController *picker = [[QBImagePickerController alloc] init];
    picker.delegate = self;
    picker.mediaType = mediaType;
    picker.allowsMultipleSelection = maxCount > 1;
    picker.showsNumberOfSelectedAssets = YES;
    picker.maximumNumberOfSelection = maxCount;
    picker.minimumNumberOfSelection = minCount;

    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (QNActionTypeEdit == self.action) {
            [self gotoTranscodeController:assets.firstObject];
        } else if (QNActionTypeMixRecording == self.action) {
            [self gotoMixRecorderController:assets.firstObject];
        }
    }];
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - enter controller

- (void)gotoTranscodeController:(PHAsset *)phAsset {
    QNTranscodeViewController *transcodeController = [[QNTranscodeViewController alloc] init];
    transcodeController.phAsset = phAsset;
    transcodeController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:transcodeController animated:YES completion:nil];
}

- (void)gotoMixRecorderController:(PHAsset *)phAsset {
    
    NSURL *url = [QNBaseViewController movieURL:phAsset];
    if (!url) {
        [self showAlertMessage:@"错误" message:@"获取视频地址失败"];
        return;
    }
    
    QNMixRecordingViewController *mixRecordViewController = [[QNMixRecordingViewController alloc] init];
    mixRecordViewController.mixURL = url;
    mixRecordViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mixRecordViewController animated:YES completion:nil];
}

@end
