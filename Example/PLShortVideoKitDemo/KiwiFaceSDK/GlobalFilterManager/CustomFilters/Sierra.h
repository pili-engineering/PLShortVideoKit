#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"
#import "GPUImage.h"
#import "GPUImageFourInputFilter.h"

@interface SierraFilter : GPUImageFourInputFilter

@end

@interface Sierra : GPUImageFilterGroup <KWRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
