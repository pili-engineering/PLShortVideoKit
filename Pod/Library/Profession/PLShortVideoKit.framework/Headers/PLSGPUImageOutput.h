#import "PLSGPUImageContext.h"
#import "PLSGPUImageFramebuffer.h"

#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
// For now, just redefine this on the Mac
typedef NS_ENUM(NSInteger, PLSUIImageOrientation) {
    PLSUIImageOrientationUp,            // default orientation
    PLSUIImageOrientationDown,          // 180 deg rotation
    PLSUIImageOrientationLeft,          // 90 deg CCW
    PLSUIImageOrientationRight,         // 90 deg CW
    PLSUIImageOrientationUpMirrored,    // as above but image mirrored along other axis. horizontal flip
    PLSUIImageOrientationDownMirrored,  // horizontal flip
    PLSUIImageOrientationLeftMirrored,  // vertical flip
    PLSUIImageOrientationRightMirrored, // vertical flip
};
#endif

dispatch_queue_attr_t PLSGPUImageDefaultQueueAttribute(void);
void runPLSOnMainQueueWithoutDeadlocking(void (^block)(void));
void runPLSSynchronouslyOnVideoProcessingQueue(void (^block)(void));
void runPLSAsynchronouslyOnVideoProcessingQueue(void (^block)(void));
void runPLSSynchronouslyOnContextQueue(PLSGPUImageContext *context, void (^block)(void));
void runPLSAsynchronouslyOnContextQueue(PLSGPUImageContext *context, void (^block)(void));
void reportPLSAvailableMemoryForPLSGPUImage(NSString *tag);

@class PLSGPUImageMovieWriter;

/*! PLSGPUImage's base source object
 
 Images or frames of video are uploaded from source objects, which are subclasses of PLSGPUImageOutput. These include:
 
 - PLSGPUImageVideoCamera (for live video from an iOS camera) 
 - PLSGPUImageStillCamera (for taking photos with the camera)
 - PLSGPUImagePicture (for still images)
 - PLSGPUImageMovie (for movies)
 
 Source objects upload still image frames to OpenGL ES as textures, then hand those textures off to the next objects in the processing chain.
 */

@interface PLSGPUImageOutput : NSObject
{
    PLSGPUImageFramebuffer *outputFramebuffer;
    
    NSMutableArray *targets, *targetTextureIndices;
    
    CGSize inputTextureSize, cachedMaximumOutputSize, forcedMaximumSize;
    
    BOOL overrideInputSize;
    
    BOOL allTargetsWantMonochromeData;
    BOOL usingNextFrameForImageCapture;
}

@property(readwrite, nonatomic) BOOL shouldSmoothlyScaleOutput;
@property(readwrite, nonatomic) BOOL shouldIgnoreUpdatesToThisTarget;
@property(readwrite, nonatomic, retain) PLSGPUImageMovieWriter *audioEncodingTarget;
@property(readwrite, nonatomic, unsafe_unretained) id<PLSGPUImageInput> targetToIgnoreForUpdates;
@property(nonatomic, copy) void(^frameProcessingCompletionBlock)(PLSGPUImageOutput*, CMTime);
@property(nonatomic) BOOL enabled;
@property(readwrite, nonatomic) PLSGPUTextureOptions outputTextureOptions;

/// @name Managing targets
- (void)setInputFramebufferForTarget:(id<PLSGPUImageInput>)target atIndex:(NSInteger)inputTextureIndex;
- (PLSGPUImageFramebuffer *)framebufferForOutput;
- (void)removeOutputFramebuffer;
- (void)notifyTargetsAboutNewOutputTexture;

/*! Returns an array of the current targets.
 */
- (NSArray*)targets;

/*! Adds a target to receive notifications when new frames are available.
 
 The target will be asked for its next available texture.
 
 See [PLSGPUImageInput newFrameReadyAtTime:]
 
 @param newTarget Target to be added
 */
- (void)addTarget:(id<PLSGPUImageInput>)newTarget;

/*! Adds a target to receive notifications when new frames are available.
 
 See [PLSGPUImageInput newFrameReadyAtTime:]
 
 @param newTarget Target to be added
 */
- (void)addTarget:(id<PLSGPUImageInput>)newTarget atTextureLocation:(NSInteger)textureLocation;

/*! Removes a target. The target will no longer receive notifications when new frames are available.
 
 @param targetToRemove Target to be removed
 */
- (void)removeTarget:(id<PLSGPUImageInput>)targetToRemove;

/*! Removes all targets.
 */
- (void)removeAllTargets;

/// @name Manage the output texture

- (void)forceProcessingAtSize:(CGSize)frameSize;
- (void)forceProcessingAtSizeRespectingAspectRatio:(CGSize)frameSize;

/// @name Still image processing

- (void)useNextFrameForImageCapture;
- (CGImageRef)newCGImageFromCurrentlyProcessedOutput;
- (CGImageRef)newCGImageByFilteringCGImage:(CGImageRef)imageToFilter;

// Platform-specific image output methods
// If you're trying to use these methods, remember that you need to set -useNextFrameForImageCapture before running -processImage or running video and calling any of these methods, or you will get a nil image
#if TARGET_IPHONE_SIMULATOR || TARGET_OS_IPHONE
- (UIImage *)imageFromCurrentFramebuffer;
- (UIImage *)imageFromCurrentFramebufferWithOrientation:(UIImageOrientation)imageOrientation;
- (UIImage *)imageByFilteringImage:(UIImage *)imageToFilter;
- (CGImageRef)newCGImageByFilteringImage:(UIImage *)imageToFilter;
#else
- (NSImage *)imageFromCurrentFramebuffer;
- (NSImage *)imageFromCurrentFramebufferWithOrientation:(UIImageOrientation)imageOrientation;
- (NSImage *)imageByFilteringImage:(NSImage *)imageToFilter;
- (CGImageRef)newCGImageByFilteringImage:(NSImage *)imageToFilter;
#endif

- (BOOL)providesMonochromeOutput;

@end
