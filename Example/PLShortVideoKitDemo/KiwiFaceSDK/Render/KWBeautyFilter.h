#import "GPUImageFilter.h"
#import "KWRenderProtocol.h"
#import "Global.h"

@interface KWBeautyFilter : GPUImageFilter<KWRenderProtocol> {
    GLint brightLevelUniform,paramsUniform,pinkLevelUniform;
}

@property (nonatomic, assign) CGFloat beautyLevel;//美白
@property (nonatomic, assign) CGFloat brightLevel;//磨皮
@property (nonatomic, assign) CGFloat toneLevel;//饱和
@property (nonatomic, assign) CGFloat pinkLevel;//粉嫩

@property (nonatomic, readonly) BOOL needTrackData;

- (void)setParam:(float)value withType:(KW_NEWBEAUTY_TYPE)type;

@end
