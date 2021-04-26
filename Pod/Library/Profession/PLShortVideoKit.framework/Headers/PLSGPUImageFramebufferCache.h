#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "PLSGPUImageFramebuffer.h"

@interface PLSGPUImageFramebufferCache : NSObject

// Framebuffer management
- (PLSGPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize textureOptions:(PLSGPUTextureOptions)textureOptions onlyTexture:(BOOL)onlyTexture;
- (PLSGPUImageFramebuffer *)fetchFramebufferForSize:(CGSize)framebufferSize onlyTexture:(BOOL)onlyTexture;
- (void)returnFramebufferToCache:(PLSGPUImageFramebuffer *)framebuffer;
- (void)purgeAllUnassignedFramebuffers;
- (void)addFramebufferToActiveImageCaptureList:(PLSGPUImageFramebuffer *)framebuffer;
- (void)removeFramebufferFromActiveImageCaptureList:(PLSGPUImageFramebuffer *)framebuffer;

@end
