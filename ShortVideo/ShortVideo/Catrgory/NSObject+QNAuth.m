//
//  NSObject+QNAuth.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "NSObject+QNAuth.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>

@implementation NSObject (QNAuth)

+ (void)haveAlbumAccess:(void (^)(BOOL))completeBlock {
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (PHAuthorizationStatusAuthorized == authStatus){
        if (completeBlock) {
            completeBlock(YES);
        }
    } else if(PHAuthorizationStatusRestricted == authStatus || PHAuthorizationStatusDenied == authStatus){
        
        if (completeBlock) {
            completeBlock(NO);
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"照片访问限被禁止了，请前往手机 “设置-七牛短视频” 打开 “照片” 开关" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"立即前往" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alert addAction:cancelAction];
        [alert addAction:goAction];
        UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        while (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        }
        [viewController presentViewController:alert animated:YES completion:nil];
    } else if (PHAuthorizationStatusNotDetermined == authStatus) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(PHAuthorizationStatusAuthorized == status);
            });
        }];
    }
}



+ (void)haveCameraAccess:(void (^)(BOOL))completeBlock {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (AVAuthorizationStatusAuthorized == authStatus){
        if (completeBlock) {
            completeBlock(YES);
        }
    } else if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        if (completeBlock) {
            completeBlock(NO);
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机访问权限被禁止了，请前往手机 “设置-七牛短视频” 打开 “相机” 开关" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"立即前往" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alert addAction:cancelAction];
        [alert addAction:goAction];
        UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        while (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        }
        [viewController presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(granted);
            });
        }];
    }
}

+ (void)haveMicrophoneAccess:(void (^)(BOOL))completeBlock {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (AVAuthorizationStatusAuthorized == authStatus){
        if (completeBlock) {
            completeBlock(YES);
        }
    } else if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        
        if (completeBlock) {
            completeBlock(NO);
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"相机访问权限被禁止了，请前往手机 “设置-七牛短视频” 打开 “相机” 开关" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *goAction = [UIAlertAction actionWithTitle:@"立即前往" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        }];
        [alert addAction:cancelAction];
        [alert addAction:goAction];
        UIViewController *viewController = [UIApplication sharedApplication].delegate.window.rootViewController;
        while (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
        }
        [viewController presentViewController:alert animated:YES completion:nil];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completeBlock(granted);
            });
        }];
    }
}

@end
