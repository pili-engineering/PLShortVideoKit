#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"

@class GPUImagePicture;



@interface KWColorFilter : GPUImageFilterGroup <KWRenderProtocol>

@property(nonatomic, assign) CGImageRef currentImage;

@property(nonatomic, strong) GPUImagePicture *lookupImageSource;

@property(nonatomic, readonly) BOOL needTrackData;

@property(nonatomic, strong) NSString *colorFilterName;

@property(nonatomic, strong) NSString *colorFilterDir;


/**
 根据图片路径 初始化滤镜类
 */
- (id)initWithDir:(NSString *)colorFilterDir;

@end
