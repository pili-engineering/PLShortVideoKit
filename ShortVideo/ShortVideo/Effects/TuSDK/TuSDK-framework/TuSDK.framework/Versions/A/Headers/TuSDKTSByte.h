//
//  TuSDKTSByte.h
//  TuSDK
//
//  Created by Clear Hu on 15/1/26.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  判断Byte数组是否相等
 *
 *  @param bytes1 数组1
 *  @param bytes2 数组2
 *  @param length 数组长度
 *
 *  @return 是否相等
 */
CG_EXTERN BOOL LSQBytesEqualToBytes(const Byte *bytes1, const Byte *bytes2, size_t length);

CG_INLINE BOOL
__LSQBytesEqualToBytes(const Byte *bytes1, const Byte *bytes2, size_t length)
{
    for (NSUInteger i = 0, j = length / sizeof(Byte); i < j; i++) {
        if (bytes1[i] != bytes2[i]) return NO;
    }
    return YES;
}
#define LSQBytesEqualToBytes __LSQBytesEqualToBytes

/**
 *  转为整数
 *
 *  @param bytes  数组
 *  @param length 数组长度
 *
 *  @return 整数 D4 00 00 00
 */
CG_EXTERN NSUInteger LSQBytesToInteger(const Byte *bytes, size_t length);
CG_INLINE NSUInteger
__LSQBytesToInteger(const Byte *bytes, size_t length)
{
    if (length != 4) return 0;
    return (0xff & bytes[0]) | (0xff00 & (bytes[1] << 8))
				| (0xff0000 & (bytes[2] << 16))
				| (0xff000000 & (bytes[3] << 24));
}
#define LSQBytesToInteger __LSQBytesToInteger

/**
 *  转为整数
 *
 *  @param bytes  数组
 *  @param length 数组长度
 *
 *  @return 整数 00 00 00 D4
 */
CG_EXTERN NSUInteger LSQBytesToIntegerFill(const Byte *bytes, size_t length);
CG_INLINE NSUInteger
__LSQBytesToIntegerFill(const Byte *bytes, size_t length)
{
    if (length != 4) return 0;
    return (0xff & bytes[3]) | (0xff00 & (bytes[2] << 8))
				| (0xff0000 & (bytes[1] << 16))
				| (0xff000000 & (bytes[0] << 24));
}
#define LSQBytesToIntegerFill __LSQBytesToIntegerFill

/**
 *  双精度浮点数转为Bits
 *
 *  @param x 值
 *
 *  @return Bits
 */
CG_EXTERN uint64_t LSQDoubleToBits(double x);
CG_INLINE uint64_t
__LSQDoubleToBits(double x) {
    const union { double f; uint64_t i; } xUnion = { .f = x };
    return xUnion.i;
}
#define LSQDoubleToBits __LSQDoubleToBits

/**
 *  单精度浮点数转为Bits
 *
 *  @param x 值
 *
 *  @return Bits
 */
CG_EXTERN uint32_t LSQDFloatToBits(float x);
CG_INLINE uint32_t
__LSQDFloatToBits(float x) {
    const union { float f; uint32_t i; } xUnion = { .f = x };
    return xUnion.i;
}
#define LSQDFloatToBits __LSQDFloatToBits

/**
 *  Byte帮助类
 */
@interface TuSDKTSByte : NSObject
/**
 *  长整形转为Data对象
 *
 *  @param value 值
 *
 *  @return Data对象
 */
+ (NSData *)dataWithLong:(uint64_t)value;

/**
 *  浮点数转为Data对象
 *
 *  @param value 值
 *
 *  @return Data对象
 */
+ (NSData *)dataWithDouble:(double)value;
@end
