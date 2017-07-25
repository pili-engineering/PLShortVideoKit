#import "GPUImageFilter.h"
#import "KWRenderProtocol.h"
#import "Global.h"
@interface NewBeautyFilter : GPUImageFilter<KWRenderProtocol>
{
    GLint aspectRatioUniform,smoothparamUniform,hueparamUniform,rouparamUniform,satparamUniform;
}

@property(readwrite, nonatomic) CGFloat smoothparam;    //      facial whitening  0.95-0.5
@property(readwrite, nonatomic) CGFloat hueparam;       //      skin smoothing  0.95-0.4
@property(readwrite, nonatomic) CGFloat rouparam;       //      skin tone saturation  0.05-0.9
@property(readwrite, nonatomic) CGFloat satparam;       //      skin shinning tenderness  0.05-0.4

@property (nonatomic, readonly) BOOL needTrackData;

- (void)setParam:(float)value withType:(KW_NEWBEAUTY_TYPE)type;

@end
