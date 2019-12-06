//
//  QNBaseViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNBaseViewController.h"
#import <Masonry.h>
#import <sys/utsname.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Photos/Photos.h>

@interface QNBaseViewController ()

@property (nonatomic, strong) NSMutableArray *defaultArrays;
@property (nonatomic, strong) NSArray *infoNames;

@end

@implementation QNBaseViewController

- (void)dealloc {
    NSLog(@"[dealloc] %@", self.description);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:25.0/255 green:24.0/255 blue:36.0/255 alpha:1];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - load/hide activity

- (void)showWating {
    if (nil == self.activityIndicatorView) {
        self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
        self.activityIndicatorView.center = self.view.center;
        [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
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
        self.progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 22)];
        self.progressLabel.textAlignment =  NSTextAlignmentCenter;
        self.progressLabel.textColor = [UIColor whiteColor];
        self.progressLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 20);
        if (@available(iOS 9.0, *)) {
            self.progressLabel.font = [UIFont monospacedDigitSystemFontOfSize:14 weight:(UIFontWeightRegular)];
        } else {
            self.progressLabel.font = [UIFont systemFontOfSize:14];
        }
    }
    [self.view addSubview:self.progressLabel];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%d%%", (int)(progress * 100)];
}

#pragma mark - global settings

- (NSArray *)getSettingInfos {
    self.infoNames = @[@"qn_preview_size", @"qn_audio_channel", @"qn_encode_size", @"qn_encode_bites"];
    return self.infoNames;
}

- (NSArray *)configureGlobalSettings {
    self.infoNames = @[@"qn_preview_size", @"qn_audio_channel", @"qn_encode_size", @"qn_encode_bites"];
    self.defaultArrays = [NSMutableArray array];
    for (NSString *key in self.infoNames) {
        NSString *infoValue = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (infoValue) {
            [self.defaultArrays addObject:infoValue];
        }
    }
    if (self.defaultArrays.count == 0) {
        NSArray *defaultArrays = @[@"1280x720", @"单声道", @"1280x720", @"1024kbps"];
        self.defaultArrays = [NSMutableArray arrayWithArray:defaultArrays];
        for (NSInteger i = 0; i < self.defaultArrays.count; i++) {
            NSString *key = self.infoNames[i];
            NSString *value = self.defaultArrays[i];
            [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        }
    }
    return self.defaultArrays;
}

- (NSString *)getPreviewVideoSize {
    NSString *sizeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"qn_preview_size"];
    if ([sizeString isEqualToString:@"640x480"]) {
        return AVCaptureSessionPreset640x480;
        
    } else if ([sizeString isEqualToString:@"960x540"]) {
        return AVCaptureSessionPresetiFrame960x540;
        
    } else if ([sizeString isEqualToString:@"1280x720"]) {
        return AVCaptureSessionPreset1280x720;
           
    } else {
        return AVCaptureSessionPreset1920x1080;
    }
}

- (NSInteger)getAudioChannels {
    NSString *channelString = [[NSUserDefaults standardUserDefaults] objectForKey:@"qn_audio_channel"];
    if ([channelString isEqualToString:@"双声道"]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSArray *)getEncodeVideoSize {
    NSString *sizeString = [[NSUserDefaults standardUserDefaults] objectForKey:@"qn_encode_size"];
    NSArray *sizeArray = [sizeString componentsSeparatedByString:@"x"];
    return sizeArray;
}

- (NSInteger)getEncodeBites {
    NSString *bitesString = [[NSUserDefaults standardUserDefaults] objectForKey:@"qn_encode_bites"];
    NSArray *bitesArray = [bitesString componentsSeparatedByString:@"kbps"];
    return [bitesArray[0] integerValue] * 1000;
}

#pragma mark - alert

- (void)showAlertMessage:(NSString *)title message:(NSString *)message {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:sureAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - movie URL from asset

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

#pragma mark - suitable bitrate

+ (NSInteger)suitableVideoBitrateWithSize:(CGSize)videoSize {
    
    // 下面的码率设置均偏大，为了拍摄出来的视频更清晰，选择了偏大的码率，不过均比系统相机拍摄出来的视频码率小很多
    if (videoSize.width + videoSize.height > 720 + 1280) {
        return 8 * 1000 * 1000;
    } else if (videoSize.width + videoSize.height > 540 + 960) {
        return 4 * 1000 * 1000;
    } else if (videoSize.width + videoSize.height > 360 + 640) {
        return 2 * 1000 * 1000;
    } else {
        return 1 * 1000 * 1000;
    }
}

+ (PLSAudioBitRate)suitableAudioBitrateWithSampleRate:(PLSAudioSampleRate)sampleRate channel:(NSInteger)channel {
    
    if (PLSAudioSampleRate_48000Hz == sampleRate ||
        PLSAudioSampleRate_44100Hz == sampleRate) {
        if (1 == channel) {
            return PLSAudioBitRate_64Kbps;
        } else {
            return PLSAudioBitRate_128Kbps;
        }
    } else if (PLSAudioSampleRate_22050Hz == sampleRate) {
        if (1 == channel) {
            return PLSAudioBitRate_32Kbps;
        } else {
            return PLSAudioBitRate_64Kbps;
        }
    } else {
        return PLSAudioBitRate_32Kbps;
    }
    
    return PLSAudioBitRate_64Kbps;
}

#pragma mark - request mauth

- (void)requestMPMediaLibraryAuth:(void (^)(BOOL))completeBlock {
    
    if (@available(iOS 9.3, *)) {
        if (MPMediaLibraryAuthorizationStatusDenied == [MPMediaLibrary authorizationStatus]) {
            [self.view showTip:@"请到系统设置中允许对音乐库的访问"];
            completeBlock(NO);
            return;
        } else if (MPMediaLibraryAuthorizationStatusNotDetermined == [MPMediaLibrary authorizationStatus]) {
            [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (MPMediaLibraryAuthorizationStatusAuthorized == status) {
                        completeBlock(YES);
                    } else {
                        [self.view showTip:@"请到系统设置中允许对音乐库的访问"];
                        completeBlock(NO);
                    }
                });
            }];
        } else if (MPMediaLibraryAuthorizationStatusAuthorized == [MPMediaLibrary authorizationStatus]){
            completeBlock(YES);
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)requestCameraAuth:(void (^)(BOOL))completeBlock {
    
    if (AVAuthorizationStatusDenied == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        [self.view showTip:@"请到系统设置中允许对相机的访问"];
        completeBlock(NO);
        return;
    } else if (AVAuthorizationStatusNotDetermined == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES);
                });
            } else {
                [self.view showTip:@"请到系统设置中允许对相机的访问"];
                completeBlock(NO);
            }
        }];
    } else if (AVAuthorizationStatusAuthorized == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]){
        completeBlock(YES);
    }
}

- (void)requestMicrophoneAuth:(void (^)(BOOL))completeBlock {
    
    if (AVAuthorizationStatusDenied == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
        [self.view showTip:@"请到系统设置中允许对麦克风的访问"];
        completeBlock(NO);
        return;
    } else if (AVAuthorizationStatusNotDetermined == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES);
                });
            } else {
                [self.view showTip:@"请到系统设置中允许对麦克风的访问"];
                completeBlock(NO);
            }
        }];
    } else if (AVAuthorizationStatusAuthorized == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]){
        completeBlock(YES);
    }
}

- (void)requestPhotoLibraryAuth:(void (^)(BOOL))completeBlock {
    
    if (PHAuthorizationStatusDenied == [PHPhotoLibrary authorizationStatus]) {
        [self.view showTip:@"请到系统设置中允许对相册的访问"];
        completeBlock(NO);
        return;
    } else if (PHAuthorizationStatusNotDetermined == [PHPhotoLibrary authorizationStatus]) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (PHAuthorizationStatusAuthorized == status) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(YES);
                });
            } else {
                [self.view showTip:@"请到系统设置中允许对相册的访问"];
                completeBlock(NO);
            }
        }];
    } else if (PHAuthorizationStatusAuthorized == [PHPhotoLibrary authorizationStatus]){
        completeBlock(YES);
    }
}

#pragma mark - format time to string

- (NSString *)formatTimeString:(NSTimeInterval)time {
    NSInteger intValue = round(time);
    int min = intValue / 60;
    int second = intValue % 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, second];
}

#pragma mark - device type

+ (QNDeviceType)deviceType {
    
//    https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model/40091083
    
    struct utsname info = {0};
    uname(&info);
    NSString *modelName = [NSString stringWithUTF8String:info.machine];
    if ([modelName isEqualToString:@"iPhone3,1"] ||
        [modelName isEqualToString:@"iPhone3,2"] ||
        [modelName isEqualToString:@"iPhone3,3"]) {
        return QNDeviceTypeIPhone4;
    } else if ([modelName isEqualToString:@"iPhone4,1"]) {
        return QNDeviceTypeIPhone4s;
    } else if ([modelName isEqualToString:@"iPhone5,1"] ||
               [modelName isEqualToString:@"iPhone5,2"]) {
        return QNDeviceTypeIPhone5;
    } else if ([modelName isEqualToString:@"iPhone5,3"] ||
               [modelName isEqualToString:@"iPhone5,4"]) {
        return QNDeviceTypeIPhone5c;
    } else if ([modelName isEqualToString:@"iPhone6,1"] ||
               [modelName isEqualToString:@"iPhone6,2"]) {
        return QNDeviceTypeIPhone5s;
    } else if ([modelName isEqualToString:@"iPhone7,2"]) {
        return QNDeviceTypeIPhone6;
    } else if ([modelName isEqualToString:@"iPhone7,1"]) {
        return QNDeviceTypeIPhone6Plus;
    } else if ([modelName isEqualToString:@"iPhone8,1"]) {
        return QNDeviceTypeIPhone6s;
    } else if ([modelName isEqualToString:@"iPhone8,2"]) {
        return QNDeviceTypeIPhone6sPlus;
    } else if ([modelName isEqualToString:@"iPhone9,1"] ||
               [modelName isEqualToString:@"iPhone9,3"]) {
        return QNDeviceTypeIPhone7;
    } else if ([modelName isEqualToString:@"iPhone9,2"] ||
               [modelName isEqualToString:@"iPhone9,4"]) {
        return QNDeviceTypeIPhone7Plus;
    } else if ([modelName isEqualToString:@"iPhone8,4"]) {
        return QNDeviceTypeIPhoneSE;
    } else if ([modelName isEqualToString:@"iPhone10,1"] ||
               [modelName isEqualToString:@"iPhone10,4"]) {
        return QNDeviceTypeIPhone8;
    } else if ([modelName isEqualToString:@"iPhone10,2"] ||
               [modelName isEqualToString:@"iPhone10,5"]) {
        return QNDeviceTypeIPhone8Plus;
    } else if ([modelName isEqualToString:@"iPhone10,3"] ||
               [modelName isEqualToString:@"iPhone10,6"]) {
        return QNDeviceTypeIPhoneX;
    } else if ([modelName isEqualToString:@"iPhone11,2"]) {
        return QNDeviceTypeIPhoneXS;
    } else if ([modelName isEqualToString:@"iPhone11,4"] ||
               [modelName isEqualToString:@"iPhone11,6"]) {
        return QNDeviceTypeIPhoneXSMax;
    } else if ([modelName isEqualToString:@"iPhone11,8"]) {
        return QNDeviceTypeIPhoneXR;
    }
    
    return QNDeviceTypeIPhoneX;
}
@end
