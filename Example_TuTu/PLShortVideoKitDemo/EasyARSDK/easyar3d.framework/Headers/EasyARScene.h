/**
* Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
* EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
* and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
*/

#import <GLKit/GLKView.h>

#if EASYAR_RECORD_ENABLED
@class easyar_PlayerRecorderConfiguration;
@class easyar_PlayerRecorder;
#endif

@interface EasyARScene : GLKView

- (void)setFPS:(int)fps;
- (void)loadJavaScript:(NSString *)uriPath;
- (void)loadJavaScript:(NSString *)uriPath content:(NSString *)content;
- (void)loadManifest:(NSString *)uriPath;
- (void)loadManifest:(NSString *)uriPath content:(NSString *)content;
- (void)preLoadTarget:(NSString *)targetDesc onLoadHandler:(void (^)(bool status)) onLoadHandler
  onFoundHandler:(void (^)()) onFoundHandler onLostHandler:(void (^)()) onLostHandler;
- (void)sendMessage:(NSString *)name params:(NSArray<NSString *> *)params;
- (void)setMessageReceiver:(void (^)(NSString * name, NSArray<NSString *> * params))receiver;
+ (void)setUriTranslator:(NSString * (^)(NSString * uri))translator; // translator must be thread-safe and return null if file not exist
- (void)snapshot:(void(^)(UIImage *image))onSuccess failed:(void(^)(NSString *msg))onFailed;
- (void)setupCloud:(NSString *)server key:(NSString *)key secret:(NSString *)secret;

#if EASYAR_RECORD_ENABLED
- (easyar_PlayerRecorder *)createRecorder:(easyar_PlayerRecorderConfiguration *)conf;
#endif

@end
