//
//  Global.h
//  KiwiFaceKitDemo
//
//  Created by zhaoyichao on 2017/1/17.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Global : NSObject

typedef enum {
    KW_PIXELBUFFER_ROTATE_0 = 0,	///< The image does not need steering
    KW_PIXELBUFFER_ROTATE_90 = 1,	///< The image needs to be rotated 90 degrees clockwise
    KW_PIXELBUFFER_ROTATE_180 = 2,	///< The image needs to be rotated 180 degrees clockwise
    KW_PIXELBUFFER_ROTATE_270 = 3	///< The image needs to be rotated 270 degrees clockwise
} KW_PIXELBUFFER_ROTATE;


/**
 Ordinary filters
 
 - KW_FILTER_TYPE_NONE: NO filter
 - KW_FILTER_TYPE_STICKER: sticker filter
 */
typedef NS_ENUM(NSInteger,KW_FILTER_TYPE)
{
    KW_FILTER_TYPE_NONE = -1,
    KW_FILTER_TYPE_STICKER,
};

//Beauty parameter adjustment type
typedef NS_ENUM(NSInteger,KW_NEWBEAUTY_TYPE)
{
    /* Eye-magnifying */
    KW_NEWBEAUTY_TYPE_EYEMAGNIFYING,
    /* Chin-sliming */
    KW_NEWBEAUTY_TYPE_CHINSLIMING,
    /* Skin-whitening */
    KW_NEWBEAUTY_TYPE_SKINWHITENING,
    /* Skin-blemish removal */
    KW_NEWBEAUTY_TYPE_BLEMISHREMOVAL,
    /* Skin-saturation */
    KW_NEWBEAUTY_TYPE_SKINSATURATION,
    /* Skin-tenderness */
    KW_NEWBEAUTY_TYPE_SKINTENDERNESS
};


//This enum is deprecated.
//Use enum above.
typedef NS_ENUM(NSInteger,KW_BEAUTYPARAMS_TYPE)
{
    /* Big eye  */
    KW_BEAUTYPARAMS_TYPE_BULGEEYE,
    /* Face-lift */
    KW_BEAUTYPARAMS_TYPE_THINFACE,
    /* facial whitening */
    KW_BEAUTYPARAMS_TYPE_BRIGHTNESS,
    /* skin smoothing */
    KW_BEAUTYPARAMS_TYPE_BILATERAL,
    /* skin tone saturation */
    KW_BEAUTYPARAMS_TYPE_ROU,
    /* skin shinning tenderness */
    KW_BEAUTYPARAMS_TYPE_SAT
};


/* Distorting mirror enumeration */
typedef NS_ENUM(NSInteger,KW_DISTORTION_TYPE)
{
    KW_DISTORTION_TYPE_NONE = -1,
    /* Square face */
    KW_DISTORTION_TYPE_SQUAREFACE = 0,
    /* ET */
    KW_DISTORTION_TYPE_ET,
    /* fat face */
    KW_DISTORTION_TYPE_FATFACE,
    /* small face */
    KW_DISTORTION_TYPE_SMALLFACE
};

+ (Global *)sharedManager;

/* Whether the project is based on seven cattle (seven cattle video home page default orientation towards the default rotation 0 degrees non-seven cattle home to the right that is rotated 90 degrees) */
@property (nonatomic, assign) KW_PIXELBUFFER_ROTATE PIXCELBUFFER_ROTATE;

//Determine whether the default video frame image portrait
-(BOOL)isPixcelBufferRotateVertical;




@end
