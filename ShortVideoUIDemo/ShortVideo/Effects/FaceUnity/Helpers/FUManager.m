//
//  FUManager.m
//  FULiveDemo
//
//  Created by 刘洋 on 2017/8/18.
//  Copyright © 2017年 刘洋. All rights reserved.
//

#import "FUManager.h"
#import "FURenderer.h"
#import "authpack.h"
#import "FULiveModel.h"
#import <sys/utsname.h>
#import <CoreMotion/CoreMotion.h>
#import "FUMusicPlayer.h"
#import "FUImageHelper.h"
#import "FURenderer+header.h"



@interface FUManager ()
{

    int items[12];
    int frameID;
    
    dispatch_queue_t makeupQueue;
    
    dispatch_queue_t asyncLoadQueue;
}

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) int deviceOrientation;
/* 重力感应道具 */
@property (nonatomic,assign) BOOL isMotionItem;
/* 当前加载的道具资源 */
@property (nonatomic,copy) NSString *currentBoudleName;
/* 需提示item */
@property (nonatomic, strong) NSDictionary *hintDic;

@end

static FUManager *shareManager = NULL;

@implementation FUManager

+ (FUManager *)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[FUManager alloc] init];
    });
    
    return shareManager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setupDeviceMotion];
        makeupQueue = dispatch_queue_create("com.faceUMakeup", DISPATCH_QUEUE_SERIAL);
        asyncLoadQueue = dispatch_queue_create("com.faceLoadItem", DISPATCH_QUEUE_SERIAL);
        NSString *path = [[NSBundle mainBundle] pathForResource:@"v3.bundle" ofType:nil];
        
        /**这里新增了一个参数shouldCreateContext，设为YES的话，不用在外部设置context操作，我们会在内部创建并持有一个context。
         还有设置为YES,则需要调用FURenderer.h中的接口，不能再调用funama.h中的接口。*/
        [[FURenderer shareRenderer] setupWithDataPath:path authPackage:&g_auth_package authSize:sizeof(g_auth_package) shouldCreateContext:YES];
        
        dispatch_async(asyncLoadQueue, ^{
            
            NSData *tongueData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tongue.bundle" ofType:nil]];
            int ret0 = fuLoadTongueModel((void *)tongueData.bytes, (int)tongueData.length) ;
            NSLog(@"fuLoadTongueModel %@",ret0 == 0 ? @"failure":@"success" );
     
        });
        
        [self setBeautyDefaultParameters];
                
        NSLog(@"faceunitySDK version:%@",[FURenderer getVersion]);
        
        /* 提示语句 */
        [self setupItmeHintData];
        /* 道具加载model */
        [self setupItemDataSource];
        
        // 默认竖屏
        self.deviceOrientation = 0 ;
        fuSetDefaultOrientation(self.deviceOrientation) ;
        
        // 性能优先关闭
        self.performance = NO ;
    }
    
    return self;
}

- (void)setupItmeHintData{
    self.hintDic = @{
                @"future_warrior":@"张嘴试试",
                @"jet_mask":@"鼓腮帮子",
                @"sdx2":@"皱眉触发",
                @"luhantongkuan_ztt_fu":@"眨一眨眼",
                @"qingqing_ztt_fu":@"嘟嘴试试",
                @"xiaobianzi_zh_fu":@"微笑触发",
                @"xiaoxueshen_ztt_fu":@"吹气触发",
                @"hez_ztt_fu":@"张嘴试试",
                @"fu_lm_koreaheart":@"单手手指比心",
                @"ssd_thread_korheart":@"单手手指比心",
                @"fu_zh_baoquan":@"双手抱拳",
                @"fu_zh_hezxiong":@"双手合十",
                @"fu_ztt_live520":@"双手比心",
                @"ssd_thread_thumb":@"竖个拇指",
                @"ssd_thread_six":@"比个六",
                @"ssd_thread_cute":@"双拳靠近脸颊卖萌",
                @"ctrl_rain":@"推出手掌",
                @"ctrl_snow":@"推出手掌",
                @"ctrl_flower":@"推出手掌",
                };
}

- (void)loadItems
{
    /**加载普通道具*/
    [self loadItem:self.selectedItem];
    
    /**加载美颜道具*/
    [self loadFilter];
}


/**销毁全部道具*/
- (void)destoryItems{
    dispatch_async(asyncLoadQueue, ^{
        [FURenderer destroyAllItems];
        NSLog(@"Nama destroy all items ~");
        /**销毁道具后，为保证被销毁的句柄不再被使用，需要将int数组中的元素都设为0*/
        for (int i = 0; i < sizeof(items) / sizeof(int); i++) {
            items[i] = 0;
        }
        /**销毁道具后，清除context缓存*/
        [FURenderer OnDeviceLost];

        /**销毁道具后，重置默认参数*/
        //[self setBeautyDefaultParameters];
    });
}


- (void)destoryItemAboutType:(FUNamaHandleType)type;
{
    /**后销毁老道具句柄*/
    if (items[type] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[type]];
        items[type] = 0;
    }
}

/* 抗锯齿 */
- (void)loadAnimojiFaxxBundle
{
    dispatch_async(asyncLoadQueue, ^{
        /**先创建道具句柄*/
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fxaa.bundle" ofType:nil];
        int itemHandle = [FURenderer itemWithContentsOfFile:path];
        
        /**销毁老的道具句柄*/
        if (items[FUMNamaHandleTypeFxaa] != 0) {
            NSLog(@"faceunity: destroy old item");
            [FURenderer destroyItem:items[FUMNamaHandleTypeFxaa]];
        }
        
        /**将刚刚创建的句柄存放在items[FUMNamaHandleTypeFxaa]中*/
        items[FUMNamaHandleTypeFxaa] = itemHandle;
    });
}

- (void)destoryAnimojiFaxxBundle
{
    /**销毁老的道具句柄*/
    if (items[FUMNamaHandleTypeFxaa] != 0) {
        NSLog(@"faceunity: destroy item");
        [FURenderer destroyItem:items[FUMNamaHandleTypeFxaa]];
        items[FUMNamaHandleTypeFxaa] = 0 ;
    }
}

/**加载手势识别道具，默认未不加载*/
- (void)loadGesture
{
    dispatch_async(asyncLoadQueue, ^{
        if (items[FUNamaHandleTypeGesture] != 0) {
            NSLog(@"faceunity: destroy gesture");
            [FURenderer destroyItem:items[FUNamaHandleTypeGesture]];
            items[FUNamaHandleTypeGesture] = 0;
        }
        NSString *path = [[NSBundle mainBundle] pathForResource:@"heart_v2.bundle" ofType:nil];
        items[FUNamaHandleTypeGesture] = [FURenderer itemWithContentsOfFile:path];
    });
}

/*
 is3DFlipH 翻转模型
 isFlipExpr 翻转表情
 isFlipTrack 翻转位置和旋转
 isFlipLight 翻转光照
 */
- (void)set3DFlipH
{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"is3DFlipH" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"isFlipExpr" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"isFlipTrack" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"isFlipLight" value:@(1)];
}

- (void)setLoc_xy_flip
{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"loc_x_flip" value:@(1)];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"loc_y_flip" value:@(1)];
}

- (void)musicFilterSetMusicTime
{
    [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"music_time" value:@([FUMusicPlayer sharePlayer].currentTime * 1000 + 50)];//需要加50ms的延迟
}


#pragma mark -  加载bundle

/**加载美颜道具*/
- (void)loadFilter{
    dispatch_async(asyncLoadQueue, ^{
        NSLog(@"aaaaa111");
        if (items[FUMNamaHandleTypeBeauty] == 0) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"face_beautification.bundle" ofType:nil];
            items[FUMNamaHandleTypeBeauty] = [FURenderer itemWithContentsOfFile:path];
        }
    });
}


- (void)loadMakeupBundleWithName:(NSString *)name{
    dispatch_async(asyncLoadQueue, ^{
        [self destoryItemAboutType:FUNamaHandleTypeMakeup];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"bundle"];
        items[FUNamaHandleTypeMakeup] = [FURenderer itemWithContentsOfFile:filePath];
        fuItemSetParamd(items[FUNamaHandleTypeMakeup], "makeup_lip_mask", 1.0);//使用优化的口红效果
        [[FUManager shareManager] setMakeupItemIntensity:0 param:@"makeup_intensity_lip"];//口红设置为0
    });
}


/*设置默认参数*/
- (void)setBeautyDefaultParameters {
    
//    self.filtersDataSource = @[@"Origin", @"Delta", @"Electric", @"Slowlived", @"Tokyo", @"Warm"];
//
    self.beautyFiltersDataSource = @[@"origin",@"bailiang1",@"fennen1",@"lengsediao1",@"nuansediao1",@"xiaoqingxin1"];
//    self.beautyFiltersDataSource = @[@"origin",@"bailiang1",@"bailiang2",@"bailiang3",@"bailiang4",@"bailiang5",@"bailiang6",@"bailiang7",
//                                     @"fennen1",@"fennen2",@"fennen3",@"fennen4",@"fennen5",@"fennen6",@"fennen7",@"fennen8",
//                                     @"gexing1",@"gexing2",@"gexing3",@"gexing4",@"gexing5",@"gexing6",@"gexing7",@"gexing8",@"gexing9",@"gexing10",
//                                     @"heibai1",@"heibai2",@"heibai3",@"heibai4",@"heibai5",
//                                     @"lengsediao1",@"lengsediao2",@"lengsediao3",@"lengsediao4",@"lengsediao5",@"lengsediao6",@"lengsediao7",@"lengsediao8",
//                                     @"lengsediao9",@"lengsediao10",@"lengsediao11",
//                                     @"nuansediao1",@"nuansediao2",@"nuansediao3",
//                                     @"xiaoqingxin1",@"xiaoqingxin2",@"xiaoqingxin3",@"xiaoqingxin4",@"xiaoqingxin5",@"xiaoqingxin6"];
    
    
    self.filtersCHName = @{@"origin" : @"原图", @"bailiang1":@"白亮", @"fennen1":@"粉嫩", @"gexing1":@"个性", @"heibai1":@"黑白", @"lengsediao1":@"冷色调",@"nuansediao1":@"暖色调", @"xiaoqingxin1":@"小清新"};
//    self.selectedFilter = @"fennen1";
    self.selectedFilter = @"origin";
    self.selectedFilterLevel = 0.7;
    //    if (!self.selectedFilter) {
    //        self.selectedFilter    = self.filtersDataSource[0] ;
    //    }
    
    self.skinDetectEnable       = self.performance ? NO : YES ;// 精准美肤
    self.blurShape              = self.performance ? 1 : 0 ;   // 朦胧磨皮 1 ，清晰磨皮 0
    self.blurLevel              = 0.7 ; // 磨皮， 实际设置的时候 x6
    self.whiteLevel             = 0.3 ; // 美白
    self.redLevel               = 0.3 ; // 红润
    
    self.eyelightingLevel       = self.performance ? 0 : 0.7 ; // 亮眼
    self.beautyToothLevel       = self.performance ? 0 : 0.7 ; // 美牙
    
    self.faceShape              = self.performance ? 3 :4 ;   // 脸型
    self.enlargingLevel         = 0.4 ; // 大眼
    self.thinningLevel          = 0.4 ; // 瘦脸
    
    self.enlargingLevel_new     = 0.4 ; // 大眼
    self.thinningLevel_new      = 0.4 ; // 瘦脸
    self.jewLevel               = 0.3 ; // 下巴
    self.foreheadLevel          = 0.3 ; // 额头
    self.noseLevel              = 0.5 ; // 鼻子
    self.mouthLevel             = 0.4 ; // 嘴
    
    /****  美妆程度  ****/
    self.lipstick = 1.0;
    self.blush = 1.0 ;
    self.eyebrow = 1.0 ;
    self.eyeShadow = 1.0 ;
    self.eyeLiner = 1.0 ;
    self.eyelash = 1.0 ;
    self.contactLens = 1.0 ;
    
    self.enableGesture = NO;
    self.enableMaxFaces = NO;
}

/**设置美颜参数*/
- (void)resetAllBeautyParams {
    
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"skin_detect" value:@(self.skinDetectEnable)]; //是否开启皮肤检测
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"heavy_blur" value:@(self.blurShape)]; // 美肤类型 (0、1、) 清晰：0，朦胧：1
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"blur_level" value:@(self.blurLevel * 6.0 )]; //磨皮 (0.0 - 6.0)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"color_level" value:@(self.whiteLevel)]; //美白 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"red_level" value:@(self.redLevel)]; //红润 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"eye_bright" value:@(self.eyelightingLevel)]; // 亮眼
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"tooth_whiten" value:@(self.beautyToothLevel)];// 美牙
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"face_shape" value:@(self.faceShape)]; //美型类型 (0、1、2、3、4)女神：0，网红：1，自然：2，默认：3，自定义：4
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"eye_enlarging" value:self.faceShape == 4 ? @(self.enlargingLevel_new) : @(self.enlargingLevel)]; //大眼 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"cheek_thinning" value:self.faceShape == 4 ? @(self.thinningLevel_new) : @(self.thinningLevel)]; //瘦脸 (0~1)
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_chin" value:@(self.jewLevel)]; /**下巴 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_nose" value:@(self.noseLevel)];/**鼻子 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_forehead" value:@(self.foreheadLevel)];/**额头 (0~1)*/
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"intensity_mouth" value:@(self.mouthLevel)];/**嘴型 (0~1)*/
    //滤镜名称需要小写
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"filter_name" value:[self.selectedFilter lowercaseString]];
    [FURenderer itemSetParam:items[FUMNamaHandleTypeBeauty] withName:@"filter_level" value:@(self.selectedFilterLevel)]; //滤镜程度
}
/**
 加载普通道具
 - 先创建再释放可以有效缓解切换道具卡顿问题
 */
- (void)loadItem:(NSString *)itemName{
    dispatch_async(asyncLoadQueue, ^{
        self.selectedItem = itemName ;
        
        int destoryItem = items[FUMNamaHandleTypeItem];
        
        if (itemName != nil && ![itemName isEqual: @"noitem"]) {
            /**先创建道具句柄*/
            NSString *path = [[NSBundle mainBundle] pathForResource:[itemName stringByAppendingString:@".bundle"] ofType:nil];
            
            int itemHandle = [FURenderer itemWithContentsOfFile:path];
            
            // 人像驱动 设置 3DFlipH
            BOOL isPortraitDrive = [itemName hasPrefix:@"picasso_e"];
            BOOL isAnimoji = [itemName hasSuffix:@"_Animoji"];
            
            if (isPortraitDrive || isAnimoji) {
                [FURenderer itemSetParam:itemHandle withName:@"{\"thing\":\"<global>\",\"param\":\"follow\"}" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"is3DFlipH" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"isFlipExpr" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"isFlipTrack" value:@(1)];
                [FURenderer itemSetParam:itemHandle withName:@"isFlipLight" value:@(1)];
            }
            
            if ([itemName isEqualToString:@"luhantongkuan_ztt_fu"]) {
                [FURenderer itemSetParam:itemHandle withName:@"flip_action" value:@(1)];
            }
            
            if ([itemName isEqualToString:@"ctrl_rain"] || [itemName isEqualToString:@"ctrl_snow"] || [itemName isEqualToString:@"ctrl_flower"]) {//带重力感应道具
                [FURenderer itemSetParam:itemHandle withName:@"rotMode" value:@(self.deviceOrientation)];
                self.isMotionItem = YES;
            }else{
                self.isMotionItem = NO;
            }
            
            if ([itemName isEqualToString:@"fu_lm_koreaheart"]) {//比心道具手动调整下
                 [FURenderer itemSetParam:itemHandle withName:@"handOffY" value:@(-100)];
            }
            /**将刚刚创建的句柄存放在items[FUMNamaHandleTypeItem]中*/
            items[FUMNamaHandleTypeItem] = itemHandle;
            
        }else{
            /**为避免道具句柄被销毁会后仍被使用导致程序出错，这里需要将存放道具句柄的items[FUMNamaHandleTypeItem]设为0*/
            items[FUMNamaHandleTypeItem] = 0;
        }
        NSLog(@"faceunity: load item");
        
        /**后销毁老道具句柄*/
        if (destoryItem != 0)
        {
            NSLog(@"faceunity: destroy item");
            [FURenderer destroyItem:destoryItem];
        }
    });
 
}

#pragma mark -  美妆
/*
 tex_brow 眉毛
 tex_eye 眼影
 tex_pupil 美瞳
 tex_eyeLash 睫毛
 tex_lip 口红
 tex_highlight 口红高光
 //jiemao
 //meimao
 tex_eyeLiner 眼线
 tex_blusher腮红
 */
- (void)setMakeupItemParamImage:(UIImage *)image param:(NSString *)paramStr{
    dispatch_async(makeupQueue, ^{
        if (!image) {
            NSLog(@"美妆图片为空");
            return;
        }
        if (items[FUNamaHandleTypeMakeup]) {
            [[FUManager shareManager] setMakeupItemIntensity:1 param:@"is_makeup_on"];
            int photoWidth = (int)CGImageGetWidth(image.CGImage);
            int photoHeight = (int)CGImageGetHeight(image.CGImage);
            
            unsigned char *imageData = [FUImageHelper getRGBAWithImage:image];
            
            [[FURenderer shareRenderer] setUpCurrentContext];
            fuItemSetParamd(items[FUNamaHandleTypeMakeup], "reverse_alpha", 1.0);
            
            fuCreateTexForItem(items[FUNamaHandleTypeMakeup], (char *)[paramStr UTF8String], imageData, photoWidth, photoHeight);
            [[FURenderer shareRenderer] setBackCurrentContext];
            free(imageData);
        }else{
            NSLog(@"美妆设置--bundle(nil)");
        }
    });
    
}

/*
 is_makeup_on: 1, //美妆开关
 makeup_intensity:1.0, //美妆程度 //下面是每个妆容单独的参数，intensity设置为0即为关闭这种妆效 makeup_intensity_lip:1.0, //kouhong makeup_intensity_pupil:1.0, //meitong
 makeup_intensity_eye:1.0,
 makeup_intensity_eyeLiner:1.0,
 makeup_intensity_eyelash:1.0,
 makeup_intensity_eyeBrow:1.0,
 makeup_intensity_blusher:1.0, //saihong
 makeup_lip_color:[0,0,0,0] //长度为4的数组，rgba颜色值
 makeup_lip_mask:0.0 //嘴唇优化效果开关，1.0为开 0为关
 */
- (void)setMakeupItemIntensity:(float )value param:(NSString *)paramStr{
    
    if (!paramStr && paramStr) {
        NSLog(@"参数为nil");
    }
    dispatch_async(makeupQueue, ^{
        if (items[FUNamaHandleTypeMakeup]) {
            int res = fuItemSetParamd(items[FUNamaHandleTypeMakeup], (char *)[paramStr UTF8String], value);
            if (!res) NSLog(@"美妆设置失败---Parma（%@）---value(%lf)",paramStr,value);
            
        }else{
            NSLog(@"美妆设置--bundle(nil)");
        }
    });
}

- (void)setMakeupItemLipstick:(double *)lipData{
        //    [[FUManager shareManager] setMakeupItemIntensity:1 param:@"is_makeup_on"];
        [[FURenderer shareRenderer] setUpCurrentContext];
        fuItemSetParamd(items[FUNamaHandleTypeMakeup], "reverse_alpha", 1.0);
        fuItemSetParamdv(items[FUNamaHandleTypeMakeup], "makeup_lip_color", lipData, 4);
        [[FURenderer shareRenderer] setBackCurrentContext];
 
//    });
}

#pragma mark -  美发
/**设置美发参数**/
- (void)setHairColor:(int)colorIndex {
    dispatch_async(asyncLoadQueue, ^{
        [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"Index" value:@(colorIndex)]; // 发色
    });
}
- (void)setHairStrength:(float)strength {
    dispatch_async(asyncLoadQueue, ^{
        [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"Strength" value: @(strength)]; // 发色
    });
}

#pragma mark -  render
/**将道具绘制到pixelBuffer*/
- (CVPixelBufferRef)renderItemsToPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
	// 在未识别到人脸时根据重力方向设置人脸检测方向
    if ([self isDeviceMotionChange]) {
          fuSetDefaultOrientation(self.deviceOrientation);
        
        /* 解决旋转屏幕效果异常 onCameraChange*/
        [FURenderer onCameraChange];
    }
    if (self.isMotionItem) {//针对带重力道具
        [FURenderer itemSetParam:items[FUMNamaHandleTypeItem] withName:@"rotMode" value:@(self.deviceOrientation)];
    }    
    /**设置美颜参数*/
    [self resetAllBeautyParams];
    
    /*Faceunity核心接口，将道具及美颜效果绘制到pixelBuffer中，执行完此函数后pixelBuffer即包含美颜及贴纸效果*/
    CVPixelBufferRef buffer = [[FURenderer shareRenderer] renderPixelBuffer:pixelBuffer withFrameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];//flipx 参数设为YES可以使道具做水平方向的镜像翻转
    frameID += 1;
    return buffer;
}


/* 静态图片 */
- (UIImage *)renderItemsToImage:(UIImage *)image{
    int postersWidth = (int)CGImageGetWidth(image.CGImage);
    int postersHeight = (int)CGImageGetHeight(image.CGImage);
    CFDataRef dataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(dataFromImageDataProvider);
    
    [[FURenderer shareRenderer] renderItems:imageData inFormat:FU_FORMAT_RGBA_BUFFER outPtr:imageData outFormat:FU_FORMAT_RGBA_BUFFER width:postersWidth height:postersHeight frameId:frameID items:items itemCount:sizeof(items)/sizeof(int) flipx:YES];
    
    frameID++;
    /* 转回image */
    image = [FUImageHelper convertBitmapRGBA8ToUIImage:imageData withWidth:postersWidth withHeight:postersHeight];
    CFRelease(dataFromImageDataProvider);
    
    return image;
}


#pragma mark -  海报换脸

/* 加载海报合成 */
- (void)loadPoster
{
    if (items[FUNamaHandleTypeChangeface] != 0) {
        [FURenderer destroyItem:items[FUNamaHandleTypeChangeface]];
        items[FUNamaHandleTypeChangeface] = 0;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"change_face.bundle" ofType:nil];
    items[FUNamaHandleTypeChangeface] = [FURenderer itemWithContentsOfFile:path];
}

- (void)destroyItemPoster{
    if (items[FUNamaHandleTypeChangeface] != 0) {
        [FURenderer destroyItem:items[FUNamaHandleTypeChangeface]];
        items[FUNamaHandleTypeChangeface] = 0;
    }
}


- (void)setPosterItemParamImage:(UIImage *)posterImage photo:(UIImage *)photoImage photoLandmarks:(float *)photoLandmarks warpValue:(id)warpValue{
    /* 只加载一个bundle资源 */
    [self destoryItems];
    [self loadPoster];

    /* 海报图像转data */
    int postersWidth = (int)CGImageGetWidth(posterImage.CGImage);
    int postersHeight = (int)CGImageGetHeight(posterImage.CGImage);
    CFDataRef posterDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(posterImage.CGImage));
    GLubyte *posterData = (GLubyte *)CFDataGetBytePtr(posterDataFromImageDataProvider);

    /* 照片图像转data */
    int photoWidth = (int)CGImageGetWidth(photoImage.CGImage);
    int photoHeight = (int)CGImageGetHeight(photoImage.CGImage);
    CFDataRef photoDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(photoImage.CGImage));
    GLubyte *photoData = (GLubyte *)CFDataGetBytePtr(photoDataFromImageDataProvider);

    /* 获取海报的人脸点位 */
    float posterLandmarks[150];
    int endI = 0;
    for (int i = 0; i< 50; i++) {//校验出人脸再trsckFace 5次
        [FURenderer trackFace:FU_FORMAT_RGBA_BUFFER inputData:posterData width:postersWidth height:postersHeight];
        if ([FURenderer isTracking] > 0) {
            if (endI == 0) {
                endI = i;
            }
            if (i > endI + 5) {
                break;
            }
        }
    }
    
   int ret = [FURenderer getFaceInfo:0 name:@"landmarks" pret:posterLandmarks number:150];
    if (ret == 0) {
        memset(posterLandmarks, 0, sizeof(float)*150);
    }

    double poster[150];
    double photo[150];
    
    /* 将点位信息用double表示 */
    for (int i = 0; i < 150; i ++) {
        poster[i] = (double)posterLandmarks[i];
        photo[i]  = (double)photoLandmarks[i];
    }

    /* 参数设置，注意：当前上下文改变，需要设置setUpCurrentContext */
    [[FURenderer shareRenderer] setUpCurrentContext];
    /* 照片 */
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "input_width", photoWidth);
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "input_height", photoHeight);
    fuItemSetParamdv(items[FUNamaHandleTypeChangeface], "input_face_points", photo, 150);
    fuCreateTexForItem(items[FUNamaHandleTypeChangeface], "tex_input", photoData, photoWidth, photoHeight);
    /* 模板海报 */
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "template_width", postersWidth);
    fuItemSetParamd(items[FUNamaHandleTypeChangeface], "template_height", postersHeight);
    fuItemSetParamdv(items[FUNamaHandleTypeChangeface], "template_face_points", poster, 150);
    if (warpValue) {//特殊模板，设置弯曲度
        fuItemSetParamd(items[FUNamaHandleTypeChangeface], "warp_intensity", [warpValue doubleValue]);
    }
    fuCreateTexForItem(items[FUNamaHandleTypeChangeface], "tex_template", posterData, postersWidth, postersHeight);
    [[FURenderer shareRenderer] setBackCurrentContext];

    
    CFRelease(posterDataFromImageDataProvider);
    CFRelease(photoDataFromImageDataProvider);
}

#pragma mark -  动漫滤镜
/* 关闭开启动漫滤镜 */
- (void)loadFilterAnimoji:(NSString *)itemName style:(int)style{
    
    dispatch_async(asyncLoadQueue, ^{
        
        if (itemName != nil && ![itemName isEqual: @"noitem"]) {
            if (items[FUNamaHandleTypeComic] == 0) {
                NSString *path = [[NSBundle mainBundle] pathForResource:@"fuzzytoonfilter.bundle" ofType:nil];
                int itemHandle = [FURenderer itemWithContentsOfFile:path];
                self.currentBoudleName = @"fuzzytoonfilter";
                items[FUNamaHandleTypeComic] = itemHandle;
            }
            [FURenderer itemSetParam:items[FUNamaHandleTypeComic] withName:@"style" value:@(style)];
        }else{
            if (items[FUNamaHandleTypeComic] != 0){
                [FURenderer destroyItem:items[FUNamaHandleTypeComic]];
            }
            items[FUNamaHandleTypeComic] = 0;
            self.currentBoudleName = @"";
        }
    });
}

#pragma mark -  异图
- (void)setEspeciallyItemParamImage:(UIImage *)image group_points:(NSArray *)g_points group_type:(NSArray *)g_type{
    if (!image) {
        NSLog(@"error -- 图片不为空");
        return;
    }
    if (!g_points.count) {
        NSLog(@"error -- 点位数组为空");
        return;
    }
    if (!g_type.count) {
        NSLog(@"error -- 类型参数空");
        return;
    }
    int imageWidth = (int)CGImageGetWidth(image.CGImage);
    int imageHeight = (int)CGImageGetHeight(image.CGImage);
    CFDataRef photoDataFromImageDataProvider = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    GLubyte *imageData = (GLubyte *)CFDataGetBytePtr(photoDataFromImageDataProvider);
    
    int pointCount = (int)g_points.count;
    int typeCount  = (int)g_type.count;

    double *points = (double *)malloc(pointCount * sizeof(double));
    double *types = (double *)malloc(typeCount * sizeof(double));
    for (int i =0; i < pointCount; i ++) {
        points[i] = [g_points[i] doubleValue];
    }
    for (int i =0; i < typeCount; i ++) {
        types[i] = [g_type[i] doubleValue];
    }
    
    if (items[FUNamaHandleTypePhotolive] == 0) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"photolive" ofType:@"bundle"];
        items[FUNamaHandleTypePhotolive] = [FURenderer itemWithContentsOfFile:filePath];
    }
    
    /* 移除意图纹理 */
    fuDeleteTexForItem(items[FUNamaHandleTypePhotolive], "tex_input");
    fuItemSetParamd(items[FUNamaHandleTypePhotolive], "target_width", imageWidth);
    fuItemSetParamd(items[FUNamaHandleTypePhotolive], "target_height", imageHeight);
    /* 五官类型数组 */
    fuItemSetParamdv(items[FUNamaHandleTypePhotolive], "group_type", types, typeCount);
    /* 类型对应的五官，在效果图片中的位置 */
    fuItemSetParamdv(items[FUNamaHandleTypePhotolive], "group_points", points, pointCount);
    /* 创建意图纹理 */
    fuCreateTexForItem(items[FUNamaHandleTypePhotolive], "tex_input", imageData, imageWidth, imageHeight);
    
    free(points);
    free(types);
    CFRelease(photoDataFromImageDataProvider);
    
}



#pragma mark -  nama查询&设置
- (void)setAsyncTrackFaceEnable:(BOOL)enable{
    [FURenderer setAsyncTrackFaceEnable:enable];
}

- (void)setEnableGesture:(BOOL)enableGesture
{
    _enableGesture = enableGesture;
    /**开启手势识别*/
    if (_enableGesture) {
        [self loadGesture];
    }else{
        if (items[FUNamaHandleTypeGesture] != 0) {
            
            NSLog(@"faceunity: destroy gesture");
            
            [FURenderer destroyItem:items[FUNamaHandleTypeGesture]];
            
            items[FUNamaHandleTypeGesture] = 0;
        }
    }
}

/**开启多脸识别（最高可设为8，不过考虑到性能问题建议设为4以内*/
- (void)setEnableMaxFaces:(BOOL)enableMaxFaces
{
    if (_enableMaxFaces == enableMaxFaces) {
        return;
    }
    
    _enableMaxFaces = enableMaxFaces;
    
    if (_enableMaxFaces) {
        [FURenderer setMaxFaces:4];
    }else{
        [FURenderer setMaxFaces:1];
    }
    
}

/**获取图像中人脸中心点*/
- (CGPoint)getFaceCenterInFrameSize:(CGSize)frameSize{
    
    static CGPoint preCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preCenter = CGPointMake(0.49, 0.5);
    });
    
    // 获取人脸矩形框，坐标系原点为图像右下角，float数组为矩形框右下角及左上角两个点的x,y坐标（前两位为右下角的x,y信息，后两位为左上角的x,y信息）
    float faceRect[4];
    int ret = [FURenderer getFaceInfo:0 name:@"face_rect" pret:faceRect number:4];
    
    if (ret == 0) {
        return preCenter;
    }
    
    // 计算出中心点的坐标值
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    
    // 将坐标系转换成以左上角为原点的坐标系
    centerX = frameSize.width - centerX;
    centerX = centerX / frameSize.width;
    
    centerY = frameSize.height - centerY;
    centerY = centerY / frameSize.height;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    preCenter = center;
    
    return center;
}

/**获取75个人脸特征点*/
- (void)getLandmarks:(float *)landmarks index:(int)index;
{
    int ret = [FURenderer getFaceInfo:index name:@"landmarks" pret:landmarks number:150];
    
    if (ret == 0) {
        memset(landmarks, 0, sizeof(float)*150);
    }
}

- (CGRect)getFaceRectWithIndex:(int)index size:(CGSize)renderImageSize{
    CGRect rect = CGRectZero ;
    float faceRect[4];
    
    [FURenderer getFaceInfo:index name:@"face_rect" pret:faceRect number:4];
    
    CGFloat centerX = (faceRect[0] + faceRect[2]) * 0.5;
    CGFloat centerY = (faceRect[1] + faceRect[3]) * 0.5;
    CGFloat width = faceRect[2] - faceRect[0] ;
    CGFloat height = faceRect[3] - faceRect[1] ;
    
    centerX = renderImageSize.width - centerX;
    centerX = centerX / renderImageSize.width;
    
    centerY = renderImageSize.height - centerY;
    centerY = centerY / renderImageSize.height;
    
    width = width / renderImageSize.width ;
    
    height = height / renderImageSize.height ;
    
    CGPoint center = CGPointMake(centerX, centerY);
    
    CGSize size = CGSizeMake(width, height) ;
    
    rect.origin = CGPointMake(center.x - size.width / 2.0, center.y - size.height / 2.0) ;
    rect.size = size ;
    
    
    return rect ;
}


/**判断是否检测到人脸*/
- (BOOL)isTracking
{
    return [FURenderer isTracking] > 0;
}

/**切换摄像头要调用此函数*/
- (void)onCameraChange{
    [FURenderer onCameraChange];
}

/**获取错误信息*/
- (NSString *)getError
{
    // 获取错误码
    int errorCode = fuGetSystemError();
    
    if (errorCode != 0) {
        
        // 通过错误码获取错误描述
        NSString *errorStr = [NSString stringWithUTF8String:fuGetSystemErrorString(errorCode)];
        
        return errorStr;
    }
    
    return nil;
}


/**判断 SDK 是否是 lite 版本**/
- (BOOL)isLiteSDK {
    NSString *version = [FURenderer getVersion];
    return [version containsString:@"lite"];
}


//保证正脸
- (BOOL)isGoodFace:(int)index{
    // 保证正脸
    float rotation[4] ;
    float DetectionAngle = 15.0 ;
    [FURenderer getFaceInfo:index name:@"rotation" pret:rotation number:4];
    
    float q0 = rotation[0];
    float q1 = rotation[1];
    float q2 = rotation[2];
    float q3 = rotation[3];
    
    float z =  atan2(2*(q0*q1 + q2 * q3), 1 - 2*(q1 * q1 + q2 * q2)) * 180 / M_PI;
    float y =  asin(2 *(q0*q2 - q1*q3)) * 180 / M_PI;
    float x = atan(2*(q0*q3 + q1*q2)/(1 - 2*(q2*q2 + q3*q3))) * 180 / M_PI;
    NSLog(@"x=%lf  y=%lf z=%lf",x,y,z);
    if (x > DetectionAngle || x < - 5 || fabs(y) > DetectionAngle || fabs(z) > DetectionAngle) {//抬头低头角度限制：仰角不大于5°，俯角不大于15°
        return NO;
    }
    
    return YES;
}

/* 是否夸张 */
- (BOOL)isExaggeration:(int)index{
    float expression[46] ;
    [FURenderer getFaceInfo:index name:@"expression" pret:expression number:46];
    
    for (int i = 0 ; i < 46; i ++) {
        
        if (expression[i] > 0.60) {
            
            return YES;
        }
    }
    return NO;
}


#pragma mark -  其他

/** 根据证书判断权限
 *  有权限的排列在前，没有权限的在后
 */
- (void)setupItemDataSource
{
    
    NSMutableArray *modesArray = [NSMutableArray arrayWithCapacity:1];
    NSArray *dataArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dataSource.plist" ofType:nil]];
    
    NSInteger count = dataArray.count;
    for (int i = 0 ; i < count; i ++) {
        NSDictionary *dict = dataArray[i] ;
        
        FULiveModel *model = [[FULiveModel alloc] init];
        NSString *itemName = dict[@"itemName"] ;
        model.title = itemName ;
        model.maxFace = [dict[@"maxFace"] integerValue] ;
        model.enble = NO;
        model.type = i;
        model.modules = dict[@"modules"] ;
        model.items = dict[@"items"] ;
        [modesArray addObject:model];
    }
    
    int module = fuGetModuleCode(0) ;
    
    if (!module) {
        
        _dataSource = [NSMutableArray arrayWithCapacity:1];
        
        for (FULiveModel *model in modesArray) {
            
            model.enble = YES ;
            [_dataSource addObject:model] ;
        }
        
        return ;
    }
    
    int insertIndex = 0;
    _dataSource = [modesArray mutableCopy];
    
    for (FULiveModel *model in modesArray) {
        
        if ([model.title isEqualToString:@"背景分割"] || [model.title isEqualToString:@"手势识别"]) {
            if ([self isLiteSDK]) {
                continue ;
            }
        }
        
        for (NSNumber *num in model.modules) {
            
            BOOL isEable = module & [num intValue] ;
            
            if (isEable) {
                
                [_dataSource removeObject:model];
                
                model.enble = YES ;
                
                [_dataSource insertObject:model atIndex:insertIndex] ;
                insertIndex ++ ;
                
                break ;
            }
        }
    }
}


- (NSArray<FULiveModel *> *)dataSource {
    
    return _dataSource ;
}


/**
 获取item的提示语
 
 @param item 道具名
 @return 提示语
 */
- (NSString *)hintForItem:(NSString *)item
{
    return self.hintDic[item];
}

#pragma mark -  重力感应
- (void)setupDeviceMotion{
    
    // 初始化陀螺仪
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;// 1s刷新一次
    
    if ([self.motionManager isDeviceMotionAvailable]) {
       [self.motionManager startAccelerometerUpdates];
    }
}

#pragma mark -  设备类型 
- (BOOL)isDeviceMotionChange{
//    if (![FURenderer isTracking]) {
        CMAcceleration acceleration = self.motionManager.accelerometerData.acceleration ;
        int orientation = 0;
        if (acceleration.x >= 0.75) {
            orientation = 3;
        } else if (acceleration.x <= -0.75) {
            orientation = 1;
        } else if (acceleration.y <= -0.75) {
            orientation = 0;
        } else if (acceleration.y >= 0.75) {
            orientation = 2;
        }
        
        if (self.deviceOrientation != orientation) {
            self.deviceOrientation = orientation ;
            return YES;
        }
//    }
    return NO;
}

@end
