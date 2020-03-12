//
//  PLSUploaderConfiguration.h
//  PLShortVideoKit
//
//  Created by 何昊宇 on 2017/6/8.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 @class PLSUploaderConfiguration
 @brief 上传的参数配置类
 */
@interface PLSUploaderConfiguration : NSObject

/*!
 @property token
 @brief 上传视频空间 token
 
 @since      v1.0.4
 */
@property (nonatomic, strong)NSString * _Nonnull token;

/*!
 @property videoKey
 @brief 上传视频空间设置的 key,默认为当前上传视频文件的 hash 值
 
 @since      v1.0.4
 */
@property (nonatomic, strong)NSString * _Nullable videoKey;

/*!
 @property https
 @brief 上传视频空间是否需要设置为 https 上传, YES 为 https 上传，NO 为 http 上传，默认为 YES
 
 @since      v1.0.4
 */
@property (nonatomic, assign, getter=isHttps)BOOL https;

/*!
 @property   recorder
 @brief      断点续传文件记录
 @discussion 默认为 Documents 下 PLShortVideoUploaderRecorder, 即:Documents/PLShortVideoUploaderRecorder
 @warning    断点续上传要求：1 文件本身内容不发生变化
                          3 上传视频空间设置的 key , 即 videoKey 与 recorder 中一致
                          4 上传到的 bucket 为原 bucket
 
 @since      v1.0.5
 */
@property (nonatomic, strong)NSString * _Nullable recorder;

/*!
 @property params
 @brief 上传视频空间设置的 key,默认为当前上传视频文件的 hash 值

 @since      v1.0.4
 */
@property (nonatomic, strong)NSDictionary * _Nullable params;

/*!
 @method initWithToken:videoKeyhttps:recorder
 @abstract   PLSUploaderConfiguration 初始化方法
 @warning    token 必填，不能为空
 
 @param token 上传的 token 值
 @param videoKey 上传的 key 值
 @param https 是否使用 https 上传
 @param recorder 断点记录
 
 @return PLSUploaderConfiguration 实例
 @since      v1.0.4
 */
- (instancetype _Nullable)initWithToken:(NSString * _Nonnull)token
                              videoKey:(NSString * _Nullable)videoKey
                                 https:(BOOL)https
                              recorder:(NSString * _Nullable)recorder;
/*!
 @method defaultWithToken:
 @abstract   使用默认配置生成一个 PLSUploaderConfiguration 对象
 @discussion 调用此方法，除 token 之外，其他值均为默认值
 
 @param token 上传的 token 值
 
 @return PLSUploaderConfiguration 实例
 @since      v1.0.4
 */
+ (instancetype _Nullable)defaultWithToken:(NSString * _Nonnull)token;

/*!
 @method initWithToken:videoKey:https:recorder:params
 @abstract   PLSUploaderConfiguration 初始化方法
 @warning    token 必填，不能为空

 @param token 上传的 token 值
 @param videoKey 上传的 key 值
 @param https 是否使用 https 上传
 @param recorder 断点记录
 @param params 上传参数
 
 @return PLSUploaderConfiguration 实例
 @since      v1.0.4
 */
- (instancetype _Nullable)initWithToken:(NSString * _Nonnull)token
                               videoKey:(NSString * _Nullable)videoKey
                                  https:(BOOL)https
                               recorder:(NSString * _Nullable)recorder
                                 params:(NSDictionary * _Nullable)params;

@end
