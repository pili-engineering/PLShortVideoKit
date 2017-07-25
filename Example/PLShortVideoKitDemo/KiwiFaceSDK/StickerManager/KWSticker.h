//
//  KWSticker.h
//  KWMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/10/14.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "KWPoint.h"

typedef enum {
    KWStickerItemTypeFullScreen,  // full-screen display
    KWStickerItemTypeFace,        // Face
    KWStickerItemTypeEdge         // edge
} KWStickerItemType;

typedef enum {
    KWStickerAlignPositionTop,
    KWStickerAlignPositionLeft,
    KWStickerAlignPositionBottom,
    KWStickerAlignPositionRight,
} KWStickerAlignPosition;

typedef NS_ENUM(NSInteger,KWStickerDownloadState){
    KWStickerDownloadStateDownoadNot,//Not downloaded
    KWStickerDownloadStateDownoadDone,//Downloaded
    KWStickerDownloadStateDownoading,//downloading
};

typedef NS_ENUM(NSInteger,KWStickerSourceType){
    KWStickerSourceTypeFromKW,//0  Kiwi's downloadURL
    KWStickerSourceTypeFromLocal,//1 your own downloadURL
};

/**
A set of stickers, all the information of a component (such as a nose).
 */
@interface KWStickerItem : NSObject

typedef void(^StickerItemPlayOver)(void);

@property (nonatomic, copy) StickerItemPlayOver stickerItemPlayOver;

@property (nonatomic,assign)BOOL isLastItem;

@property (nonatomic) NSTimeInterval accumulator;

/**
The type of location to display
 */
@property (nonatomic) KWStickerItemType type;

/**
Trigger condition, default 0, always displayed
 */
@property (nonatomic) int trigerType;


/**
The directory of resources (including a set of image sequence frames)
 */
@property (nonatomic, copy) NSString *itemDir;


/**
Frames (a sequence of frames that make up an animation effect)
 */
@property (nonatomic) NSInteger count;


/**
Interval of each frame, in seconds
 */
@property (nonatomic) NSTimeInterval duration;


/**
The width of the image
 */
@property (nonatomic) float width;

/**
The picture is high
 */
@property (nonatomic) float height;

/**
 The face item parameter
 The location of the face, nose, eyes and so on
 */
@property (nonatomic) KWPosition position;

/**
The edge item parameter
 Edge position（top、bottom、left、right）
 */
@property (nonatomic) KWStickerAlignPosition alignPos;

/**
Width of the zoom factor (for the face of the item to eye distance as a reference; for the edge of the item is the screen width and height as a reference, the same below)
 */
@property (nonatomic) float scaleWidthOffset;

/**
Height scaling factor
 */
@property (nonatomic) float scaleHeightOffset;

/**
 Horizontal offset coefficient
 */
@property (nonatomic) float scaleXOffset;

/**
 Vertical offset coefficient
 */
@property (nonatomic) float scaleYOffset;


/**
 The index of the current frame
 */
@property (nonatomic) NSUInteger currentFrameIndex;

/**
Number of remaining cycles
 */
@property (nonatomic) NSUInteger loopCountdown;


/**
 According to the current frame position and time interval to obtain the next frame picture, in order to adapt to different frame rates of video streaming, to ensure the effect of animation.
   The first time to use a picture from a file loaded, and cache, the next directly from the memory access
 
 @param interval The interval of each frame of the video stream
 @return This picture can be added to the current video frame
 */
- (UIImage *)nextImageForInterval:(NSTimeInterval)interval;


/**
Similar to the -nextImageForInterval: method, but get a texture for OpenGL use
 
 @param interval The interval of each frame of the video stream
 @return textures
 */
- (GLuint)nextTextureForInterval:(NSTimeInterval)interval;


/**
 Deletes all loaded textures
 */
- (void)deleteTextures;

@end




/**
 A sticker class
 */
@interface KWSticker : NSObject

typedef void(^StickerPlayOver)(void);

@property (nonatomic, copy) StickerPlayOver stickerPlayOver;

/**
Contains all components of a sticker resource
 */
@property (nonatomic, strong) NSArray<KWStickerItem *> *items;

/**
 Directory of a sticker
 */
@property (nonatomic, copy) NSString *stickerDir;


/**
 name of a sticker
 */
@property (nonatomic, readonly) NSString *stickerName;

/**
The name of the file for the thumbnail of the sticker
 */
@property (nonatomic, readonly) NSString *stickerIcon;

/**
 The name of the file for the sound of the sticker
 */
@property (nonatomic, copy) NSString *stickerSound;


/**
Stickers are downloaded
 */
@property (nonatomic, assign) BOOL isDownload;

@property (nonatomic, assign) NSUInteger playStickerCount;


/**
 The download status of the sticker
 */
@property (nonatomic,assign)KWStickerDownloadState downloadState;


/**
 The download source type of the sticker
 */
@property (nonatomic,assign)KWStickerSourceType sourceType;

/**
 The download URL of the sticker
 */
@property (nonatomic,strong)NSURL *downloadURL;





/**
 Initialize a sticker
 
 @param name the sticker's name
 @param download the download status of the sticker in the configuration file
 @param dirurl the path of sticker
 @return a sticker object
 */
- (instancetype)initWithName:(NSString *)name thumbName:(NSString *)thumb download:(BOOL)download DirectoryURL:(NSURL *)dirurl;


/**
 Update a sticker
 
 @param sticker the sticker to update
 @param dirurl the path of sticker
 @param sucessed update sucessed callback
 @param failed update failed callback
 */
+ (void)updateStickerAfterDownload:(KWSticker *)sticker DirectoryURL:(NSURL *)dirurl sucess:(void(^)(KWSticker *))sucessed fail:(void(^)(KWSticker *))failed;

- (void)setPlayCount:(NSUInteger)count;

@end
