//
//  FUMakeupSupModel.h
//  FULiveDemo
//
//  Created by 孙慕 on 2019/3/11.
//  Copyright © 2019年 FaceUnity. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FUSingleMakeupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FUMakeupSupModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *imageStr;
@property (nonatomic, strong) NSString *selectedFilter; /* 选中的滤镜 */
@property (nonatomic, assign) double selectedFilterLevel; /* 选中滤镜的 level*/
@property (nonatomic, assign) BOOL isSel;
@property (nonatomic, assign) float value;

/* 组合妆对应所有子妆容 */
@property (nonatomic, strong) NSArray <FUSingleMakeupModel *>* makeups;

//+(FUMakeupSupModel *)getClassName:(NSString *)name image:(NSString *)imageStr isSel:(BOOL)sel value:(float)value;
@end

NS_ASSUME_NONNULL_END
