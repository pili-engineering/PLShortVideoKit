#import "GPUImageFilter.h"
#import "KWRenderProtocol.h"

/**
 pear face of distorting mirror
 */
@interface PearFaceDistortionFilter : GPUImageFilter <KWRenderProtocol>
{
    GLint aspectRatioUniform, radiusUniform, newradiusUniform, centerUniform, scaleUniform, centerbottomUniform,
            leftpointUniform, rightpointUniform;
    GLfloat y_scaleUniform;
}

/** The center about which to apply the distortion, with a default of (0.5, 0.5)
 */
@property(readwrite, nonatomic) CGPoint center;
@property(readwrite, nonatomic) CGPoint centerbottom;
@property(readwrite, nonatomic) CGPoint leftpoint;
@property(readwrite, nonatomic) CGPoint rightpoint;
/** The radius of the distortion, ranging from 0.0 to 2.0, with a default of 1.0
 */
@property(readwrite, nonatomic) CGFloat radius;
@property(readwrite, nonatomic) CGFloat newradius;
/** The amount of distortion to apply, from -2.0 to 2.0, with a default of 0.5
 */
@property(readwrite, nonatomic) CGFloat scale;

@property(readwrite, nonatomic) CGFloat y_scale;

@property(nonatomic, copy) NSArray<NSArray *> *faces;

@end
