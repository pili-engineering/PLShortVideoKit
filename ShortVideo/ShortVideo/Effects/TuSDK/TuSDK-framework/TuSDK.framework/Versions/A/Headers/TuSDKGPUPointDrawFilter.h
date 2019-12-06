//
//  TuSDKGPUPointDrawFilter.h
//  TuSDK
//
//  Created by Clear Hu on 2017/11/25.
//  Copyright © 2017年 tusdk.com. All rights reserved.
//

#import "TuSDKFilterAdapter.h"
#import "TuSDKFilterParameter.h"

/** Point Draw Filter*/
@interface TuSDKGPUPointDrawFilter : TuSDKFilter<TuSDKFilterFacePositionProtocol>

- (void)updateElemIndex:(NSArray<NSNumber *>*) mElemIndexTmp mVerticesTmp:(GLfloat*)mVerticesTmp;


@end
