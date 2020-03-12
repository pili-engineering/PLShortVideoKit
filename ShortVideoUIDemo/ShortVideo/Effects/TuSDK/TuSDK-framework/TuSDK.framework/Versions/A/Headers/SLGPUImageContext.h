#import "SLGLProgram.h"
#import "SLGPUImageFramebuffer.h"
#import "SLGPUImageFramebufferCache.h"

#define LSQGPUImageRotationSwapsWidthAndHeight(rotation) ((rotation) == LSQKGPUImageRotateLeft || (rotation) == LSQKGPUImageRotateRight || (rotation) == LSQKGPUImageRotateRightFlipVertical || (rotation) == LSQKGPUImageRotateRightFlipHorizontal)

typedef NS_ENUM(NSUInteger, LSQGPUImageRotationMode) {
	LSQKGPUImageNoRotation,
	LSQKGPUImageRotateLeft,
	LSQKGPUImageRotateRight,
	LSQKGPUImageFlipVertical,
	LSQKGPUImageFlipHorizonal,
	LSQKGPUImageRotateRightFlipVertical,
	LSQKGPUImageRotateRightFlipHorizontal,
	LSQKGPUImageRotate180
};

@interface SLGPUImageContext : NSObject

@property(readonly, nonatomic) dispatch_queue_t contextQueue;
@property(readwrite, retain, nonatomic) SLGLProgram *currentShaderProgram;
@property(readonly, retain, nonatomic) EAGLContext *context;
@property(readonly) CVOpenGLESTextureCacheRef coreVideoTextureCache;
@property(readonly) SLGPUImageFramebufferCache *framebufferCache;

+ (void *)contextKey;
+ (SLGPUImageContext *)sharedImageProcessingContext;
+ (dispatch_queue_t)sharedContextQueue;
+ (SLGPUImageFramebufferCache *)sharedFramebufferCache;
+ (void)useImageProcessingContext;
- (void)useAsCurrentContext;
+ (void)setActiveShaderProgram:(SLGLProgram *)shaderProgram;
- (void)setContextShaderProgram:(SLGLProgram *)shaderProgram;
+ (GLint)maximumTextureSizeForThisDevice;
+ (GLint)maximumTextureUnitsForThisDevice;
+ (GLint)maximumVaryingVectorsForThisDevice;
+ (BOOL)deviceSupportsOpenGLESExtension:(NSString *)extension;
+ (BOOL)deviceSupportsRedTextures;
+ (BOOL)deviceSupportsFramebufferReads;
+ (CGSize)sizeThatFitsWithinATextureForSize:(CGSize)inputSize;

- (void)presentBufferForDisplay;
- (SLGLProgram *)programForVertexShaderString:(NSString *)vertexShaderString fragmentShaderString:(NSString *)fragmentShaderString;

- (void)useSharegroup:(EAGLSharegroup *)sharegroup;

// Manage fast texture upload
+ (BOOL)supportsFastTextureUpload;

@end

@protocol SLGPUImageInput <NSObject>
- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex;
- (void)setInputFramebuffer:(SLGPUImageFramebuffer *)newInputFramebuffer atIndex:(NSInteger)textureIndex;
- (NSInteger)nextAvailableTextureIndex;
- (void)setInputSize:(CGSize)newSize atIndex:(NSInteger)textureIndex;
- (void)setInputRotation:(LSQGPUImageRotationMode)newInputRotation atIndex:(NSInteger)textureIndex;
- (CGSize)maximumOutputSize;
- (void)endProcessing;
- (BOOL)shouldIgnoreUpdatesToThisTarget;
- (BOOL)enabled;
- (BOOL)wantsMonochromeInput;
- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;
@end
