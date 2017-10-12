#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"
#import "GPUImage.h"
#import "GPUImageFourInputFilter.h"

@interface InkwellFilter : GPUImageTwoInputFilter

@end

@interface Inkwell : GPUImageFilterGroup <KWRenderProtocol>
{
    GPUImagePicture *imageSource;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
