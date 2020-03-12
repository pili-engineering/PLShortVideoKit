//
//  QNAppDelegate.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNAppDelegate.h"
#import "QNMainViewController.h"

@interface QNAppDelegate ()

@end

@implementation QNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = QN_MAIN_COLOR;
    self.window.rootViewController = QNMainViewController.alloc.init;
    
    [self.window makeKeyAndVisible];
    
    // 延迟执行初始化，提升启动速度
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // MARK: - TuSDK 初始化
        [TuSDK initSdkWithAppKey:@"30398377e3ba5e5e-03-bshmr1"];
#ifdef DEBUG
        [PLShortVideoKitEnv initEnv];
        [PLShortVideoKitEnv enableFileLogging];
        [PLShortVideoKitEnv setLogLevel:(PLShortVideoLogLevelDebug)];
        
        // MARK: - TuSDK 日志输出级别
        [TuSDK setLogLevel:lsqLogLevelDEBUG]; // 可选: 设置日志输出级别 (默认不输出)
        NSLog(@"PLShortVideoKit version: %@", PLShortVideoRecorder.versionInfo);
        NSLog(@"TuSDK version: %@", lsqSDKVersion);
        NSLog(@"TuSDK video version: %@", lsqVideoVersion);
        NSLog(@"FaceUnity version: %@", [FURenderer getVersion]);
#else
        [PLShortVideoKitEnv setLogLevel:(PLShortVideoLogLevelOff)];
        [TuSDK setLogLevel:lsqLogLevelFATAL]; // 可选: 设置日志输出级别 (默认不输出)
#endif
    });

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
