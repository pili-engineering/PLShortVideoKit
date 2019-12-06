//
//  TuSDKMonsterFaceWrap.h
//  TuSDKVideo
//
//  Created by sprint on 2018/12/25.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKVideoImport.h"

NS_ASSUME_NONNULL_BEGIN

/**
 哈哈镜类型
 @since v3.3.0
 */
typedef NS_ENUM(NSUInteger,TuSDKMonsterFaceType) {
    /** 哈哈镜 - 大鼻子  @since v3.3.0 */
    TuSDKMonsterFaceTypeBigNose,
    /** 哈哈镜 - 大饼脸 @since v3.3.0 */
    TuSDKMonsterFaceTypePieFace,
    /** 哈哈镜 - 国字脸 @since v3.3.0 */
    TuSDKMonsterFaceTypeSquareFace,
    /** 哈哈镜 - 厚嘴唇 @since v3.3.0 */
    TuSDKMonsterFaceTypeThickLips,
    /** 哈哈镜 - 眯眯眼 @since v3.3.0 */
    TuSDKMonsterFaceTypeSmallEyes,
    /** 哈哈镜 - 木瓜脸 @since v3.3.0 */
    TuSDKMonsterFaceTypePapayaFace,
    /** 哈哈镜 - 蛇精脸 @since v3.3.0 */
    TuSDKMonsterFaceTypeSnakeFace,
};

/**
 哈哈镜
 @since v3.3.0
 */
@interface TuSDKMonsterFaceWrap : TuSDKFilterWrap  <TuSDKFilterFacePositionProtocol>

/**
 根据哈哈镜类型初始化 TuSDKMonsterFaceWrap

 @param faceType 哈哈镜类型 @see TuSDKMonsterFaceType
 @return TuSDKMonsterFaceWrap
 @since v3.3.0
 */
- (instancetype)initWithMonsterFaceType:(TuSDKMonsterFaceType)faceType;

/**
 当前哈哈镜类型
 @since v3.3.0
 */
@property (nonatomic,readonly) TuSDKMonsterFaceType monsterFaceType;

@end

NS_ASSUME_NONNULL_END
