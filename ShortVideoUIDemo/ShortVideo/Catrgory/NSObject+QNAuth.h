//
//  NSObject+QNAuth.h
//  ShortVideo
//
//  Created by hxiongan on 2019/4/8.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QNAuth)

+ (void)haveAlbumAccess:(void(^)(BOOL isAuth))completeBlock;

+ (void)haveCameraAccess:(void(^)(BOOL isAuth))completeBlock;

+ (void)haveMicrophoneAccess:(void(^)(BOOL isAuth))completeBlock;

@end
