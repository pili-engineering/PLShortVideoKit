#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"
#import "GPUImage.h"

@interface LomoFilter : GPUImageThreeInputFilter

@end

@interface Lomo : GPUImageFilterGroup <KWRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
}
@property(nonatomic, readonly) BOOL needTrackData;

@end
