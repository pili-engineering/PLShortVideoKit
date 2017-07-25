//
//  FTRenderProtocol.h
//  KiwiFaceKitDemo
//
//  Created by ChenHao on 2016/11/26.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol KWRenderProtocol <NSObject>

@optional

/**
 Whether the results of face detection data, the default is NO
 */
@property (nonatomic, readonly) BOOL needTrackData;

// Whether to make changes directly to the source, the default is NO
@property (nonatomic, readonly) BOOL operatesInPlace;

/**
 Face key points (possibly more than one face)
 */
@property (nonatomic, copy) NSArray<NSArray *> *faces;

@property (nonatomic, copy) NSMutableArray *smiliesInfos;

@end
