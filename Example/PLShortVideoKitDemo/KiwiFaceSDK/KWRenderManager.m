//
//  KWRenderManager.m
//  KiwiFace
//
//  Created by jacoy on 2017/8/2.
//  Copyright © 2017年 jacoy. All rights reserved.
//

#import "KWRenderManager.h"

#import "KWStickerDownloadManager.h"

#import "SlimFaceDistortionFilter.h"
#import "FatFaceDistortionFilter.h"
#import "ETDistortionFilter.h"
#import "KWPointsRenderer.h"
#import "PearFaceDistortionFilter.h"
#import "SquareFaceDistortionFilter.h"
#import "SmallFaceBigEyeFilter.h"

#import "KWStickerRenderer.h"
#import "KWPresentStickerRenderer.h"
#import "KWPresentStickerManager.h"
#import "KWSmiliesStickerRenderer.h"
#import "KWGlobalFilterManager.h"

#import "Global.h"

@interface KWRenderManager ()

/**
 大眼瘦脸
 */
@property(nonatomic, strong) SmallFaceBigEyeFilter *smallFaceBigEyeFilter;

/**
 美颜
 */
@property(nonatomic, strong) KWBeautyFilter *beautyFilter;

/**
 礼物贴纸
 */
@property(nonatomic, strong) KWPresentStickerRenderer *presentStickerRenderer;

/**
 表情贴纸
 */
@property(nonatomic, strong) KWSmiliesStickerRenderer *smiliesStickerRenderer;

/**
 人脸点滤镜
 */
@property(nonatomic, strong) KWPointsRenderer *pointsRender;


@end

@implementation KWRenderManager

KWRenderManager *instanceManager = nil;

+ (instancetype)sharedManager {

    if (instanceManager == nil) {
        return nil;
    }
    return instanceManager;
}

- (instancetype)initWithModelPath:(NSString *)modelPath isCameraPositionBack:(BOOL)cameraPositionBack {
    if (self = [super init]) {
#if TARGET_IPHONE_SIMULATOR
        NSLog(@"sdk不支持 模拟器运行！请连接真机运行！|| The SDK does not support the simulator run! Please connect the machine run!");
        NSAssert(!(TARGET_IPHONE_SIMULATOR), @"sdk不支持 模拟器运行！请连接真机运行！|| The SDK does not support the simulator run! Please connect the machine run!");
        return nil;
#endif

        self.renderer = [[KWRenderer alloc] initWithModelPath:modelPath];
        self.cameraPositionBack = cameraPositionBack;
    }

    instanceManager = self;

    return self;
}

+ (int)renderInitCode {

    return [KWRenderer renderInitCode];
}

- (void)setCameraPositionBack:(BOOL)cameraPositionBack {
    _cameraPositionBack = cameraPositionBack;
}

- (void)loadRender {
    [self.renderer removeAllFilters];

    self.currentStickerIndex = -3;
    self.currentFilterIndex = -1;
    self.currentPresentStickerIndex = -2;

    __weak typeof(self) __weakSelf = self;

    //加载人脸贴纸
    [[KWStickerManager sharedManager] loadStickersWithCompletion:^(NSMutableArray<KWSticker *> *stickers) {
        __weakSelf.stickers = stickers;

        //刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KW_STICKERSLOADED_COMPLETE" object:nil];
        });
    }];


    //加载礼物贴纸
    [[KWPresentStickerManager sharedManager] loadStickersWithCompletion:^(NSMutableArray<KWSticker *> *stickers) {
        __weakSelf.presentStickers = stickers;

        //刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KW_STICKERSLOADED_COMPLETE" object:nil];
        });
    }];


    //加载全局滤镜
    [[KWGlobalFilterManager sharedManager] loadColorFiltersWithCompletion:^(NSMutableArray<KWGlobalFilter *> *filters) {
        __weakSelf.globalFilters = filters;


        //刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{

            [[NSNotificationCenter defaultCenter] postNotificationName:@"KW_COLORFILTERSLOADED_COMPLETE" object:nil];
        });

    }];


    //普通滤镜或贴纸集合（需要人脸)
    self.pointsRender = [[KWPointsRenderer alloc] init];

    self.stickerRender = [[KWStickerRenderer alloc] init];

    self.smiliesStickerRenderer = [[KWSmiliesStickerRenderer alloc] init];

    self.presentStickerRenderer = [[KWPresentStickerRenderer alloc] init];

    //大眼瘦脸滤镜
    self.smallFaceBigEyeFilter = [[SmallFaceBigEyeFilter alloc] init];

    //美颜滤镜
    self.beautyFilter = [[KWBeautyFilter alloc] init];


    /* 哈哈镜滤镜集合*/
    self.distortionFilters = @[
                               [SquareFaceDistortionFilter new],
                               [ETDistortionFilter new],
                               [FatFaceDistortionFilter new],
                               [SlimFaceDistortionFilter new],
                               [PearFaceDistortionFilter new]
                               ];

    self.distortionTitleInfosArr =
            [NSMutableArray arrayWithObjects:@"cancel", @"distortion_SquareFace.png", @"distortion_ET.png", @"distortion_FatFace", @"distortion_SmallFace", @"distortion_PearFace", nil];

    self.varWidth = ScreenWidth_KW;
    self.varHeight = ScreenHeight_KW;

    [self resetDistortionParams];

    //添加表情贴纸参数设置
    self.renderer.kwRenderBlock =
            ^(unsigned char *pixels, int format, int width, int height, result_68_t *p_result, int rstNum, int orientation, int faceNum) {

                BOOL mouth_open = NO;

                for (int i = 0; i < rstNum; i++) {
                    mouth_open = p_result[i].mouth_open;
                    if (mouth_open) {
                        break;
                    }
                }

                if (mouth_open && ![__weakSelf.renderer checkSmiliesSticker:__weakSelf.smiliesStickerRenderer] && __weakSelf.renderer.isEnableSmiliesSticker) {
                    [__weakSelf.smiliesStickerRenderer.sticker setPlayCount:1];
                    __weakSelf.smiliesStickerRenderer.isAutomaticallyPlay = YES;
                    [__weakSelf.smiliesStickerRenderer setSticker:__weakSelf.presentStickers[0]];

                    KWSticker *lastSticker = __weakSelf.presentStickers[0];
                    //设置播放次数
                    [lastSticker setPlayCount:1];
                    //贴纸帧数置零 将贴纸重新播放
                    for (KWStickerItem *item in lastSticker.items) {
                        item.currentFrameIndex = 0;
                        item.accumulator = 0;
                    }
                    //礼物贴纸 默认设置为跟脸 渲染
                    __weakSelf.smiliesStickerRenderer.needTrackData = YES;

                    [__weakSelf.renderer addFilter:__weakSelf.smiliesStickerRenderer];

                }
            };
}

- (void)resetDistortionParams {
    if ([[Global sharedManager] isPixcelBufferRotateVertical]) {
        self.smallFaceBigEyeFilter.y_scale = self.varHeight / self.varWidth;

        ((ETDistortionFilter *) self.distortionFilters[1]).y_scale = self.varHeight / self.varWidth;
        ((FatFaceDistortionFilter *) self.distortionFilters[2]).y_scale = self.varHeight / self.varWidth;
        ((SlimFaceDistortionFilter *) self.distortionFilters[3]).y_scale = self.varHeight / self.varWidth;
        ((PearFaceDistortionFilter *) self.distortionFilters[4]).y_scale = self.varHeight / self.varWidth;
    } else {
        self.smallFaceBigEyeFilter.y_scale = self.varWidth / self.varHeight;

        ((ETDistortionFilter *) self.distortionFilters[1]).y_scale = self.varWidth / self.varHeight;
        ((FatFaceDistortionFilter *) self.distortionFilters[2]).y_scale = self.varWidth / self.varHeight;
        ((SlimFaceDistortionFilter *) self.distortionFilters[3]).y_scale = self.varWidth / self.varHeight;
        ((PearFaceDistortionFilter *) self.distortionFilters[4]).y_scale = self.varWidth / self.varHeight;
    }

}

+ (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer{
    
    BOOL mirrored = !instanceManager.cameraPositionBack;
    
    cv_rotate_type cvMobileRotate;
    
    [Global sharedManager].PIXCELBUFFER_ROTATE = KW_PIXELBUFFER_ROTATE_90;
    
    UIDeviceOrientation iDeviceOrientation = [[UIDevice currentDevice] orientation];
    
    switch (iDeviceOrientation) {
        case UIDeviceOrientationPortrait:
            cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
            break;
            
        case UIDeviceOrientationLandscapeLeft:
            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_90 : CV_CLOCKWISE_ROTATE_270;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            cvMobileRotate = mirrored ? CV_CLOCKWISE_ROTATE_270 : CV_CLOCKWISE_ROTATE_90;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            cvMobileRotate = CV_CLOCKWISE_ROTATE_180;
            break;
            
        default:
            cvMobileRotate = CV_CLOCKWISE_ROTATE_0;
            break;
    }
    
    [instanceManager.renderer processPixelBuffer:pixelBuffer withRotation:cvMobileRotate mirrored:mirrored];
}

/******
 * 清空所有特效
 */
- (void)clearAllFilter {
    [self.renderer removeAllFilters];
}

/* 点阵切换
 * support：YES（开启点阵）NO（关闭点阵）
 */
- (void)onEnableDrawPoints:(BOOL)support {
    if (support) {
        [self.renderer removeAllFilters];
        [self.renderer addFilter:self.pointsRender];
    } else {
        [self.renderer removeFilter:self.pointsRender];
    }

}

/* 哈哈镜切换
 * filterType：滤镜类型
 */
- (void)onDistortionChanged:(NSInteger)filterType {
    if (self.currentDistortionFilter) {
        [self.renderer removeFilter:self.currentDistortionFilter];
        self.currentDistortionFilter = nil;
    }
    if (filterType >= 0) {
        self.currentDistortionFilter =
                (GPUImageOutput <GPUImageInput, KWRenderProtocol> *) [self.distortionFilters objectAtIndex:(filterType)];

        [self.renderer addFilter:self.currentDistortionFilter];
    } else {
        [self.renderer removeFilter:self.currentDistortionFilter];
        self.currentDistortionFilter = nil;
    }
}

/* 全局滤镜切换
 * filterType：滤镜类型
 */
- (void)onFilterChanged:(NSInteger)pos {
    self.currentFilterIndex = pos;

    if (self.currentGlobalFilter) {

        [self.renderer removeFilter:self.currentGlobalFilter];
        self.currentGlobalFilter = nil;
    }

    if (pos >= 0) {

        KWGlobalFilter *filter = [self.globalFilters objectAtIndex:pos];
        self.currentGlobalFilter = [filter getShaderFilter];
        [self.renderer addFilter:self.currentGlobalFilter];

    }
}

/* 是否开启大眼瘦脸
 * support：YES（开启） NO(关闭)
 */
- (void)onEnableBeauty:(BOOL)support {
    if (support) {
        [self.renderer addFilter:self.smallFaceBigEyeFilter];
    } else {
        [self.renderer removeFilter:self.smallFaceBigEyeFilter];
    }
}

/* 是否开启美颜
 * support：YES（开启） NO(关闭)
 */
- (void)onEnableNewBeauty:(BOOL)support {
    if (support) {

        [self.renderer addFilter:self.beautyFilter];
    } else {

        [self.renderer removeFilter:self.beautyFilter];
    }
}

/* 贴纸选择
 * stickerIndex: 贴纸索引
 */
- (void)onStickerChanged:(NSInteger)pos {
    self.currentStickerIndex = pos;

    [self.renderer removeFilter:self.stickerRender];

    if (self.currentStickerIndex >= 0) {

        KWSticker *lastSticker = self.stickers[self.currentStickerIndex];

        //设置播放次数
        //        [lastSticker setPlayCount:1];

        //贴纸帧数置零 将贴纸重新播放
        for (KWStickerItem *item in lastSticker.items) {

            item.currentFrameIndex = 0;
        }
    }

    if (self.currentStickerIndex >= 0 && self.currentStickerIndex < self.stickers.count + 1) {

        [self.stickerRender setSticker:self.stickers[self.currentStickerIndex]];

        [self.renderer addFilter:self.stickerRender];

    } else {

        [self.stickerRender setSticker:nil];

    }
}

/* 礼物贴纸选择
 * stickerIndex: 贴纸索引
 */
- (void)onPresentStickerChanged:(NSInteger)pos {

    self.currentPresentStickerIndex = pos;

    [self.renderer removeFilter:self.presentStickerRenderer];

    if (self.currentPresentStickerIndex >= 0) {
        KWSticker *lastSticker = self.presentStickers[self.currentPresentStickerIndex];
        //设置播放次数
        [lastSticker setPlayCount:1];
        //贴纸帧数置零 将贴纸重新播放
        for (KWStickerItem *item in lastSticker.items) {
            item.currentFrameIndex = 0;
            item.accumulator = 0;
        }
    }

    //设置播放结束后的自定义动作
    __weak typeof(self) __weakSelf = self;
    //礼物贴纸 默认设置为跟脸 渲染
    self.presentStickerRenderer.needTrackData = YES;
    self.presentStickerRenderer.presentStickerRendererPlayOverBlock = ^() {

        [__weakSelf.presentStickerRenderer.sticker setPlayCount:0];
        //移除相应filter
        [__weakSelf.renderer removeFilter:__weakSelf.presentStickerRenderer];
    };

    if (self.currentPresentStickerIndex >= 0 && self.currentPresentStickerIndex < self.presentStickers.count + 1) {
        [self.presentStickerRenderer setSticker:self.presentStickers[self.currentPresentStickerIndex]];

        [self.renderer addFilter:self.presentStickerRenderer];
    } else {
        [self.presentStickerRenderer setSticker:nil];
    }
}

/* 是否开启表情贴纸触发
 * support：YES（开启） NO(关闭)
 */
- (void)onEnableSmiliesSticker:(BOOL)support {
    if (support) {
        //暂时使用礼物贴纸 展示表情贴纸
        __weak typeof(self) __weakSelf = self;

        self.smiliesStickerRenderer.smiliesStickerRendererPlayOverBlock = ^() {
            [__weakSelf.renderer removeFilter:__weakSelf.smiliesStickerRenderer];
        };
        self.renderer.isEnableSmiliesSticker = YES;
    } else {
        [self.smiliesStickerRenderer setSticker:nil];
        [self.renderer removeFilter:self.smiliesStickerRenderer];

        self.renderer.isEnableSmiliesSticker = NO;
    }
}

/*
 * 调节美颜参数
 * type：参数类型
 * value：参数调节值
 */
- (void)onNewBeautyParamsChanged:(KW_NEWBEAUTY_TYPE)type value:(float)value {
    if (type == KW_NEWBEAUTY_TYPE_EYEMAGNIFYING || type == KW_NEWBEAUTY_TYPE_CHINSLIMING) {

        [self.smallFaceBigEyeFilter setParam:value withType:type];
    } else {

        [self.beautyFilter setParam:value withType:type];
    }
}

- (void)releaseManager {
    [self.stickerRender setSticker:nil];
    [self.presentStickerRenderer setSticker:nil];
    [self.smiliesStickerRenderer setSticker:nil];
    self.presentStickerRenderer.presentStickerRendererPlayOverBlock = nil;
    self.smiliesStickerRenderer.smiliesStickerRendererPlayOverBlock = nil;
    [self.renderer removeAllFilters];

    //release array
    [KWGlobalFilterManager removeAllColorFilters];
    self.currentDistortionFilter = nil;
    self.currentGlobalFilter = nil;
    self.stickers = nil;
    self.presentStickers = nil;
    self.distortionTitleInfosArr = nil;
    self.distortionFilters = nil;

    //release render
    self.stickerRender = nil;
    self.currentGlobalFilter = nil;
    self.pointsRender = nil;
    self.beautyFilter = nil;
    self.smiliesStickerRenderer = nil;
    self.presentStickerRenderer = nil;
    self.smallFaceBigEyeFilter = nil;
    self.renderer = nil;
    instanceManager = nil;

}


@end
