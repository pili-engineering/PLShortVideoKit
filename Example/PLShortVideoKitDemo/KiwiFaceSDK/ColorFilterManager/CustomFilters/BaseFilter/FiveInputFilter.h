#import "GPUImageFourInputFilter.h"
#import "KWRenderProtocol.h"

@interface FiveInputFilter : GPUImageFourInputFilter<KWRenderProtocol>
{
    GPUImageFramebuffer *fifthInputFramebuffer;
    
    GLint filterFifthTextureCoordinateAttribute;
    GLint filterInputTextureUniform5;
    GPUImageRotationMode inputRotation5;
    GLuint filterSourceTexture5;
    CMTime fifthFrameTime;
    
    BOOL hasSetFourthTexture, hasReceivedFifthFrame, fifthFrameWasVideo;
    BOOL fifthFrameCheckDisabled;
}


- (void)disableFifthFrameCheck;

@end
