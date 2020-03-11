#import <Foundation/Foundation.h>
#import "SLGPUImageContext.h"

@protocol SLGPUImageTextureOutputDelegate;

@interface SLGPUImageTextureOutput : NSObject <SLGPUImageInput>
{
    SLGPUImageFramebuffer *firstInputFramebuffer;
}

@property(readwrite, unsafe_unretained, nonatomic) id<SLGPUImageTextureOutputDelegate> delegate;
@property(readonly) GLuint texture;
@property(nonatomic) BOOL enabled;

- (void)doneWithTexture;

@end

@protocol SLGPUImageTextureOutputDelegate
- (void)newFrameReadyFromTextureOutput:(SLGPUImageTextureOutput *)callbackTextureOutput;
@end
