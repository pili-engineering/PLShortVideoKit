#import "GPUImageFilter.h"
#import "KWRenderProtocol.h"
#import "Global.h"
/**
 Big eyes, face-lift integrated class
 */
@interface SmallFaceBigEyeFilter : GPUImageFilter <KWRenderProtocol>
{
    GLint aspectRatioUniform, location0Uniform,location1Uniform,location2Uniform,location3Uniform,location4Uniform,location5Uniform,location6Uniform,location7Uniform,thinparamUniform,eyeparamUniform;
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

@property(readwrite, nonatomic) CGFloat thinparam;
@property(readwrite, nonatomic) CGFloat eyeparam;  //0.05 - 0.3
@property(readwrite, nonatomic) CGFloat y_scale;
@property (nonatomic, copy) NSArray<NSArray *> *faces;
@property (nonatomic, readonly) BOOL needTrackData;

- (void)setParam:(float)value withType:(KW_NEWBEAUTY_TYPE)type;


@end
