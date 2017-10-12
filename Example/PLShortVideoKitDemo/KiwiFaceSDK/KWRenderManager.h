//
//  KWRenderManager.h
//  KiwiFace
//
//  Created by jacoy on 2017/8/2.
//  Copyright © 2017年 jacoy. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <asl.h>
#import "KWRenderer.h"
#import "KWStickerManager.h"
#import "KWColorFilter.h"
#import "KWConst.h"
#import "Global.h"
#import "KWBeautyFilter.h"
#import "ColorFilterConst.h"
#import "KWGlobalFilter.h"

@interface KWRenderManager : NSObject

/**
 A video rendering classes
 */
@property(nonatomic, strong) KWRenderer *renderer;

/**
 贴纸滤镜
 */
@property (nonatomic, strong) KWStickerRenderer *stickerRender;


/**
 stickers collection
 */
@property(nonatomic, strong) NSMutableArray<KWSticker *> *stickers;

@property(nonatomic, strong) NSMutableArray<KWGlobalFilter *> *globalFilters;


/**
 present stickers collection
 */
@property(nonatomic, strong) NSMutableArray<KWSticker *> *presentStickers;


/** 
 distorting mirror filter collection
 */
@property(nonatomic, strong) NSArray<GPUImageOutput <GPUImageInput, KWRenderProtocol> *> *distortionFilters;

/**
 滤镜集合 
*/
//@property(nonatomic, strong) NSArray<GPUImageOutput <GPUImageInput, KWRenderProtocol> *> *colorFilters;


/**
 The currently selected sticker item
 */
@property(nonatomic) NSInteger currentStickerIndex;

/**
 The currently selected filter item
 */
@property(nonatomic) NSInteger currentFilterIndex;

/**
 The currently selected present sticker item
 */
@property(nonatomic) NSInteger currentPresentStickerIndex;

/**
 The currently selected global filter item
 */
@property(nonatomic, strong) id currentGlobalFilter;

/**
 Maximum number of face captures
 */
@property(nonatomic, assign) NSUInteger maxFaceNumber;

/**
 The currently selected distorting mirror filter
 */
@property(nonatomic, strong) GPUImageOutput <GPUImageInput, KWRenderProtocol> *currentDistortionFilter;

/**
 The Class of Camera for recording video
 */
@property(nonatomic, weak) GPUImageStillCamera *videoCamera;

/**
 The class for recording video
 */
@property(nonatomic, weak) GPUImageMovieWriter *movieWriter;

/**
 Compatible with the width of the screen
 */
@property(nonatomic, assign) CGFloat varWidth;

/**
 Compatible with the height of the screen
 */
@property(nonatomic, assign) CGFloat varHeight;

/**
 Distorting mirror filters array
 */
@property(nonatomic, strong) NSMutableArray *distortionTitleInfosArr;

@property(nonatomic, assign) BOOL cameraPositionBack;

/**
 Initialize renderManager(初始化renderManager)
 
 @param modelPath :the models file's path with a default path of KWResource.bundle/models(默认路径是 KWResource.bundle/models)
 @param cameraPositionBack YES: cameraPositionBack  NO: cameraPositionFront(YES:默认是后置摄像头,NO:默认是前置摄像头)
 */
- (instancetype)initWithModelPath:(NSString *)modelPath isCameraPositionBack:(BOOL)cameraPositionBack;

/**
 Load render(加载贴纸,滤镜)
 */
- (void)loadRender;

/**
 SDK Initialize StatusCode(SDK初始化返回值,0成功,非0失败)
 
 @return 0 sucess, non-zero failed
 */
+ (int)renderInitCode;


/**
 process pixcelBuffer(处理视频帧)
 */
+ (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer;


/**
 If you change the mirror parameters to update the mirror
 */
- (void)resetDistortionParams;


/**
 Switch the sticker filter(切换贴纸)
 
 @param pos sticker index
 */
- (void)onStickerChanged:(NSInteger)pos;


/* Switch present Sticker(切换礼物贴纸)
 
   @param pos present sticker index in the array
 */
- (void)onPresentStickerChanged:(NSInteger)pos;


/**
 Switching distorting mirror filters(切换哈哈镜)
 
 @param filterType filterType of distorting mirror
 */
- (void)onDistortionChanged:(NSInteger)filterType;


/**
 Global filter switch(切换滤镜)
 
 @param filterType filterType of Global
 */
- (void)onFilterChanged:(NSInteger)pos;


/**
 New beauty parameters changed(调整美颜(大眼,瘦脸,美白,磨皮,饱和,粉嫩)参数:0-100)
 
 @param type the type of beatifully filter params
 @param value adjustment range 0~100
 */
- (void)onNewBeautyParamsChanged:(KW_NEWBEAUTY_TYPE)type value:(float)value;


/**
  Whether enable bigEye_smallFace effect(是否开启大眼瘦脸功能)
 
 @param support The value is YES:open or NO:close
 */
- (void)onEnableBeauty:(BOOL)support;


/**
 Whether enable  beauty effect(是否开启美颜功能(美白,磨皮,饱和,粉嫩))
 
 @param support The value is YES:open or NO:close
 */
- (void)onEnableNewBeauty:(BOOL)support;


/**
 Whether display face points(是否开启人脸关键点)
 
 @param support The value is YES:open or NO:close
 */
- (void)onEnableDrawPoints:(BOOL)support;


/**
 Whether open expression triggered stickers(是否开启表情贴纸触发)

 @param support YES（Enable） NO(Disenable)
 */
- (void)onEnableSmiliesSticker:(BOOL)support;


/**
 Clear all effects of filters(清除所有滤镜)
 */
- (void)clearAllFilter;


/**
 Release renderManager object(释放所有render对象)
 */
- (void)releaseManager;


@end
