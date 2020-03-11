//
//  TuSDKCPImage.h
//  TuSDK
//
//  Created by Yanlin on 1/7/16.
//  Copyright © 2016 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#define lasque_bytes_FOUR_CC(c1,c2,c3,c4) ((uint32_t)(((c4) << 24) | ((c3) << 16) | ((c2) << 8) | (c1)))
#define lasque_bytes_TWO_CC(c1,c2) ((uint16_t)(((c2) << 8) | (c1)))

#pragma mark - image enum

/**
 *  Image Type
 */
typedef NS_ENUM(NSUInteger, lasqueImageType)
{
    /**
     *  Unknown
     */
    lasqueImageTypeUnknown = 0,
    /**
     *  jpg, jpeg
     */
    lasqueImageTypeJPEG,
    /**
     *  jp2000
     */
    lasqueImageTypeJPEG2000,
    /**
     *  bmp
     */
    lasqueImageTypeBMP,
    /**
     *  gif
     */
    lasqueImageTypeGIF,
    /**
     *  png
     */
    lasqueImageTypePNG,
    /**
     *  webp
     */
    lasqueImageTypeWebP,
    /**
     *  other
     */
    lasqueImageTypeOther,
};


/**
 *  Dispose method
 */
typedef NS_ENUM(NSUInteger, lasqueImageDisposeMethod)
{
    /**
     *  not dispose
     */
    lasqueImageDisposeNone = 0,
    
    /**
     *  The frame's region of the canvas is to be cleared to fully transparent black before rendering the next frame.
     */
    lasqueImageDisposeBackground,

    /**
     *  The frame's region of the canvas is to be reverted to the previous contents before rendering the next frame.
     */
    lasqueImageDisposePrevious,
};

/**
 *  Blend Type
 */
typedef NS_ENUM(NSUInteger, lasqueImageBlendOperation)
{
    /**
     *  override
     */
    lasqueImageBlendNone = 0,
    
    /**
     *  merge
     */
    lasqueImageBlendOver,
};

#pragma mark - TuSDKCPImageFrame
/**
 *  Image Frame Object
 */
@interface TuSDKCPImageFrame : NSObject <NSCopying>

/**
 *  初始化ImageFrame
 *
 *  @param image UIImage对象
 *
 *  @return TuSDKCPImageFrame对象
 */
+ (instancetype)frameWithImage:(UIImage *)image;

/**
 *  Frame index
 */
@property (nonatomic, assign) NSUInteger index;

/**
 *  Frame width
 */
@property (nonatomic, assign) NSUInteger width;

/**
 *  Frame height
 */
@property (nonatomic, assign) NSUInteger height;

/**
 *  origin X
 */
@property (nonatomic, assign) NSUInteger offsetX;

/**
 *  origin Y
 */
@property (nonatomic, assign) NSUInteger offsetY;

/**
 *  Frame duration in seconds
 */
@property (nonatomic, assign) NSTimeInterval duration;

/**
 *  Frame dispose method
 */
@property (nonatomic, assign) lasqueImageDisposeMethod dispose;

/**
 *  Frame blend method
 */
@property (nonatomic, assign) lasqueImageBlendOperation blend;

/**
 *  UIImage对象
 */
@property (nonatomic, strong) UIImage *image;

@end

#pragma mark - TuSDKCPImage

/**
 *  TuSDKCPImage 基类
 */
@interface TuSDKCPImage : UIImage

/**
 *  根据当前设备获取合适的DPI缩放级别序列
 *
 *  @return DPI 序列数组
 */
+ (NSArray *)getBundlePreferredScales;

/**
 *  根据缩放级别获取文件的全名，补齐 "@2x" 类似后缀
 *
 *  @param string 文件前缀
 *  @param scale  DPI缩放级别
 *
 *  @return filename 文件全名
 */
+ (NSString *)getResFilename:(NSString *)string byScale:(CGFloat) scale;

/**
 *  从文件名获取对应的缩放级别
 *
 *  @param string 文件名
 *
 *  @return DPI 缩放级别
 */
+ (CGFloat)getScaleFromFilename:(NSString *)string;

/**
 *  Image orientation
 *
 *  @param value property value in Exif
 *
 *  @return UIImageOrientation
 */
+ (UIImageOrientation)UIImageOrientationFromEXIFValue:(NSInteger)value;

/**
 *  获取文件类型
 */
@property (nonatomic, readonly) lasqueImageType imageType;

#pragma mark - constructor

/**
 *  从指定的路径初始化
 *
 *  @param path 文件路径
 *
 *  @return TuSDKCPImage对象
 */
- (instancetype)initWithContentsOfFile:(NSString *)path;

/**
 *  根据NSData初始化
 *
 *  @param data NSData对象
 *
 *  @return TuSDKCPImage对象
 */
- (instancetype)initWithData:(NSData *)data;

/**
 *  根据NSData和DPI缩放级别初始化
 *
 *  @param data  NSData对象
 *  @param scale DPI缩放级别
 *
 *  @return TuSDKCPImage对象
 */
- (instancetype)initWithData:(NSData *)data scale:(CGFloat)scale;

@end
