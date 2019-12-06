//
//  FUSingleMakeupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/2/28.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUSingleMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupModel : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* namaTypeStr;
@property (nonatomic, copy) NSString* namaValueStr;
@property (nonatomic, copy) NSArray <FUSingleMakeupModel *>* sgArr;
@property (nonatomic, assign) int singleSelIndex;

@end

NS_ASSUME_NONNULL_END
