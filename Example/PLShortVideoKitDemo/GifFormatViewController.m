//
//  GifFormatViewController.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/7/31.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "GifFormatViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"
#import "PLSFormatGifView.h"
#import <Masonry/Masonry.h>
#import "PlayViewController.h"

#define PLS_BaseToolboxView_HEIGHT 64

@interface GifFormatViewController ()<PLSFormatGifViewDelegate>

@property (strong, nonatomic) UIView *baseToolboxView;
@property (strong, nonatomic) PLSFormatGifView *formatGifView;
@property (strong, nonatomic) UIView *gifPreview;
@property (strong, nonatomic) NSArray *selectedArray;
@property (strong, nonatomic) UIButton *nextButton;
@end

@implementation GifFormatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);

    [self setupBaseToolboxView];
    [self setupFormatGifView];

}

#pragma mark -- 配置视图
- (void)setupBaseToolboxView {
    self.baseToolboxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_BaseToolboxView_HEIGHT)];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    // 关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.frame = CGRectMake(0, 0, 80, 64);
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 64)];
    if (iPhoneX_SERIES) {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 48);
    } else {
        titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    }
    titleLabel.text = @"制作 Gif";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.baseToolboxView addSubview:titleLabel];
    
    // 下一步
    self.nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton.enabled = NO;
    [self.nextButton setImage:[UIImage imageNamed:@"btn_bar_next_a"] forState:UIControlStateNormal];
    [self.nextButton setImage:[UIImage imageNamed:@"btn_bar_next_b"] forState:UIControlStateDisabled];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nextButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateDisabled];
    self.nextButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    self.nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    self.nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:_nextButton];
}

- (void)setupFormatGifView {
    CGFloat duration = CMTimeGetSeconds(_asset.duration);
    // 这里视频时长最短应为 2 秒，因为截取视频帧是间隔 1 秒取一张，若为 0，则用于合成 Gif 的图片数组只有一张图片，不符合合成 Gif 动图必须要 2 张以上图片的要求，而 2 秒的视频可保证有 2 张图片可用。
    self.formatGifView = [[PLSFormatGifView alloc] initWithMovieAsset:_asset minDuration:2.f maxDuration:duration];
    self.formatGifView.delegate = self;
    [self.view addSubview:self.formatGifView];
    [self.formatGifView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(64);
        make.height.mas_equalTo(PLS_SCREEN_HEIGHT - 64);
    }];
}

#pragma mark -- PLSFormatGifView delegate
- (void)formatGifView:(PLSFormatGifView *)formatGifView selectedArray:(NSArray *)selectedArray{
    self.selectedArray = selectedArray;
    if (_selectedArray.count < 2) {
        _nextButton.enabled = NO;
    } else {
        _nextButton.enabled = YES;
    }
}
- (void)formatGifView:(PLSFormatGifView *)formatGifView previewArray:(NSArray *)previewArray{
    self.selectedArray = previewArray;
    PLSGifComposer *gifComposer = [[PLSGifComposer alloc] initWithImagesArray:previewArray];
    gifComposer.interval = 0.1;
    UIImage *img = previewArray[0];
    
    self.gifPreview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, PLS_SCREEN_WIDTH, PLS_SCREEN_HEIGHT)];
    self.gifPreview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    [self.view addSubview:_gifPreview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePreviewTap)];
    [self.gifPreview addGestureRecognizer:tap];
    
    [gifComposer loadGifWithFrame:CGRectMake(32, 32, PLS_SCREEN_WIDTH - 64, img.size.height/img.size.width * PLS_SCREEN_WIDTH - 64) superView:self.gifPreview repeatCount:0];
}

- (void)closePreviewTap {
    [self.gifPreview removeFromSuperview];
}

#pragma mark -- UIButton 按钮响应事件
#pragma mark -- 返回
- (void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    __weak typeof(self) weakSelf = self;

    PLSGifComposer *gifComposer = [[PLSGifComposer alloc] initWithImagesArray:_selectedArray];
    gifComposer.gifName = nil; // 为 nil 时，SDK 内部会生成相应的唯一名称。gifComposer.gifName = @"myGif"
    gifComposer.interval = 0.1;
    
    [gifComposer setCompletionBlock:^(NSURL *url){
        NSLog(@"compose Gif successed");
        [weakSelf joinNextViewControllerWithGifUrl:url imagesArray:_selectedArray object:weakSelf];
    }];
    
    [gifComposer setFailureBlock:^(NSError *error){
        NSLog(@"compose Gif failed: %@", error);
    }];
    
    [gifComposer composeGif];
}

- (void)joinNextViewControllerWithGifUrl:(NSURL *)url imagesArray:(NSArray *)imagesArray object:(id)obj {
    PlayViewController *playViewController = [[PlayViewController alloc]init];
    playViewController.actionType = PLSActionTypeGif;
    playViewController.url = url;
    playViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [obj presentViewController:playViewController animated:YES completion:nil];
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    self.formatGifView.delegate = nil;
    self.formatGifView = nil;
    
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
