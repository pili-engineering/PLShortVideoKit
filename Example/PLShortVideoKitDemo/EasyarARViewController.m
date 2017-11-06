//
//  EasyarARViewController.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/10/25.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#ifndef EASYAR_PRO 
#define EASYAR_PRO 
#endif

#ifdef EASYAR_PRO
#define EASYAR_RECORD_ENABLED 1
#endif

#import "EasyarARViewController.h"
#import "EditViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"

#import "ARWebViewController.h"
#import "easyar3d/EasyARScene.h"
#import "easyar3d/player_recorder.oc.h"

#import "SPARManager.h"
#import "SPARPackage.h"
#import "SPARApp.h"
#import "PLSLoadAnimationView.h"

#define kButtenWidth 34
#define kButtenHeigh 34
#define ARScene (EasyARScene *)self.view

#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

#define PLS_SCREEN_WIDTH CGRectGetWidth([UIScreen mainScreen].bounds)
#define PLS_SCREEN_HEIGHT CGRectGetHeight([UIScreen mainScreen].bounds)

NSString *serverAddr = @"http://copapi.easyar.cn";
NSString *appKey = @"cd48a9265b666690c072cefb187dc1c3";
NSString *appSecret = @"ccdb6314b418829ef65fbfb3b14c8e30eee13f1f6a5370c5cc43955116c0001d";


@interface EasyarARViewController ()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shotButton;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *centerButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) PLSLoadAnimationView *downLoadAniView;

@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) easyar_PlayerRecorder *easyarRecorder;

@end

@implementation EasyarARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    EasyARScene *easyARSceneview = [[EasyARScene alloc] initWithFrame:self.view.bounds];
    [easyARSceneview setFPS:60];
    self.view = easyARSceneview;
    
    self.downLoadAniView = [[PLSLoadAnimationView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.downLoadAniView.center = self.view.center;
    [self.view addSubview:_downLoadAniView];
    self.downLoadAniView.hidden = YES;

    [self loadScene:@"scene"];
    __weak EasyarARViewController *myself = self;
    [ARScene setMessageReceiver:^(NSString *name, NSArray<NSString *> *params) {
        [myself messageReceiverWith:name parms:params];
    }];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    self.backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 24, kButtenWidth, kButtenHeigh)];
    self.backButton.layer.cornerRadius = kButtenHeigh/2;
    self.backButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.hidden = YES;
    [self.view addSubview:_backButton];
    
    self.centerButton = [[UIButton alloc]initWithFrame:CGRectMake(kButtenWidth + 25 , 24, kButtenWidth * 2, kButtenHeigh)];
    self.centerButton.layer.cornerRadius = kButtenHeigh/2;
    self.centerButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.centerButton.titleLabel.textColor = [UIColor whiteColor];
    [self.centerButton setTitle:@"居中" forState:UIControlStateNormal];
    [self.centerButton addTarget:self action:@selector(centerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.centerButton.hidden = YES;
    [self.view addSubview:_centerButton];
    
    self.cameraButton = [[UIButton alloc]initWithFrame:CGRectMake(kButtenWidth * 3 + 35, 24, kButtenWidth, kButtenHeigh)];
    self.cameraButton.layer.cornerRadius = kButtenHeigh/2;
    self.cameraButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.cameraButton setImage:[UIImage imageNamed:@"toggle_camera"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.cameraButton.hidden = YES;
    [self.view addSubview:_cameraButton];
    
    self.shotButton = [[UIButton alloc]initWithFrame:CGRectMake(kButtenWidth * 4 + 50, 24, kButtenWidth * 2, kButtenHeigh)];
    self.shotButton.layer.cornerRadius = kButtenHeigh/2;
    self.shotButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.shotButton.titleLabel.textColor = [UIColor whiteColor];
    [self.shotButton setTitle:@"截图" forState:UIControlStateNormal];
    [self.shotButton addTarget:self action:@selector(shotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.shotButton.hidden = YES;
    [self.view addSubview:_shotButton];
    
    self.nextButton = [[UIButton alloc]initWithFrame:CGRectMake(PLS_SCREEN_WIDTH - kButtenWidth * 2 - 10, 24, kButtenWidth * 2, kButtenHeigh)];
    self.nextButton.layer.cornerRadius = kButtenHeigh/2;
    self.nextButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.nextButton.titleLabel.textColor = [UIColor whiteColor];
    [self.nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.hidden = YES;
    [self.view addSubview:_nextButton];
    
    self.started = NO;
    
    self.recordButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.recordButton .frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-50, 70, 50);
    [self.recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [self.recordButton setTitle:@"Stop" forState:UIControlStateSelected];
    self.recordButton .backgroundColor = [UIColor yellowColor];
    self.recordButton .hidden = YES;
    [self.recordButton  addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_recordButton];
}

- (void)loadScene:(NSString*)path{
    NSString * fName = [[NSBundle mainBundle] pathForResource:path ofType:@"js"];
    EasyARScene* scene = (EasyARScene*)self.view;
    if (scene != NULL) {
        [scene setMessageReceiver:^(NSString * name, NSArray<NSString *> * params) {
            (void)name;
            (void)params;
        }];
        [scene loadJavaScript:path content:[NSString stringWithContentsOfFile: fName usedEncoding:nil error:nil]];
    }
}

- (void)messageReceiverWith:(NSString *)name parms:(NSArray *)array {
    if ([name isEqualToString:@"request:JsNativeBinding.openWebView"]) {
        NSLog(@"response:JsNativeBinding.openWebView %@",array);
        [self JSMeaasgeOpenWebView:array[0]];
    } else if ([name isEqualToString:@"response:JsNativeBinding.getCameraDeviceType"]) {
        NSLog(@"response:JsNativeBinding.getCameraDeviceType %@",array);
    } else if ([name isEqualToString:@"request:JsNativeBinding.targetLost"]) {
        NSLog(@"response:JsNativeBinding.targetLost %@",array);
    } else if ([name isEqualToString:@"request:JsNativeBinding.targetFound"]) {
        NSLog(@"response:JsNativeBinding.targetFound %@",array);
        [self showFinding];
    } else if ([name isEqualToString:@"request:JsNativeBinding.showNativeButton"]) {
        NSLog(@"request:JsNativeBinding.showNativeButton %@",array);
    } else if ([name isEqualToString:@"request:JsNativeBinding.closeNativeButton"]) {
        NSLog(@"request:JsNativeBinding.closeNativeButton %@",array);
        [self showLoast];
    } else if ([name isEqualToString:@"request:JsNativeBinding.openView"]) {
        NSLog(@"request:JsNativeBinding.openView %@",array);
    }else if ([name isEqualToString:@"request:JsNativeBinding.getMetaData"]) {
        //        NSLog(@"request:JsNativeBinding.getMetaData %@",array);
    }else if ([name isEqualToString:@"request:JsNativeBinding.FinishLoading"]) {
        [self showUntracking];
        [ARScene sendMessage:@"request:NativeJsBinding.showARWithTrack" params:@[]];
    }else {
        NSLog(@"name error %@",name);
    }
}

#pragma mark - JS Message Use
- (void)JSMeaasgeOpenWebView:(NSString *)url {
    ARWebViewController *arwebVC = [ARWebViewController new];
    arwebVC.url = url;
    UINavigationController* navi = [[UINavigationController alloc] initWithRootViewController:arwebVC];
    [self presentViewController:navi animated:YES completion:nil];
}

#pragma mark - showUI type
- (void)showUntracking {
    NSLog(@"AR View type showUntracking");
    [self hideButtonsWithHidden:NO];
}

- (void)showFinding {
    NSLog(@"AR View type showFinding");
    [self hideButtonsWithHidden:NO];
}
- (void)showLoast {
    NSLog(@"AR View type showLoast");
    [self hideButtonsWithHidden:YES];
}

- (void)hideButtonsWithHidden:(BOOL)hidden {
    self.shotButton.hidden = hidden;
    self.backButton.hidden = hidden;
    self.recordButton.hidden = hidden;
    self.centerButton.hidden = hidden;
    self.cameraButton.hidden = hidden;
}

- (void)loadARID:(NSString*)arid{
    SPARManager *sparMan = [SPARManager sharedManager];
    [sparMan setServerAddress:serverAddr];
    [sparMan setServerAccessTokens:appKey secret:appSecret];
    
    __weak EasyarARViewController * weak_self = self;
    [sparMan loadApp:arid completionHandler:^(SPARApp *app, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Error: ----%@", error);
            } else {
                NSString* manifestURL = [app.package getManifestURL];
                NSLog(@"%@", manifestURL);
                [(EasyARScene*)weak_self.view loadManifest:manifestURL];
            }
        });
    } progressHandler:^(NSString *taskName, float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"<<<<%@: %.2f%%", taskName, progress * 100);
            if ([taskName isEqualToString:@"Download"]) {
                [weak_self showFinding];
                weak_self.downLoadAniView.hidden = NO;
                weak_self.downLoadAniView.centerLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
            }
            if (progress == 1) {
                weak_self.downLoadAniView.hidden = YES;
            }
        });
    }];
}

- (void)loadManifest:(NSString*)targetDesc{
    if (targetDesc == nil) {
        return;
    }
    
    __weak EasyarARViewController * weak_self = self;
    SPARManager *sparMan = [SPARManager sharedManager];
    SPARApp *app = [sparMan getAppByTargetDesc:targetDesc];
    [app deployPackage:NO completionHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"Error: %@", error);
                return;
            }
            [(EasyARScene*)weak_self.view loadManifest:[app.package getManifestURL]];
        });
    } progressHandler:^(NSString *taskName, float progress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@: %.2f%%", taskName, progress * 100);
            if ([taskName isEqualToString:@"Download"]) {
                [weak_self showFinding];
                weak_self.downLoadAniView.hidden = NO;
                weak_self.downLoadAniView.centerLabel.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
            }
            if (progress == 1) {
                weak_self.downLoadAniView.hidden = YES;
            }
        });
    }];
}

#pragma mark - ButtonActive
- (void)scanLineViewBackButton:(UIButton *)button {
    NSLog(@"scanLineViewBackButton");
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)backButtonClick:(UIButton *)button {
    if (!_easyarRecorder) {
        [_easyarRecorder close];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shotButtonClick:(UIButton *)button {
    [self snapShot];
}

- (void)snapShot{
    [(EasyARScene*)self.view snapshot:^(UIImage *image) {
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
    } failed:^(NSString *msg) {
        NSLog(@"Error: %@", msg);
    }];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSLog(@"保存图片到相册 image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}

- (void)centerButtonClick:(UIButton *)button {
    [ARScene sendMessage:@"request:NativeJsBinding.resetContent" params:@[]];
}

- (void)cameraButtonClick:(UIButton *)button {
    [ARScene sendMessage:@"request:NativeJsBinding.changeCameraDeviceType" params:@[]];
}

- (void)fail {
    [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
    _started = NO;
    _url = nil;
    if (_easyarRecorder != nil) {
        _easyarRecorder = nil;
    }
}

#pragma mark -- 下一步
- (void)nextButtonClick {
    // 设置音视频、水印等编辑信息
    NSMutableDictionary *outputSettings = [[NSMutableDictionary alloc] init];
    // 待编辑的原始视频素材
    NSMutableDictionary *plsMovieSettings = [[NSMutableDictionary alloc] init];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"file://%@", _url]];

    AVAsset *asset = [AVAsset assetWithURL:URL];
    CMTime cmtime = asset.duration;
    CGFloat totalSeconds = CMTimeGetSeconds(cmtime);

    plsMovieSettings[PLSURLKey] = URL;
    plsMovieSettings[PLSAssetKey] = asset;
    plsMovieSettings[PLSStartTimeKey] = [NSNumber numberWithFloat:0.f];
    plsMovieSettings[PLSDurationKey] = [NSNumber numberWithFloat:totalSeconds];
    plsMovieSettings[PLSVolumeKey] = [NSNumber numberWithFloat:1.0f];
    outputSettings[PLSMovieSettingsKey] = plsMovieSettings;

    EditViewController *editViewController = [[EditViewController alloc] init];
    editViewController.settings = outputSettings;
    [self presentViewController:editViewController animated:NO completion:nil];
}

- (void)recordButtonClick:(UIButton *)recordButton {
    if (_started) {
        [_recordButton setTitle:@"Record" forState:UIControlStateNormal];
        _started = NO;
        if (_easyarRecorder != nil) {
            [EasyarARViewController displayToastWithMessage:[@"Recorded at " stringByAppendingString:_url]];
            [_easyarRecorder stop];
             _nextButton.hidden = NO;
        } else{
             _nextButton.hidden = YES;
        }
    } else {
        _nextButton.hidden = YES;
        if (![easyar_PlayerRecorder isAvailable]) {
            [EasyarARViewController displayToastWithMessage:@"Recorder Module Not Available"];
        }
        [_recordButton setTitle:@"Stop" forState:UIControlStateNormal];
        _started = YES;
        easyar_PlayerRecorderConfiguration *configuration = [[easyar_PlayerRecorderConfiguration alloc] init];
        configuration.Identifier = @"04_RecordPass";
        _url = [EasyarARViewController prepareURL];
        configuration.OutputFilePath = _url;
        configuration.VideoOrientation = easyar_RecordVideoOrientation_Portrait;
        configuration.ZoomMode = easyar_RecordZoomMode_ZoomInWithAllContent;
        if (!_easyarRecorder) {
            [_easyarRecorder close];
        }
        
        _easyarRecorder = [(EasyARScene *)(self.view) createRecorder:configuration];
        __weak EasyarARViewController * weak_self = self;
        [_easyarRecorder requestPermissions:^(easyar_PermissionStatus status, NSString *value) {
            switch (status) {
                case easyar_PermissionStatus_Denied:
                    _started = NO;
                    [EasyarARViewController displayToastWithMessage:@"Permission Denied"];
                    [weak_self fail];
                    break;
                case easyar_PermissionStatus_Error:
                    _started = NO;
                    [EasyarARViewController displayToastWithMessage:@"Permission Error"];
                    [weak_self fail];
                    break;
                case easyar_PermissionStatus_Granted:
                {
                    EasyarARViewController * strong_self = weak_self;
                    if (strong_self == nil) { return; }
                    [strong_self->_easyarRecorder open:^(easyar_RecordStatus status, NSString *value) {
                        if (status == easyar_RecordStatus_FileFailed) {
                            EasyarARViewController * strong_self = weak_self;
                            if (strong_self == nil) { return; }
                            [strong_self fail];
                        }
                        NSLog(@"Recorder Callback status: %d, MSG: %@", (int)(status), value);
                    }];
                    [strong_self->_easyarRecorder start];
                    [EasyarARViewController displayToastWithMessage:@"Recording..."];
                }
                    break;
                default:
                    break;
            }
        }];
    }
}

+ (NSString*)prepareURL
{
    static long size = 0;
    size ++ ;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    NSString *album = [docDir stringByAppendingPathComponent:@"album"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:album]) {
        NSLog(@"first run");
        [[NSFileManager defaultManager] createDirectoryAtPath:album withIntermediateDirectories:YES attributes:nil error:nil];
        NSLog(@"%@",album);
    }
    double timenumber = [NSDate date].timeIntervalSince1970;
    NSLog(@"timenumber %lf",timenumber);
    NSString *time = [NSString stringWithFormat:@"%lf",timenumber];
    time = [time stringByReplacingOccurrencesOfString:@"." withString:@"mm"];
    NSLog(@"%@",time);
    NSString *videoString = [NSString stringWithFormat:@"%@number%08ld.mp4",time,size];
    NSString *path = [NSString stringWithFormat:@"%@/%@",album,videoString];
    NSLog(@"path %@",path);
    return path;
}

+ (void)displayToastWithMessage:(NSString *)toastMessage
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel * toastView = [[UILabel alloc] init];
        toastView.text = toastMessage;
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.lineBreakMode = NSLineBreakByWordWrapping;
        toastView.numberOfLines = 0;
        toastView.frame = CGRectMake(0.0, 0.0, keyWindow.frame.size.width/2.0, 200.0);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 3.0f
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             toastView.alpha = 0.0;
                         }
                         completion: ^(BOOL finished) {
                             [toastView removeFromSuperview];
                         }
         ];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
