//
//  TuSdkPlasticFaceInfo.h
//  TuSDK
//
//  Created by hecc on 2018/8/16.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKFaceAligment.h"

/**
 * 整张脸最外圈点
 */
static const int FACE_DETECTED_LINE_LEN = 12;
/**
 * 脸部外轮廓索引
 */
static const int FACE_OUTLINE_LEN = 9;
static int FACE_OUTLINE[FACE_OUTLINE_LEN] = {0, 4, 8, 12, 16, 20, 24, 28, 32};
/**
 * 左眉外轮廓索引
 */
static const int EYEBROW_LEFT_OUTLINE_LEN = 7;
static int EYEBROW_LEFT_OUTLINE[EYEBROW_LEFT_OUTLINE_LEN] = {33, 34, 64, 35, 65, 37, 67};
/**
 * 右眉外轮廓索引
 */
static const int EYEBROW_RIGHT_OUTLINE_LEN = 7;
static int EYEBROW_RIGHT_OUTLINE[EYEBROW_RIGHT_OUTLINE_LEN] = {42, 41, 71, 40, 70, 38, 68};
/**
 * 左眼外轮廓索引
 */
static const int EYE_LEFT_OUTLINE_LEN=4;
static int EYE_LEFT_OUTLINE[EYE_LEFT_OUTLINE_LEN] = {72, 73, 52, 55};
/**
 * 右眼外轮廓索引
 */
static const int EYE_RIGHT_OUTLINE_LEN =4;
static int EYE_RIGHT_OUTLINE[EYE_RIGHT_OUTLINE_LEN] = {75, 76, 58, 61};
/**
 * 鼻头外轮廓
 */
static const int NOSE_OUTLINE_LEN = 3;
static int NOSE_OUTLINE[NOSE_OUTLINE_LEN] = {49, 82, 83};
/**
 * 嘴巴外轮廓
 */
static const int MOUTH_OUTLINE_LEN =14;
static int MOUTH_OUTLINE[MOUTH_OUTLINE_LEN] = {84, 90, 86, 87, 88, 97, 98, 99, 94, 93, 92, 103, 102, 101};


static const int FACE_POINTS_COUNT = (FACE_DETECTED_LINE_LEN
                                      + FACE_OUTLINE_LEN
                                      + EYEBROW_LEFT_OUTLINE_LEN
                                      + EYEBROW_RIGHT_OUTLINE_LEN
                                      + 1
                                      + EYE_LEFT_OUTLINE_LEN
                                      + EYE_RIGHT_OUTLINE_LEN
                                      + NOSE_OUTLINE_LEN
                                      + MOUTH_OUTLINE_LEN);

/**
 * 预先设定好的面部点集的索引值数组，每3个一组排列，每组表示三角形的三个顶点的索引值
 * 每张脸有108个三角形分割而成
 */
static const int TRIANGLE_SIZE = 3;
static const int FACE_TRIANGLES_COUNT = 108;
static const int FACE_TRIANGLES_MAP_SIZE = TRIANGLE_SIZE * FACE_TRIANGLES_COUNT;
static const int FACE_TRIANGLES_MAP[FACE_TRIANGLES_MAP_SIZE] =
{
    0, 1, 12,       0, 9, 12,       1, 2, 13,       1, 12, 13,      2, 3, 14,
    2, 13, 14,      3, 4, 16,       3, 14, 15,      3, 15, 16,      4, 5, 16,
    5, 6, 18,       5, 16, 17,      5, 17, 18,      6, 7, 19,       6, 18, 19,
    7, 8, 20,       7, 19, 20,      8, 10, 20,      9, 11, 24,      9, 12, 21,
    9, 21, 22,      9, 22, 24,      10, 11, 31,     10, 20, 28,     10, 28, 29,
    10, 29, 31,     11, 24, 26,     11, 26, 35,     11, 31, 33,     11, 33, 35,
    12, 13, 38,     12, 21, 36,     12, 36, 38,     13, 14, 47,     13, 37, 38,
    13, 37, 45,     13, 45, 47,     14, 15, 47,     15, 16, 55,     15, 47, 55,
    16, 17, 57,     16, 55, 56,     16, 56, 57,     17, 18, 48,     17, 48, 57,
    18, 19, 48,     19, 46, 48,     19, 20, 43,     19, 41, 43,     19, 41, 46,
    20, 28, 40,     20, 40, 43,     21, 22, 23,     21, 23, 36,     22, 23, 25,
    22, 24, 25,     23, 25, 36,     24, 25, 26,     25, 26, 27,     25, 27, 36,
    26, 27, 35,     27, 35, 36,     28, 29, 30,     28, 30, 40,     29, 30, 32,
    29, 31, 32,     30, 32, 40,     31, 32, 33,     32, 33, 34,     32, 34, 40,
    33, 34, 35,     34, 35, 40,     35, 36, 39,     35, 39, 45,     35, 40, 42,
    35, 42, 46,     35, 44, 45,     35, 44, 46,     36, 37, 38,     36, 37, 39,
    37, 39, 45,     40, 41, 42,     40, 41, 43,     41, 42, 46,     44, 45, 49,
    44, 46, 51,     44, 49, 50,     44, 50, 51,     45, 47, 49,     46, 48, 51,
    47, 49, 52,     47, 52, 58,     47, 55, 58,     48, 51, 54,     48, 54, 60,
    48, 57, 60,     49, 50, 52,     50, 51, 54,     50, 52, 53,     50, 53, 54,
    52, 53, 58,     53, 54, 60,     53, 58, 59,     53, 59, 60,     55, 56, 58,
    56, 57, 60,     56, 58, 59,     56, 59, 60
};


@interface TuSdkPlasticFaceInfo : NSObject

-(instancetype) initWithFaceInfo:(TuSDKFaceAligment *)aligment;

/**
 * 获取点信息
 * 注：顺序严格按照已有次序，保证和 FACE_IDX 一致
 */
-(void) getPoints:(GLfloat*)points isVer:(BOOL)isVer;

/**
 * 计算瘦脸
 */
-(void)calcChin:(float)value ;

/**
 * 计算大眼
 */
-(void)calcEyeEnlarge:(float)value;

/**
 * 计算瘦鼻
 */
-(void)calcNose:(float)value;
/**
 * 计算嘴宽
 */
-(void)calcMouthWidth:(float) value ;

/**
 * 计算嘴唇
 */
-(void) calcLips:(float) value ;
/**
 * 计算细眉
 */
-(void) calcArchEyebrow:(float) value ;

/**
 * 计算眼距
 */
-(void) calcEyeDis:(float) value;

/**
 * 计算眼角
 */
-(void) calcEyeAngle:(float) value ;

/**
 * 计算下巴
 */
-(void) calcJaw:(float) value;

@end
