#import "GPUImageTwoInputFilter.h"
#import "KWRenderProtocol.h"
#import "GPUImage.h"

@interface NashvilleFilter : GPUImageTwoInputFilter


@end

@interface Nashville : GPUImageFilterGroup <KWRenderProtocol>
{
    GPUImagePicture *imageSource;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
