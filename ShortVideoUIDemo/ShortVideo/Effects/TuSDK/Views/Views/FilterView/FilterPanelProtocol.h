//
//  CameraFilterPanelProtocol.h
//  TuSDKVideoDemo
//
//  Created by bqlin on 2018/7/27.
//  Copyright © 2018年 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FilterPanelProtocol;

/**
 滤镜面板回调代理
 */
@protocol FilterPanelDelegate <NSObject>
@optional

/**
 滤镜码选中回调

 @param filterPanel 相机滤镜协议
 @param code 滤镜的 filterCode
 */
- (void)filterPanel:(id<FilterPanelProtocol>)filterPanel didSelectedFilterCode:(NSString *)code;

/**
 滤镜参数变更回调

 @param filterPanel 相机滤镜协议
 @param percent 滤镜参数数值
 @param index 滤镜参数索引
 */
- (void)filterPanel:(id<FilterPanelProtocol>)filterPanel didChangeValue:(double)percent paramterIndex:(NSUInteger)index;

/**
 重置滤镜参数回调

 @param filterPanel 相机滤镜协议
 @param paramterKeys 滤镜参数
 */
- (void)filterPanel:(id<FilterPanelProtocol>)filterPanel resetParamterKeys:(NSArray *)paramterKeys;

@end


/**
 滤镜面板数据源
 */
@protocol CameraFilterPanelDataSource <NSObject>

/**
 滤镜参数个数

 @return 参数数量
 */
- (NSInteger)numberOfParamter;

/**
 对应索引的参数名称

 @param index 滤镜参数的索引
 @return 滤镜参数的名称
 */
- (NSString *)paramterNameAtIndex:(NSUInteger)index;

/**
 滤镜参数对应索引的参数值

 @param index 滤镜参数的索引
 @return 对应参数的数值
 */
- (double)percentValueAtIndex:(NSUInteger)index;

@end


/**
 滤镜面板通用接口
 */
@protocol FilterPanelProtocol <NSObject>

@property (nonatomic, weak) id<FilterPanelDelegate> delegate;
@property (nonatomic, weak) id<CameraFilterPanelDataSource> dataSource;

/**
 是否展示
 */
@property (nonatomic, assign, readonly) BOOL display;

/**
 重载参数列表，会触发数据源代理方法
 */
- (void)reloadFilterParamters;

@end
