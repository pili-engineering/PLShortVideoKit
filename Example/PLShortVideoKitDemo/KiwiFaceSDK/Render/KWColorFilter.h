//
//  KWColorFilter.h
//  KiwiFaceKitDemo
//
//  Created by Yichao on 2017/03/6.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "GPUImageFilterGroup.h"
#import "KWRenderProtocol.h"
@class GPUImagePicture;

@interface KWColorFilter : GPUImageFilterGroup<KWRenderProtocol>

@property (nonatomic, assign)CGImageRef currentImage;

@property (nonatomic, strong)GPUImagePicture *lookupImageSource;

@property (nonatomic, readonly) BOOL needTrackData;

@property (nonatomic, strong)NSString *colorFilterName;

@property (nonatomic, strong)NSString *colorFilterDir;

- (id)initWithDir:(NSString *)colorFilterDir;

@end
