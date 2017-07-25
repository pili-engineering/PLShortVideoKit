//
//  KWPoint.h
//  KWMediaStreamingKitDemo
//
//  Created by ChenHao on 16/7/15.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    KWPositionHair    = 1,
    KWPositionEye     = 2,
    KWPositionEar     = 3,
    KWPositionNose    = 4,
    KWPositionNostril = 5,
    KWPositionUperMouth   = 6,
    KWPositionMouth   = 7,
    KWPositionLip     = 8,
    KWPositionChin    = 9,
    KWPositionEyebrow,
    KWPositionCheek,
    KWPositionNeck,
    KWPositionFace,
} KWPosition;


/**
 返回某位置对应的点
 */
@interface KWPoint : NSObject

@property (nonatomic) int left;
@property (nonatomic) int center;
@property (nonatomic) int right;

+ (instancetype)facePointForPosition:(KWPosition)position;

@end
