//
//  Constants.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/6/28.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <UIKit/UIKit.h>

// 注意事项: 以 s 结尾的宏都是一些散列值，使用时需进行封包；而以 Array、Dictionary 结尾的则是可直接使用的数组和字典。

#pragma mark - 普通滤镜（Array）

// 相机滤镜代号
#define kCameraFilterCodes @"nature_1",@"whitening_1",@"timber_1",@"pink_1",@"ruddy_1"

// 漫画代号
#define kCameraCartoonCodes @"CHComics_Video",@"USComics_Video",@"JPComics_Video",@"Lightcolor_Video",@"Ink_Video",@"Monochrome_Video"

// 美颜滤镜参数名称
#define kBeautySkinKeys @"smoothing", @"whitening"

// 美型滤镜参数名称
#define kBeautyFaceKeys @"eyeSize", @"chinSize", @"noseSize", @"mouthWidth", @"archEyebrow", @"jawSize", @"eyeAngle", @"eyeDis"

// 视频编辑滤镜代号
#define kVideoEditFilterCodes @"Relaxed_1",@"Instant_1",@"Artistic_1",@"Olympus_1",@"Beautiful_1",@"Elad_1",@"Green_1",@"Qiushi_1",@"Winter_1",@"Elegant_1",@"Vatican_1",@"Leica_1",@"Gloomy_1",@"SilentEra_1",@"s1950_1"

#define kScenceCodes @[@"LiveShake01",@"LiveMegrim01",@"EdgeMagic01",@"LiveFancy01_1",@"LiveSoulOut01",@"LiveSignal01",@"LiveLightning01",@"LiveXRay01",@"LiveHeartbeat01", @"LiveMirrorImage01", @"LiveSlosh01", @"LiveOldTV01"]
