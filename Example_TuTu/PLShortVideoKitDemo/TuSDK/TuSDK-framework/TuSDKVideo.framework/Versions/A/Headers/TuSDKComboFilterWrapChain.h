//
//  TuSDKComboFilterWrapChain.h
//  TuSDK
//
//  Created by sprint on 04/06/2018.
//  Copyright © 2018 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKVideoImport.h"

/**
 多个 TuSDKFilterWrap 叠加并多路输出
 @since v2.2.0
 */
@interface TuSDKComboFilterWrapChain : NSObject

/**
 设置原始输入节点

 @param orginNode 原始输入节点
 @since v2.2.0
 */
- (void)setOrginNode:(nullable SLGPUImageOutput *)orginNode;

/**
 为 TuSDKComboFilterWrapChain  添加一个新的最终输出节点（支持多路输出）

 @param terminalNode 终点节点
 @since v2.2.0
 */
- (void)addTerminalNode:(nullable id<SLGPUImageInput>)terminalNode;

/**
 移除输出节点

 @param terminalNode 终点节点
 @since v2.2.0
 */
- (void)removeTerminalNode:(nullable id<SLGPUImageInput>)terminalNode;

/**
 为 TuSDKComboFilterWrapChain 添加一个新的 TuSDKFilterWrap 节点

 @param nodeWrap 链条中的一个节点，该节点将被当道最后一个位置
 @since v2.2.0
 */
- (void)appendFilterWrapNode:(TuSDKFilterWrap *_Nonnull)nodeWrap;

/**
 插入一个新的 TuSDKFilterWrap节点到指定位置

 @param nodeWrap TuSDKFilterWrap
 @param index 指定索引
 @since v2.2.0
 */
- (void)instertFilterWrapNode:(TuSDKFilterWrap *_Nonnull)nodeWrap atIndex:(NSUInteger)index;

/**
 移除 TuSDKComboFilterWrapChain 中的一个节点
 
 @param nodeWrap 链条中的一个节点
 @since v2.2.0
 */
- (void)removeFilterWrapNode:(TuSDKFilterWrap *_Nonnull)nodeWrap;

/**
 移除所有特效节点
 @since v2.2.0
 */
- (void)removeAllFilterWrapNode;

/**
 旋转材质到图片方向
 
 @param imageOrientation 图片方向
 @since v2.2.0
 */
- (void)rotationTextures:(UIImageOrientation)imageOrientation;

/**
 销毁特效组合
 @since v2.2.0
 */
- (void)destroy;

@end
