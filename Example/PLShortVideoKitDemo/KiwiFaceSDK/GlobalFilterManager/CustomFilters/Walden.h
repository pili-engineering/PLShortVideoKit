#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"
#import "GPUImage.h"
#import "GPUImageFourInputFilter.h"

@interface WaldenFilter : GPUImageThreeInputFilter

@end

@interface Walden : GPUImageFilterGroup <KWRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
