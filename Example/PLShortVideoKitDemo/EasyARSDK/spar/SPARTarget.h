#import <Foundation/Foundation.h>

@interface SPARTarget : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSDictionary *desc;

+ (SPARTarget *)SPARTargetFromDict:(NSDictionary *)dict;
- (instancetype)initWithType:(NSString *)type andDesc:(NSDictionary *)desc;
- (NSDictionary *)toDict;

@end
