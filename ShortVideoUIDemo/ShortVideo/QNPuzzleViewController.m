//
//  QNPuzzleViewController.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/13.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNPuzzleViewController.h"
#import "QNPhotoCollectionViewController.h"
#import "QNGradientView.h"

@interface QNPuzzleViewController ()

@property (nonatomic, strong) QNGradientView *gradientBar;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *mulitMixButton;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) UIButton *mix2Button;
@property (nonatomic, strong) UIButton *mix3Button;
@property (nonatomic, strong) UIButton *mix4Button;

@property (nonatomic, strong) UILabel *mulitMixLabel;
@property (nonatomic, strong) UILabel *recordingMixLabel;

@end

@implementation QNPuzzleViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupTitleBar];
    
    [self pressMulitMixButtonEvent];
}

- (void)setupTitleBar {
    self.gradientBar = [[QNGradientView alloc] init];
    self.gradientBar.gradienLayer.colors = @[(__bridge id)[[UIColor colorWithWhite:0 alpha:.8] CGColor], (__bridge id)[[UIColor clearColor] CGColor]];
    [self.view addSubview:self.gradientBar];
    [self.gradientBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.mas_topLayoutGuide).offset(50);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [backButton setTintColor:UIColor.whiteColor];
    [backButton setImage:[UIImage imageNamed:@"qn_icon_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(getBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.gradientBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 44));
        make.left.bottom.equalTo(self.gradientBar);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor lightTextColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"选择拼图样式";
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.titleLabel sizeToFit];
    [self.gradientBar addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.gradientBar);
        make.centerY.equalTo(backButton);
    }];
}

- (void)pressMulitMixButtonEvent {
    UIImage *image = [UIImage imageNamed:@"qn_2video_template"];
    self.mix2Button = [[UIButton alloc] init];
    _mix2Button.tag = 102;
    [_mix2Button setImage:image forState:(UIControlStateNormal)];
    [_mix2Button sizeToFit];
    _mix2Button.center = CGPointMake(self.view.center.x, self.view.center.y - 1.5 * image.size.height);
    [_mix2Button addTarget:self action:@selector(pressMixButton:) forControlEvents:UIControlEventTouchDown];
    
    image = [UIImage imageNamed:@"qn_3video_template"];
    _mix3Button = [[UIButton alloc] init];
    _mix3Button.tag = 103;
    [_mix3Button setImage:image forState:(UIControlStateNormal)];
    [_mix3Button sizeToFit];
    _mix3Button.center = self.view.center;
    [_mix3Button addTarget:self action:@selector(pressMixButton:) forControlEvents:UIControlEventTouchDown];
    
    image = [UIImage imageNamed:@"qn_4video_template"];
    _mix4Button = [[UIButton alloc] init];
    _mix4Button.tag = 104;
    [_mix4Button setImage:image forState:(UIControlStateNormal)];
    [_mix4Button sizeToFit];
    _mix4Button.center = CGPointMake(self.view.center.x, self.view.center.y + 1.5 * image.size.height);
    [_mix4Button addTarget:self action:@selector(pressMixButton:) forControlEvents:UIControlEventTouchDown];
   
    [self.view addSubview:self.mix2Button];
    [self.view addSubview:self.mix3Button];
    [self.view addSubview:self.mix4Button];
}

- (void)pressMixButton:(UIButton *)button {
    QNPhotoCollectionViewController *photoController = [[QNPhotoCollectionViewController alloc] init];
    photoController.typeIndex = 1;
    photoController.maxSelectCount = button.tag - 100;
    photoController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:photoController animated:YES completion:nil];
}

- (void)getBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
