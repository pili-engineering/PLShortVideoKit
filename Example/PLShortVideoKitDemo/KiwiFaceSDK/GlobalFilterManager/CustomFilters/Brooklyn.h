//
//  Brooklyn.h
//  KWRenderManager
//
//  Created by 伍科 on 17/5/18.
//  Copyright © 2017年 PLMediaStreamingSDK. All rights reserved.
//
#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"
#import "GPUImage.h"
#import "GPUImageFourInputFilter.h"

@interface BrooklynFilter : GPUImageFourInputFilter

@end

@interface Brooklyn : GPUImageFilterGroup <KWRenderProtocol>
{
    GPUImagePicture *imageSource1;
    GPUImagePicture *imageSource2;
    GPUImagePicture *imageSource3;
}

@property(nonatomic, readonly) BOOL needTrackData;

@end
