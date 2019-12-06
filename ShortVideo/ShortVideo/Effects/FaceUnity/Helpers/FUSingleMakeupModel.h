//
//  FUSingleMakeupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FUSingleMakeupModel : NSObject
@property (nonatomic, copy) NSString* iconStr;
@property (nonatomic, copy) NSString* namaImgStr;
@property (nonatomic, copy) NSString* namaTypeStr;
@property (nonatomic, copy) NSString* namaValueStr;
@property (nonatomic, assign) float  value;
@end

NS_ASSUME_NONNULL_END
