//
//  QNProductViewController.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/18.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNProductViewController.h"

@interface QNProductViewController ()
<
UIWebViewDelegate
>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation QNProductViewController

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    self.URL = [NSURL URLWithString:@"https://www.qiniu.com/products/plsv"];
     
    CGFloat space = 26;
    CGFloat topSpace = 24;

    if (QN_iPhoneX || QN_iPhoneXR || QN_iPhoneXSMAX) {
        space += 30;
        topSpace = 20;
    }
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, space, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - space)];
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:_URL]];
    [self.view addSubview:_webView];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, topSpace, 36, 36)];
    self.backButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    self.backButton.layer.cornerRadius = 18;
    [self.backButton setImage:[UIImage imageNamed:@"qn_icon_close"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self showWating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideWating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self hideWating];
    
    if (error) {
        [self showAlertMessage:@"错误" message:error.localizedDescription];
    }
}

#pragma mark - get back

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
