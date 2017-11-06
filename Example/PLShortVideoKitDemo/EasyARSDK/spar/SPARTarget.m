//
//  SPARTarget.m
//  EasyAR3D
//
//  Created by Qinsi on 9/29/16.
//
//

#import "SPARTarget.h"

@implementation SPARTarget

static NSString *kTypeImage = @"image";

static NSString *kKeyTargetType = @"targetType";
static NSString *kKeyTargetDesc = @"targetDesc";
static NSString *kKeyImage = @"image";
static NSString *kKeyUId = @"uid";


/**
 静态方法：构造函数
 */
+ (SPARTarget *)SPARTargetFromDict:(NSDictionary *)dict {
    NSString *targetType = dict[kKeyTargetType];
    NSDictionary *targetDesc = dict[kKeyTargetDesc];
    SPARTarget *res = [[SPARTarget alloc] initWithType:targetType andDesc:targetDesc];
    return res;
}


/**
 构造函数，当type是image时才给url和uid赋值
 */
- (instancetype)initWithType:(NSString *)type andDesc:(NSDictionary *)desc {
    self = [super init];
    if (self) {
        self.type = type;
        self.desc = desc;
        if ([kTypeImage isEqualToString:type]) {
            self.url = desc[kKeyImage];
            self.uid = desc[kKeyUId];
        }
    }
    return self;
}


/**
 将SPARTarget对象转换成字典
 */
- (NSDictionary *)toDict {
    return @{
             kKeyTargetType: self.type,
             kKeyTargetDesc: self.desc,
             };
}


@end
