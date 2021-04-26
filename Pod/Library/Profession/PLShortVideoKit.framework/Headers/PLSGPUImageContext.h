#import "PLSGLProgram.h"
#import "PLSGPUImageFramebuffer.h"
#import "PLSGPUImageFramebufferCache.h"

#define PLSGPUImageRotationSwapsWidthAndHeight(rotation) ((rotation) == kPLSGPUImageRotateLeft || (rotation) == kPLSGPUImageRotateRight || (rotation) == kPLSGPUImageRotateRightFlipVertical || (rotation) == kPLSGPUImageRotateRightFlipHorizontal)

typedef NS_ENUM(NSUInteger, PLSGPUImageRotationMode) {
	kPLSGPUImageNoRotation,
	kPLSGPUImageRotateLeft,
	kPLSGPUImageRotateRight,
	kPLSGPUImageFlipVertical,
	kPLSGPUImageFlipHorizonal,
	kPLSGPUImageRotateRightFlipVertical,
	kPLSGPUImageRotateRightFlipHorizontal,
	kPLSGPUImageRotate180
};

@interface PLSGPUImageContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readwrite, retain, nonatomic) PLSGLProgram *currentShaderProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) PLSGPUImageFramebufferCache *framebufferCache;

+ (void *)contextKey;
+ (PLSGPUImageContext *)sharedImageProcessingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (PLSGPUImageFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveShaderProgram:(PLSGLProgram *)shaderProgram;
- (void)setContextShaderProgram:(PLSGLProgram *)shaderProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

- (void)presentBufferForDisplay;
- (PLSGLProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

// Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;

+ (BOOL)supportsFastTextureUploadForPLSGPUImageMovie;

@end

@protocol PLSGPUImageInput <NSObject>
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
- (void)setInputFramebuffer:(PLSGPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
- (NSInteger)nextAvailableTextureIndex;
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
- (void)setInputRotation:(PLSGPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (CGSize)maximumOutputSize;
- (void)endProcessing;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
@end
