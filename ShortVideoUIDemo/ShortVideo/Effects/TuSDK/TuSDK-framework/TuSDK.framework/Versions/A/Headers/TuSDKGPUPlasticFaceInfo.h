//
//  TuSdkPlasticFaceInfo.h
//  TuSDK
//
//  Created by hecc on 2018/8/16.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKFaceAligment.h"




static const int PLASTIC_FACE_POINTS_COUNT = 95;

/**
 * 预先设定好的面部点集的索引值数组，每3个一组排列，每组表示三角形的三个顶点的索引值
 * 每张脸有108个三角形分割而成
 */
static const int TRIANGLE_SIZE = 3;
static const int FACE_TRIANGLES_COUNT = 180;
static const int FACE_TRIANGLES_MAP_SIZE = TRIANGLE_SIZE * FACE_TRIANGLES_COUNT;
static const int FACE_TRIANGLES_MAP[FACE_TRIANGLES_MAP_SIZE] =
{
    53, 52, 22,    52, 53, 43,    1, 88, 0,      88, 1, 89,     0, 88, 17,
    80, 85, 79,    85, 80, 84,    1, 0, 36,      67, 31, 68,    31, 67, 64,
    89, 1, 2,      2, 1, 41,      74, 9, 75,     9, 74, 10,     3, 89, 2,
    89, 3, 4,      3, 2, 64,      30, 35, 34,    35, 30, 63,    89, 5, 90,
    5, 89, 4,      4, 3, 66,      64, 2, 57,     90, 5, 6,      5, 4, 66,
    41, 1, 36,     90, 6, 7,      6, 5, 77,      63, 30, 29,    90, 8, 91,
    8, 90, 7,      7, 6, 76,      57, 2, 41,     8, 7, 75,      9, 91, 8,
    91, 9, 10,     9, 8, 75,      91, 10, 11,    40, 38, 39,    38, 40, 57,
    11, 92, 91,    92, 11, 12,    11, 10, 72,    39, 62, 40,    62, 39, 60,
    92, 12, 13,    12, 11, 72,    36, 17, 48,    17, 36, 0,     92, 13, 14,
    13, 12, 72,    48, 19, 49,    19, 48, 18,    92, 14, 15,    14, 13, 65,
    36, 48, 37,    92, 15, 93,    15, 14, 45,    51, 60, 39,    60, 51, 27,
    15, 16, 93,    16, 15, 45,    17, 88, 18,    63, 61, 42,    61, 63, 28,
    18, 88, 86,    87, 86, 88,    44, 59, 58,    59, 44, 46,    17, 18, 48,
    18, 86, 19,    86, 21, 20,    21, 86, 22,    19, 20, 49,    20, 19, 86,
    21, 22, 27,    53, 22, 23,    52, 43, 42,    20, 21, 50,    61, 52, 42,
    52, 61, 27,    46, 44, 45,    22, 86, 23,    23, 86, 24,    54, 55, 44,
    55, 54, 24,    23, 24, 54,    24, 86, 25,    26, 93, 16,    93, 26, 25,
    24, 25, 55,    93, 86, 94,    25, 86, 93,    16, 45, 26,    25, 26, 55,
    27, 22, 52,    30, 62, 29,    62, 30, 31,    21, 27, 51,    66, 3, 64,
    27, 28, 60,    28, 27, 61,    71, 35, 65,    35, 71, 70,    68, 31, 32,
    28, 29, 62,    29, 28, 63,    70, 81, 80,    81, 70, 71,    7, 76, 75,
    80, 68, 69,    68, 80, 79,    31, 30, 32,    66, 64, 67,    33, 69, 68,
    69, 33, 70,    32, 30, 33,    70, 33, 34,    32, 33, 68,    33, 30, 34,
    65, 72, 71,    72, 65, 13,    34, 35, 70,    59, 65, 63,    65, 59, 46,
    48, 49, 37,    57, 37, 56,    37, 57, 41,    50, 21, 51,    36, 37, 41,
    49, 56, 37,    56, 49, 50,    38, 57, 56,    50, 51, 38,    39, 38, 51,
    28, 62, 60,    57, 62, 64,    62, 57, 40,    63, 42, 47,    46, 14, 65,
    14, 46, 45,    42, 43, 47,    53, 58, 43,    58, 53, 54,    58, 47, 43,
    47, 58, 59,    45, 55, 26,    55, 45, 44,    59, 63, 47,    49, 20, 50,
    50, 38, 56,    53, 23, 54,    54, 44, 58,    62, 31, 64,    35, 63, 65,
    77, 5, 66,     66, 67, 78,    84, 80, 83,    67, 68, 79,    83, 82, 73,
    82, 83, 81,    69, 70, 80,    73, 10, 74,    10, 73, 72,    71, 72, 82,
    72, 73, 82,    82, 81, 71,    73, 74, 83,    74, 75, 84,    85, 78, 79,
    78, 85, 77,    75, 76, 84,    76, 6, 77,     79, 78, 67,    76, 77, 85,
    77, 66, 78,    85, 84, 76,    84, 83, 74,    83, 80, 81,    86, 87, 94
};

@interface TuSdkPlasticFaceInfo:NSObject

-(instancetype) initWithFaceInfo:(TuSDKFaceAligment *)aligment frameSize:(CGSize)frameSize;

-(void)ResetPoints;
-(void)GetPoints:(GLfloat *)points isVer:(BOOL)isVer;

// 调节额头高低
-(void)CalcForeheadHeight:(float)value;
// 调节瘦脸
-(void)CalcCheekThin:(float)value;
// 调节眉毛粗细
-(void)CalcBrowThickness:(float)value;
// 调节眉毛高低
-(void)CalcBrowPosition:(float)value;
// 调节眼睛大小
-(void)CalcEyeEnlarge:(float)value;
// 计算眼角
-(void)CalcEyeAngle:(float)value;
// 计算眼距
-(void)CalcEyesDistance:(float)value;
// 调节鼻子大小
-(void)CalcNoseWidth:(float)value;
// 调节嘴巴宽度
-(void)CalcMouthWith:(float)value;
// 调节嘴巴大小
-(void)CalcMouthZoom:(float)value;
// 调节嘴唇厚度
-(void)CalcLipsThickness:(float)value;
// 计算下巴
-(void)CalcChinThickness:(float)value;

@end
