//
//  KWGlobalFilter.h
//  KiwiFaceKitDemo
//
//  Created by jacoy on 2017/8/9.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KWFilterType)
{
    KWFilterTypeDefault,//0  Kiwi's downloadURL
    KWFilterTypeInner,//1 your own downloadURL
};

@interface KWGlobalFilter : NSObject

@property(nonatomic, copy) NSString *name;

@property(nonatomic, copy) NSString *filterResourceDir;

@property(nonatomic, assign) KWFilterType type;

- (instancetype)initWithName:(NSString *)name filterResourceDir:(NSString *)filterResourceDir type:(KWFilterType)type;

- (id)getShaderFilter;

@end
