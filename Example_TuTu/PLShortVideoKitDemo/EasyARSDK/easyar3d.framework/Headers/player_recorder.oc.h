/**
* Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#if EASYAR_RECORD_ENABLED
#import <easyar/recorder.oc.h>
#endif

#if EASYAR_RECORD_ENABLED

@interface easyar_PlayerRecorderConfiguration : NSObject

@property (nonatomic, retain) NSString * Identifier;
@property (nonatomic, retain) NSString * OutputFilePath;
@property (nonatomic) easyar_RecordProfile Profile;
@property (nonatomic) easyar_RecordVideoSize VideoSize;
@property (nonatomic) int VideoBitRate;
@property (nonatomic) int ChannelCount;
@property (nonatomic) int AudioSampleRate;
@property (nonatomic) int AudioBitrate;
@property (nonatomic) easyar_RecordVideoOrientation VideoOrientation;
@property (nonatomic) easyar_RecordZoomMode ZoomMode;

@end

@interface easyar_PlayerRecorder : NSObject

+ (BOOL)isAvailable;

- (void)requestPermissions:(void (^)(easyar_PermissionStatus status, NSString * value))permissionCallback;
- (BOOL)open:(void (^)(easyar_RecordStatus status, NSString * value))statusCallback;
- (void)start;
- (void)stop;
- (void)close;

@end

#else

@interface easyar_PlayerRecorder : NSObject

+ (BOOL)isAvailable;

@end

#endif
