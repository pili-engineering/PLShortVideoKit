//
//  KWMediaStreamingSDK.m
//  KWMediaStreamingSDK
//
//  Created by zhaoyichao on 2016/12/10.
//  Copyright © 2016年 KWMediaStreamingSDK. All rights reserved.
//

#import "KWSDK.h"

#import "KWStickerDownloadManager.h"

#import "SlimFaceDistortionFilter.h"
#import "FatFaceDistortionFilter.h"
#import "ETDistortionFilter.h"
#import "KWPointsRenderer.h"
#import "PearFaceDistortionFilter.h"
#import "KWBeautifyFilter.h"
#import "SquareFaceDistortionFilter.h"
#import "SmallFaceBigEyeFilter.h"

#import "KWStickerRenderer.h"
#import "KWPresentStickerRenderer.h"
#import "KWPresentStickerManager.h"
#import "KWSmiliesStickerRenderer.h"
#import "KWColorFilterManager.h"

#import "Global.h"


@interface KWSDK()

@end


@implementation KWSDK
{
    //隐藏菜单的响应View
    UIView *tapView;
    UIButton *btnBeautify1;
    UIButton *btnBeautify2;
    UIButton *btnBeautify3;
    UIButton *btnBeautify4;
}
KWSDK *sharedAccountManagerInstance = nil;

+ (KWSDK *)sharedManager
{
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"sdk不支持 模拟器运行！请连接真机运行！|| The SDK does not support the simulator run! Please connect the machine run!");
    NSAssert(!(TARGET_IPHONE_SIMULATOR), @"sdk不支持 模拟器运行！请连接真机运行！|| The SDK does not support the simulator run! Please connect the machine run!");
    return nil;
#endif
    
    
    //    static dispatch_once_t predicate;
    //    dispatch_once(&predicate, ^{
    if (sharedAccountManagerInstance == nil) {
        sharedAccountManagerInstance = [[KWSDK alloc] init];
//        sharedAccountManagerInstance.renderer = [KWRenderer new];
    }
    
    //    });
    return sharedAccountManagerInstance;
}

+ (void)releaseManager
{
    [(KWStickerRenderer *)sharedAccountManagerInstance.filters[1] setSticker:nil];
    
    ((KWPresentStickerRenderer *)sharedAccountManagerInstance.filters[2]).presentStickerRendererPlayOverBlock = nil;
    ((KWSmiliesStickerRenderer *)sharedAccountManagerInstance.filters[3]).smiliesStickerRendererPlayOverBlock = nil;
    [(KWPresentStickerRenderer *)sharedAccountManagerInstance.filters[2] setSticker:nil];
    [(KWSmiliesStickerRenderer *)sharedAccountManagerInstance.filters[3] setSticker:nil];
    [sharedAccountManagerInstance.renderer removeAllFilters];
    
    sharedAccountManagerInstance.renderer = nil;
    
    sharedAccountManagerInstance.filters = nil;
    sharedAccountManagerInstance.distortionFilters = nil;
    sharedAccountManagerInstance.beautifyFilters = nil;
    if ([sharedAccountManagerInstance.currentColorFilter isKindOfClass:[KWColorFilter class]]) {
        ((KWColorFilter *)sharedAccountManagerInstance.currentColorFilter).lookupImageSource = nil;
    }
    
    if ([sharedAccountManagerInstance.currentColorFilter isKindOfClass:[KWColorFilter class]]) {
        ((KWColorFilter *)sharedAccountManagerInstance.currentColorFilter).currentImage = nil;
    }
    sharedAccountManagerInstance.currentColorFilter = nil;
    sharedAccountManagerInstance.colorFilters = nil;
    sharedAccountManagerInstance.beautifyNewFilters = nil;
    
    sharedAccountManagerInstance.stickers = nil;
    sharedAccountManagerInstance.distortionTitleInfosArr = nil;
    sharedAccountManagerInstance = nil;
    
}

+ (BOOL)isSdkDueTheTime
{
    BOOL isDue = YES;
    isDue = [KWRenderer isSdkInitFailed];
    return isDue;
}

- (void)initSdk
{
    if (self) {
        
        [self.renderer removeAllFilters];
        
        self.currentStickerIndex = -2;
        self.currentFilterIndex = -1;
        self.currentPresentStickerIndex = -2;
        
        __weak typeof (self) __weakSelf = self;
        
        //加载贴图模板并且默认选择第一张模板贴图
        [[KWStickerManager sharedManager] loadStickersWithCompletion:^(NSMutableArray<KWSticker *> *stickers) {
            __weakSelf.stickers = stickers;
            //            [(KWStickerRenderer *)self.filters[1] setSticker:[stickers firstObject]];
            //贴纸信息读取完成
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KW_STICKERSLOADED_COMPLETE" object:nil];
            });
        }];
        
        //        加载贴图模板并且默认选择第一张模板贴图
        [[KWPresentStickerManager sharedManager] loadStickersWithCompletion:^(NSMutableArray<KWSticker *> *stickers) {
            __weakSelf.presentStickers = stickers;
            //            [(KWStickerRenderer *)self.filters[1] setSticker:[stickers firstObject]];
            //贴纸信息读取完成
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KW_STICKERSLOADED_COMPLETE" object:nil];
            });
        }];
        
        [[KWColorFilterManager sharedManager] loadColorFiltersWithCompletion:^(NSMutableArray<id> *colorFilters) {
            __weakSelf.colorFilters = colorFilters;
            
            //            if ([__weakSelf.lookupFilters count] > 0) {
            //                __weakSelf.currentLookupFilter = [__weakSelf.lookupFilters objectAtIndex:0];
            //                 [__weakSelf onFilterChanged:0];
            //            }
            //            else
            //            {
            [__weakSelf onFilterChanged:-1];
            //            }
            
            //全局滤镜信息读取完成
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KW_COLORFILTERSLOADED_COMPLETE" object:nil];
            });
            
        }];
        
        
        //普通滤镜或贴纸集合（需要人脸）
        self.filters = @[
                         [KWPointsRenderer new],
                         [KWStickerRenderer new],
                         [KWPresentStickerRenderer new],
                         [KWSmiliesStickerRenderer new]
                         ];
        
        /* 哈哈镜滤镜集合*/
        self.distortionFilters = @[
                                   [SquareFaceDistortionFilter new],
                                   [ETDistortionFilter new],
                                   [FatFaceDistortionFilter new],
                                   [SlimFaceDistortionFilter new],
                                   [PearFaceDistortionFilter new]
                                   ];
        
        
        //美颜滤镜集合
        self.beautifyFilters = @[
                                 //                                 [GPUImageBulgeEyeFilter new],
                                 //                                 [GPUImageThinFaceFilter new],
                                 [SmallFaceBigEyeFilter new]
                                 //                                 [KWBeautifyFilter new]
                                 ];
        
        self.beautifyNewFilters = @[
                                    [KWBeautifyFilter new],
                                    [NewBeautyFilter new]
                                    ];
        
        //全局滤镜集合（不需要人脸）
        //        self.lookupFilters = @[
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeBlueberrt],
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeDreamy],
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeHabana],
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeHappy],
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeHarvest],
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeMisty],
        //                               [[KWColorFilter alloc] initWithType:KWColorTypeSpring]
        //                               ];
        
        self.distortionTitleInfosArr = [NSMutableArray arrayWithObjects:@"cancel",@"distortion_SquareFace.png",@"distortion_ET.png",@"distortion_FatFace",@"distortion_SmallFace",@"distortion_PearFace",nil];
        
        //        self.globalBeatifyFilterTitleInfosArr = [NSMutableArray arrayWithObjects:@"artwork master",@"BLUEBERRY_icon.png", @"DREAMY_icon.png",@"HABANA_icon.png",@"HAPPY_icon.png",@"HARVEST_icon.png",@"MISTY_icon.png",@"SPRING_icon.png", nil];
        //
        //        if (IsEnglish) {
        //            self.textArr = [NSMutableArray arrayWithObjects:@"Origin",@"BLUE",@"DREAMY",@"HABANA",@"HAPPY",@"HARVEST",@"MISTY",@"SPRING", nil];
        //        }
        //        else
        //        {
        //            self.textArr = [NSMutableArray arrayWithObjects:@"原图",@"BLUE",@"DREAMY",@"HABANA",@"HAPPY",@"HARVEST",@"MISTY",@"SPRING", nil];
        //        }
        
        self.varWidth = ScreenWidth_KW;
        self.varHeight = ScreenHeight_KW;
        
        
        [self resetDistortionParams];
        
        //添加表情贴纸参数设置
        self.renderer.kwRenderBlock = ^(unsigned char *pixels, int format, int width, int height,result_68_t *p_result, int rstNum, int orientation,int faceNum){
            
            BOOL mouth_open = NO;
            
            for (int i = 0; i < rstNum; i++) {
                mouth_open = p_result[i].mouth_open;
                if (mouth_open) {
                    break;
                }
            }
            
            if (mouth_open && ![__weakSelf.renderer checkSmiliesSticker:(GPUImageFilter *)__weakSelf.filters[3]] && __weakSelf.renderer.isEnableSmiliesSticker) {
                [((KWSmiliesStickerRenderer *)__weakSelf.filters[3]).sticker setPlayCount:1];
                ((KWSmiliesStickerRenderer *)__weakSelf.filters[3]).isAutomaticallyPlay = YES;
                [((KWSmiliesStickerRenderer *)__weakSelf.filters[3]) setSticker:__weakSelf.presentStickers[0]];
                
                KWSticker *lastSticker = __weakSelf.presentStickers[0];
                //设置播放次数
                [lastSticker setPlayCount:1];
                //贴纸帧数置零 将贴纸重新播放
                for (KWStickerItem *item in lastSticker.items) {
                    item.currentFrameIndex = 0;
                    item.accumulator = 0;
                }
                //礼物贴纸 默认设置为跟脸 渲染
                ((KWSmiliesStickerRenderer *)__weakSelf.filters[3]).needTrackData = YES;
                
                [__weakSelf.renderer addFilter:__weakSelf.filters[3]];
                
            }
        };
        
        //        [self toggleCamera];
    }
}

- (void)resetDistortionParams
{
    if ([[Global sharedManager] isPixcelBufferRotateVertical]) {
        ((SmallFaceBigEyeFilter *)self.beautifyFilters[0]).y_scale = self.varHeight / self.varWidth;
        //    ((NewBeautyFilter *)self.beautifyNewFilters[1])
        ((ETDistortionFilter *) self.distortionFilters[1]).y_scale = self.varHeight / self.varWidth;
        ((FatFaceDistortionFilter *) self.distortionFilters[2]).y_scale =  self.varHeight / self.varWidth;
        ((SlimFaceDistortionFilter *) self.distortionFilters[3]).y_scale = self.varHeight / self.varWidth;
        ((PearFaceDistortionFilter *) self.distortionFilters[4]).y_scale = self.varHeight / self.varWidth;
    }
    else
    {
        ((SmallFaceBigEyeFilter *)self.beautifyFilters[0]).y_scale = self.varWidth / self.varHeight;
        //    ((NewBeautyFilter *)self.beautifyNewFilters[1])
        ((ETDistortionFilter *) self.distortionFilters[1]).y_scale = self.varWidth / self.varHeight;
        ((FatFaceDistortionFilter *) self.distortionFilters[2]).y_scale = self.varWidth / self.varHeight;
        ((SlimFaceDistortionFilter *) self.distortionFilters[3]).y_scale = self.varWidth / self.varHeight;
        ((PearFaceDistortionFilter *) self.distortionFilters[4]).y_scale = self.varWidth / self.varHeight;
    }
    
}

- (void)initDefaultParams
{
    [self onEnableBeauty:YES];
    
}

/******
 * 清空所有特效
 */
- (void)clearAllFilter
{
    [self.renderer removeAllFilters];
}

/* 点阵切换
 * support：YES（开启点阵）NO（关闭点阵）
 */
- (void)onEnableDrawPoints:(BOOL) support
{
    if (support) {
        [self.renderer removeAllFilters];
        [self.renderer addFilter:self.filters[0]];
    }
    else
    {
        [self.renderer removeFilter:self.filters[0]];
    }
    
}

/* 哈哈镜切换
 * filterType：滤镜类型
 */
- (void)onDistortionChanged:(NSInteger)filterType
{
    if (self.currentDistortionFilter) {
        [self.renderer removeFilter:self.currentDistortionFilter];
        self.currentDistortionFilter = nil;
    }
    if (filterType >= 0) {
        self.currentDistortionFilter = (GPUImageOutput<GPUImageInput,KWRenderProtocol> *)[self.distortionFilters objectAtIndex:(filterType)];
        
        [self.renderer addFilter:self.currentDistortionFilter];
    }
    else
    {
        [self.renderer removeFilter:self.currentDistortionFilter];
        self.currentDistortionFilter = nil;
    }
}

/* 全局滤镜切换
 * filterType：滤镜类型
 */
- (void)onFilterChanged:(NSInteger) filterType
{
    self.currentFilterIndex = filterType;
    
    if (self.currentColorFilter) {
        [self.renderer removeFilter:self.currentColorFilter];
        self.currentColorFilter = nil;
    }
    if (filterType >= 0) {
        if ([[self.colorFilters objectAtIndex:(filterType)] isKindOfClass:[KWColorFilter class]]) {
            
            self.currentColorFilter = (KWColorFilter *)[self.colorFilters objectAtIndex:(filterType)];
        }else{
            self.currentColorFilter = [self.colorFilters objectAtIndex:(filterType)];
        }
        
        [self.renderer addFilter:self.currentColorFilter];
    }
    else
    {
        [self.renderer removeFilter:self.currentColorFilter];
        self.currentColorFilter = nil;
    }
}



/* 是否开启美颜
 * support：YES（开启） NO(关闭)
 */
- (void)onEnableBeauty:(BOOL) support
{
    if (support) {
        [self.renderer addFilter:self.beautifyFilters[0]];
    }
    else
    {
        [self.renderer removeFilter:self.beautifyFilters[0]];
    }
}

- (void)onEnableNewBeauty:(BOOL)support
{
    if (support) {
        
        [self.renderer addFilter:((NewBeautyFilter *)self.beautifyNewFilters[1])];
    }else{
        
        [self.renderer removeFilter:((NewBeautyFilter *)self.beautifyNewFilters[1])];
    }
}




/* 贴纸选择
 * stickerIndex: 贴纸索引
 */
- (void)onStickerChanged:(NSInteger) pos
{
    self.currentStickerIndex = pos;
    
    [self.renderer removeFilter:self.filters[1]];
    
    
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
        
        [(KWStickerRenderer *)self.filters[1] setSticker:self.stickers[self.currentStickerIndex]];
        
        [self.renderer addFilter:self.filters[1]];
        
    } else {
        
        [(KWStickerRenderer *)self.filters[1] setSticker:nil];
        
    }
}

/* 礼物贴纸选择
 * stickerIndex: 贴纸索引
 */
- (void)onPresentStickerChanged:(NSInteger) pos
{
    self.currentPresentStickerIndex = pos;
    
    [self.renderer removeFilter:self.filters[2]];
    
    
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
    __weak typeof (self) __weakSelf = self;
    //礼物贴纸 默认设置为跟脸 渲染
    ((KWPresentStickerRenderer *)self.filters[2]).needTrackData = YES;
    ((KWPresentStickerRenderer *)self.filters[2]).presentStickerRendererPlayOverBlock = ^()
    {
        [((KWPresentStickerRenderer *)__weakSelf.filters[2]).sticker setPlayCount:0];
        //移除相应filter
        [__weakSelf.renderer removeFilter:__weakSelf.filters[2]];
        
    };
    
    if (self.currentPresentStickerIndex >= 0 && self.currentPresentStickerIndex < self.presentStickers.count + 1)
    {
        [(KWPresentStickerRenderer *)self.filters[2] setSticker:self.presentStickers[self.currentPresentStickerIndex]];
        
        [self.renderer addFilter:self.filters[2]];
    }
    else {
        [(KWPresentStickerRenderer *)self.filters[2] setSticker:nil];
    }
}


/* 是否开启表情贴纸触发
 * support：YES（开启） NO(关闭)
 */
- (void)onEnableSmiliesSticker:(BOOL) support
{
    if (support) {
        //暂时使用礼物贴纸 展示表情贴纸
        __weak typeof(self) __weakSelf = self;
        
        ((KWSmiliesStickerRenderer *)self.filters[3]).smiliesStickerRendererPlayOverBlock = ^(){
            [__weakSelf.renderer removeFilter:__weakSelf.filters[3]];
        };
        self.renderer.isEnableSmiliesSticker = YES;
    }
    else
    {
        [((KWSmiliesStickerRenderer *)self.filters[3]) setSticker:nil];
        [self.renderer removeFilter:self.filters[3]];
        
        self.renderer.isEnableSmiliesSticker = NO;
    }
}


- (void)onBeautyParamsChanged:(KW_BEAUTYPARAMS_TYPE)type Value:(float) value
{
    switch (type) {
        case KW_BEAUTYPARAMS_TYPE_BULGEEYE:
            //大眼
            ((SmallFaceBigEyeFilter *)self.beautifyFilters[0]).eyeparam = value;
            break;
            
        case KW_BEAUTYPARAMS_TYPE_THINFACE:
            //瘦脸
            ((SmallFaceBigEyeFilter *)self.beautifyFilters[0]).thinparam = value;
            break;
            
        case KW_BEAUTYPARAMS_TYPE_BRIGHTNESS:
            //美白
            ((NewBeautyFilter *)self.beautifyNewFilters[1]).smoothparam = value;
            break;
            
        case KW_BEAUTYPARAMS_TYPE_BILATERAL:
            //磨皮
            ((NewBeautyFilter *)self.beautifyNewFilters[1]).hueparam = value;
            break;
            
        case KW_BEAUTYPARAMS_TYPE_ROU:
            //饱和
            ((NewBeautyFilter *)self.beautifyNewFilters[1]).rouparam = value;
            break;
            
        case KW_BEAUTYPARAMS_TYPE_SAT:
            //粉嫩
            ((NewBeautyFilter *)self.beautifyNewFilters[1]).satparam = value;
            break;

        default:
            break;
    }
}


/*
 * 调节美颜参数
 * type：参数类型
 * value：参数调节值
 */
- (void)onNewBeautyParamsChanged:(KW_NEWBEAUTY_TYPE)type value:(float) value
{
    if (type == KW_NEWBEAUTY_TYPE_EYEMAGNIFYING || type == KW_NEWBEAUTY_TYPE_CHINSLIMING) {
        
        [((SmallFaceBigEyeFilter *)self.beautifyFilters[0]) setParam:value withType:type];

    }else{
        
        [((NewBeautyFilter *)self.beautifyNewFilters[1]) setParam:value withType:type];
        
    }
}

- (void)dealloc
{
    [sharedAccountManagerInstance.renderer removeAllFilters];
    [((KWStickerRenderer *)self.filters[1]) setSticker:nil];
    [((KWPresentStickerRenderer *)self.filters[2]) setSticker:nil];
    [((KWSmiliesStickerRenderer *)self.filters[3]) setSticker:nil];
    sharedAccountManagerInstance.filters = nil;
    sharedAccountManagerInstance.distortionFilters = nil;
    sharedAccountManagerInstance.beautifyFilters = nil;
    sharedAccountManagerInstance.colorFilters = nil;
    sharedAccountManagerInstance.beautifyNewFilters = nil;
    sharedAccountManagerInstance.stickers = nil;
    sharedAccountManagerInstance.presentStickers = nil;
    sharedAccountManagerInstance.distortionTitleInfosArr = nil;
    sharedAccountManagerInstance.renderer = nil;
}


@end
