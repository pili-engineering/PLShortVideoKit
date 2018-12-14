//
//  SelesVertexbuffer.h
//  TuSDK
//
//  Created by Clear Hu on 2018/6/7.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLGPUImage.h"

/** 顶点缓存 VBO对象 */
@interface SelesVertexbuffer : NSObject
/** 顶点缓存对象 */
@property(readonly) GLuint vertexbuffer;

/**
 * 顶点缓存 VBO对象
 * @param buffer 顶点缓存
 * @param size   索引长度 (顶点索引，不需要乘以4)
 */
+ (id)initWithBuffer:(const GLfloat*)buffer size:(GLsizeiptr)size;

/**
 * 刷新数据
 * @param buffer 顶点缓存
 * @param offset 起始位置 (顶点索引，不需要乘以4)
 * @param size   索引长度 (顶点索引，不需要乘以4)
 */
- (void)freshWithBuffer:(const GLfloat*)buffer offset:(GLsizeiptr)offset size:(GLsizeiptr)size;

/** activate Vertexbuffer */
- (void)activateVertexbuffer;

/** disable Vertexbuffer */
- (void)disableVertexbuffer;

/** 销毁VBO */
- (void)destroyVertexbuffer;
@end
