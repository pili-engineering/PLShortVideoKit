#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "SLGPUImageFramebuffer.h"

@interface SLGPUImageFramebufferCache : NSObject

// Framebuffer management
- (SLGPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(LSQGPUTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (SLGPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(SLGPUImageFramebuffer *)framebuffer;
- (void)purgeAllUnassignedFramebuffers;
- (void)addFramebufferToActiveImageCaptureList:(SLGPUImageFramebuffer *)framebuffer;
- (void)removeFramebufferFromActiveImageCaptureList:(SLGPUImageFramebuffer *)framebuffer;

@end
