//
//  KWColorFilterManager.h
//  KiwiFaceKitDemo
//
//  Created by zhaoyichao on 2017/3/4.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWColorFilter.h"
@interface KWColorFilterManager : NSObject

+ (instancetype)sharedManager;


/**
 Asynchronous mode reads all the sticker information from the file
 
 @param completion Read the callback after completion
 */
- (void)loadColorFiltersWithCompletion:(void(^)(NSMutableArray<KWColorFilter *> *colorFilters))completion;


/*
 * Get the sticker path
 */
- (NSString *)getColorFilterPath;


/**
 Update StickerConfig's sticker download status
 */
- (void)updateConfigJSON;

@end
