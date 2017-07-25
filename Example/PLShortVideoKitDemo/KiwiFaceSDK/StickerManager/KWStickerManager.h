//
//  KWStickerManager.h
//  KWMediaStreamingKitDemo
//
//  Created by ChenHao on 2016/10/13.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWSticker.h"

/**
 Sticker operation management class
 */
@interface KWStickerManager : NSObject

+ (instancetype)sharedManager;



/**
 Whether through the network load stickers
 */
@property (nonatomic, assign) BOOL isLoadStickersFromServer;

/**
 Asynchronous mode reads all the sticker information from the file
 
 @param completion Read the callback after completion
 */
- (void)loadStickersWithCompletion:(void(^)(NSMutableArray<KWSticker *> *stickers))completion;


/*
 * Get the sticker path
 */
- (NSString *)getStickerPath;


/**
 Update StickerConfig's sticker download status
 */
- (void)updateConfigJSON;

/**
 Update the Json file and get new Json
 */
- (NSMutableDictionary *)updateConfigJSONForDic;

/**
 Update the json file of local stickers from the server
 completion:After the completion of the block of callback  {【isSuccess：Whether the update is successful】，【dic：The updated new json】}
 serverJson:The new stickers array from the server
 */
- (void)updateStickersJSONWithCompletion:(void(^)(BOOL isSuccess,NSMutableDictionary *dic))completion serverJson:(NSArray *)serverJson;


@end
