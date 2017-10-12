#import "GPUImageFilter.h"
#import "KWRenderProtocol.h"

/**
 slimface of distorting mirror
 */
@interface SlimFaceDistortionFilter : GPUImageFilter <KWRenderProtocol>
{
    GLint aspectRatioUniform, location0Uniform, location1Uniform, location2Uniform, location3Uniform, location4Uniform,
            location5Uniform, location6Uniform, location7Uniform;
    GLfloat y_scaleUniform;
}

/// The center about which to apply the distortion, with a default of (0.5, 0.5)
@property(readwrite, nonatomic) CGPoint location0;
@property(readwrite, nonatomic) CGPoint location1;
@property(readwrite, nonatomic) CGPoint location2;
@property(readwrite, nonatomic) CGPoint location3;
@property(readwrite, nonatomic) CGPoint location4;
@property(readwrite, nonatomic) CGPoint location5;
@property(readwrite, nonatomic) CGPoint location6;
@property(readwrite, nonatomic) CGPoint location7;
@property(readwrite, nonatomic) CGFloat y_scale;

@property(nonatomic, copy) NSArray<NSArray *> *faces;


@end
