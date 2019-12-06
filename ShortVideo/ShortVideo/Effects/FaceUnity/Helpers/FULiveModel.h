//
//  FULiveModel.h
//  FULive
//
//  Created by L on 2018/1/15.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

// 注意： 这里和 FULiveDemo 中的定义有区别，对应的 dataSource.plist 中的内容不一样
typedef NS_ENUM(NSUInteger, FULiveModelType) {
    FULiveModelTypeBeautifyFace             = 0,// 美颜、大脸、瘦眼
    FULiveModelTypeMakeUp, // 美装
    FULiveModelTypeHair, // 美发
    FULiveModelTypeGestureRecognition, // 手势识别
    FULiveModelTypeHahaMirror, // 哈哈镜
    FULiveModelTypeARMarsk,// AR 面具
    FULiveModelTypeItems,// 贴纸
    FULiveModelTypeAnimoji,
    FULiveModelTypeFaceChange,// 换脸
    FULiveModelTypeExpressionRecognition,// 表情识别
//    FULiveModelTypePoster,//海报换脸
//    FULiveModelTypeMusicFilter,// 音乐滤镜
    FULiveModelTypeBGSegmentation,//  背景分隔
//    FULiveModelTypePortraitLighting,
    FULiveModelTypePortraitDrive,// 人像驱动
//    FULiveModelTypeYiTu,
//    FULiveModelTypeGan,
};

@interface FULiveModel : NSObject

@property (nonatomic, assign) NSInteger maxFace ;

@property (nonatomic, copy) NSString *title ;

@property (nonatomic, assign) BOOL enble ;

@property (nonatomic, assign) FULiveModelType type ;

@property (nonatomic, assign) NSArray *modules ;

@property (nonatomic, strong) NSArray *items ;

@property (nonatomic, assign) int selIndex;

@end
