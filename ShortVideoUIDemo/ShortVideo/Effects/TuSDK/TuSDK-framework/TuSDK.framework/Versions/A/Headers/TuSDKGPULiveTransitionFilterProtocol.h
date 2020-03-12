//
//  TuSDKGPULiveTransitionFilterProtocol.h
//  TuSDK
//
//  Created by tutu on 2019/6/5.
//  Copyright © 2019 tusdk.com. All rights reserved.
//

#ifndef TuSDKGPULiveTransitionFilterProtocol_h
#define TuSDKGPULiveTransitionFilterProtocol_h

@protocol TuSDKGPULiveTransitionFilterProtocol <NSObject>

/**
 动画持续时长(单位毫秒): 默认1.0s, 即1.0*1000
 @since v3.4.1
 */
@property (nonatomic, assign) GLfloat animationDuration;

/**
 是否为帧间动画 YES：前后帧动画 NO：帧内动画
 
 @since v3.4.1
 */
@property (nonatomic, assign) BOOL interFrameAnim;

@end


#endif /* TuSDKGPULiveTransitionFilterProtocol_h */
