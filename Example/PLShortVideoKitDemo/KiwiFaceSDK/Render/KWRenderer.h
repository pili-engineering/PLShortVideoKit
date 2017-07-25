//
//  KWRenderer.h
//  PLMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/11/29.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceTracker.h"


#import "KWPointsRenderer.h"
#import "KWStickerRenderer.h"

#import "SquareFaceDistortionFilter.h"
#import "KWBeautifyFilter.h"
#import "KWColorFilter.h"
#import "SmallFaceBigEyeFilter.h"
#import "Global.h"


/**
 Video frame rendering class
 */
@interface KWRenderer : NSObject

/**
 The execution block of the operation can be customized before the video frame is captured after rendering
 
 @param pixels pixelbuffer
 @param format 0：bgra 1：yuv
 @param width width value of pixelbuffer
 @param height height value of pixelbuffer
 @param p_result the result of track faces
 @param rstNum the face count of tracker
 @param orientation the orientation of device
 @param faceNum max track faces count
 */
typedef void (^RenderAndGetFacePointsBlock)(unsigned char *pixels, int format, int width, int height,result_68_t *p_result, int rstNum, int orientation,int faceNum);

// The maximum number of detectable faces, ranging from 1 to 4, defaults to 4
@property (nonatomic) NSUInteger maxFaceNumber;

@property (nonatomic, readonly) NSArray *filters;

//Forces face capture to stop
@property (nonatomic, assign) BOOL isStopTracker;

//Whether low frequency Tracker
@property (nonatomic, assign) BOOL isLowFrequencyTracker;

//Whether to open the face stickers
@property (nonatomic, assign) BOOL isEnableSmiliesSticker;

@property (nonatomic, copy)RenderAndGetFacePointsBlock kwRenderBlock;

//@property (nonatomic,assign) NSInteger trackResultState;

@property (nonatomic,assign) BOOL trackResultState;

- (void)addFilter:(GPUImageOutput<GPUImageInput, KWRenderProtocol> *)filter;
- (void)removeFilter:(GPUImageOutput<GPUImageInput, KWRenderProtocol> *)filter;

- (void)removeAllFilters;

- (NSInteger)getAllUsingFiltersCount;

- (void)processPixelBuffer:(CVPixelBufferRef)pixelBuffer withRotation:(cv_rotate_type)rotation mirrored:(BOOL)isMirrored;

- (instancetype)initWithModelPath:(NSString *)modelPath;

+ (BOOL)isSdkInitFailed;

//检查表情贴纸是否正在播放
- (BOOL)checkSmiliesSticker:(GPUImageFilter *)filter;

+ (float)beautyParamWithValue:(float)value type:(KW_NEWBEAUTY_TYPE)type;

@end
