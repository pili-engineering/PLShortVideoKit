//
//  TuSDKMediaPacketShapeEffect.h
//  TuSDKVideo
//
//  Created by sprint on 20/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaPacketEffect.h"

/**
 形状特效
 片头：全屏覆盖一层纯白色蒙层，以中心点为圆心，圆心不断向外扩，白色蒙层根据扩散的变化逐渐减少。
 @since v3.0.1
 */
@interface TuSDKMediaPacketShapeEffect : NSObject <TuSDKMediaPacketEffect>

@end
