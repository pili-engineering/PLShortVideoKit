//
//  KWGlobalFilter.m
//  KiwiFaceKitDemo
//
//  Created by jacoy on 2017/8/9.
//  Copyright © 2017年 0dayZh. All rights reserved.
//

#import "KWGlobalFilter.h"
#import "KWColorFilter.h"

@implementation KWGlobalFilter

- (instancetype)initWithName:(NSString *)name filterResourceDir:(NSString *)filterResourceDir type:(KWFilterType)type {
    if (self = [super init]) {
        self.name = name;
        self.type = type;
        self.filterResourceDir = filterResourceDir;
    }
    return self;
}

- (id)getShaderFilter {

    GPUImageOutput <GPUImageInput, KWRenderProtocol> *shaderFilter;

    if (self.type == KWFilterTypeDefault) {

        shaderFilter = [[KWColorFilter alloc] initWithDir:self.filterResourceDir];

    } else {

        Class class = NSClassFromString(self.name);
        shaderFilter = [[class alloc] init];
    }

    return shaderFilter;
}

@end
