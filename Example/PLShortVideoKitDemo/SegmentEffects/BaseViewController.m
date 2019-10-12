//
//  BaseViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "BaseViewController.h"
#import <Masonry.h>
#import <sys/utsname.h>

#define PLS_BaseToolboxView_HEIGHT 64

@interface BaseViewController ()
@end

@implementation BaseViewController

- (void)dealloc {
    NSLog(@"[dealloc] %@", self.description);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);
    [self setupBaseToolboxView];
    // Do any additional setup after loading the view.
}

#pragma mark -- 配置视图
- (void)setupBaseToolboxView {
    self.baseToolboxView = [[UIView alloc] init];
    self.baseToolboxView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseToolboxView];
    
    // 关闭按钮
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_a"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"btn_bar_back_b"] forState:UIControlStateHighlighted];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    backButton.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:backButton];
    self.backButton = backButton;
    
    // 标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 100, 64)];
    if (iPhoneX_SERIES) {
        self.titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 48);
    } else {
        self.titleLabel.center = CGPointMake(PLS_SCREEN_WIDTH / 2, 32);
    }
    self.titleLabel.text = @" ";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.baseToolboxView addSubview:self.titleLabel];
    
    
    // 下一步
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setImage:[UIImage imageNamed:@"btn_bar_next_a"] forState:UIControlStateNormal];
    [nextButton setImage:[UIImage imageNamed:@"btn_bar_next_b"] forState:UIControlStateHighlighted];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setTitleColor:PLS_RGBCOLOR(141, 141, 142) forState:UIControlStateHighlighted];
    nextButton.frame = CGRectMake(PLS_SCREEN_WIDTH - 80, 0, 80, 64);
    nextButton.titleEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0);
    nextButton.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    nextButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.baseToolboxView addSubview:nextButton];
    
    [self.baseToolboxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (iPhoneX_SERIES) {
            make.height.equalTo(@(84));
        } else {
            make.height.equalTo(@(PLS_BaseToolboxView_HEIGHT));
        }
    }];
    
    backButton.frame = CGRectMake(0, 0, 80, 64);
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.baseToolboxView);
        make.width.equalTo(@(80));
        make.height.equalTo(@(64));
    }];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.baseToolboxView);
        make.width.equalTo(@(80));
        make.height.equalTo(@(64));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self.baseToolboxView);
        make.left.equalTo(backButton.mas_right);
        make.right.equalTo(nextButton.mas_left);
    }];
    
    self.nextButton = nextButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonClick {
}

-(void)backButtonClick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showWating {
    if (nil == self.activityIndicatorView) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        self.activityIndicatorView.center = self.view.center;
        [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicatorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }

    [self.view addSubview:self.activityIndicatorView];
    if (![self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView startAnimating];
    }
}

- (void)hideWating {
    if ([self.activityIndicatorView isAnimating]) {
        [self.activityIndicatorView stopAnimating];
    }
    [self.activityIndicatorView removeFromSuperview];
    [self.progressLabel removeFromSuperview];
    self.progressLabel.text = @"";
}

- (void)setProgress:(CGFloat)progress {
    if (nil == self.progressLabel) {
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 200, 45)];
        self.progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 30);
        self.progressLabel.textAlignment =  NSTextAlignmentCenter;
        self.progressLabel.textColor = [UIColor whiteColor];
    }
    [self.view addSubview:self.progressLabel];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
}

+ (NSURL *)movieURL:(PHAsset *)phasset {
    
    __block NSURL *url = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:phasset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        url = urlAsset.URL;
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return url;
}

+ (BOOL)checkForPortrait:(CGAffineTransform)transform {
    
    BOOL assetPortrait  = NO;
    
    if(transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0) {
        //is portrait
        assetPortrait = YES;
    }
    else if(transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0) {
        //is portrait
        assetPortrait = YES;
    }
    else if(transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0) {
        //is landscape
    }
    else if(transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0) {
        //is landscape
    }
    
    return assetPortrait;
}

+ (EnumDeviceType)deviceType {

//    https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model/40091083
    
    struct utsname info = {0};
    uname(&info);
    NSString *modelName = [NSString stringWithUTF8String:info.machine];
    if ([modelName isEqualToString:@"iPhone3,1"] ||
        [modelName isEqualToString:@"iPhone3,2"] ||
        [modelName isEqualToString:@"iPhone3,3"]) {
        return enumDeviceTypeIPhone4;
    } else if ([modelName isEqualToString:@"iPhone4,1"]) {
        return enumDeviceTypeIPhone4s;
    } else if ([modelName isEqualToString:@"iPhone5,1"] ||
               [modelName isEqualToString:@"iPhone5,2"]) {
        return enumDeviceTypeIPhone5;
    } else if ([modelName isEqualToString:@"iPhone5,3"] ||
               [modelName isEqualToString:@"iPhone5,4"]) {
        return enumDeviceTypeIPhone5c;
    } else if ([modelName isEqualToString:@"iPhone6,1"] ||
               [modelName isEqualToString:@"iPhone6,2"]) {
        return enumDeviceTypeIPhone5s;
    } else if ([modelName isEqualToString:@"iPhone7,2"]) {
        return enumDeviceTypeIPhone6;
    } else if ([modelName isEqualToString:@"iPhone7,1"]) {
        return enumDeviceTypeIPhone6Plus;
    } else if ([modelName isEqualToString:@"iPhone8,1"]) {
        return enumDeviceTypeIPhone6s;
    } else if ([modelName isEqualToString:@"iPhone8,2"]) {
        return enumDeviceTypeIPhone6sPlus;
    } else if ([modelName isEqualToString:@"iPhone9,1"] ||
               [modelName isEqualToString:@"iPhone9,3"]) {
        return enumDeviceTypeIPhone7;
    } else if ([modelName isEqualToString:@"iPhone9,2"] ||
               [modelName isEqualToString:@"iPhone9,4"]) {
        return enumDeviceTypeIPhone7Plus;
    } else if ([modelName isEqualToString:@"iPhone8,4"]) {
        return enumDeviceTypeIPhoneSE;
    } else if ([modelName isEqualToString:@"iPhone10,1"] ||
               [modelName isEqualToString:@"iPhone10,4"]) {
        return enumDeviceTypeIPhone8;
    } else if ([modelName isEqualToString:@"iPhone10,2"] ||
               [modelName isEqualToString:@"iPhone10,5"]) {
        return enumDeviceTypeIPhone8Plus;
    } else if ([modelName isEqualToString:@"iPhone10,3"] ||
               [modelName isEqualToString:@"iPhone10,6"]) {
        return enumDeviceTypeIPhoneX;
    } else if ([modelName isEqualToString:@"iPhone11,2"]) {
        return enumDeviceTypeIPhoneXS;
    } else if ([modelName isEqualToString:@"iPhone11,4"] ||
               [modelName isEqualToString:@"iPhone11,6"]) {
        return enumDeviceTypeIPhoneXSMax;
    } else if ([modelName isEqualToString:@"iPhone11,8"]) {
        return enumDeviceTypeIPhoneXR;
    }
    
    return enumDeviceTypeIPhone8;
}
@end
