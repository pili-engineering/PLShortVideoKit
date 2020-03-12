//
//  QNFunctionViewController.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/7/12.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNFunctionViewController.h"

#define QN_DESCR_HEIGHT 112

@interface QNFunctionViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation QNFunctionViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}

- (void)setupUI {
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    
    CGFloat topSpace = 24;
    if (iPhoneX_SERIES) {
        topSpace = 42;
    }
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, topSpace, 36, 36)];
    self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.backButton.layer.cornerRadius = 18;
    [self.backButton setImage:[UIImage imageNamed:@"qn_icon_close"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    self.titleLabel.center = CGPointMake(self.view.center.x, self.backButton.center.y);
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:2];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"短视频功能";
    [self.view addSubview:_titleLabel];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(16, topSpace + 46, viewWidth - 32, viewHeight - (topSpace + 46 + 10))];
    self.scrollView.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_scrollView];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth - 32, QN_DESCR_HEIGHT)];
    self.descLabel.font = [UIFont systemFontOfSize:14];
    self.descLabel.textColor = [UIColor blackColor];
    self.descLabel.text = @"七牛短视频 SDK，方便开发者快速实现短视频拍摄、剪辑、编辑、合成、分发等功能。\n\n目前主要区分精简版、基础版、进阶版、专业版 4 个版本，不同版本的功能区别见如下表格。";
    self.descLabel.numberOfLines = 0;
    [self.scrollView addSubview:_descLabel];
   
    CGFloat scrollHeight = CGRectGetHeight(self.scrollView.frame);
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, QN_DESCR_HEIGHT, viewWidth - 36, scrollHeight - QN_DESCR_HEIGHT)];
    [self.scrollView addSubview:_imageView];

    NSURL *imageURL = [NSURL URLWithString:@"http://pab2071yd.bkt.clouddn.com/qn_shortvideo_function.png"];
    [self setImageWithURL:imageURL];
}

- (void)setImageWithURL:(NSURL *)imageURL {
    [_imageView sd_setImageWithURL:imageURL placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (error) {
            NSLog(@"set images error!");
        } else{
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat width = CGRectGetWidth(self.imageView.frame);
                CGFloat height = image.size.height/image.size.width * width;
                self.imageView.frame = CGRectMake(0, QN_DESCR_HEIGHT, width, height);
                self.scrollView.contentSize = CGSizeMake(0, QN_DESCR_HEIGHT + height);
            });
        }
    }];
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
