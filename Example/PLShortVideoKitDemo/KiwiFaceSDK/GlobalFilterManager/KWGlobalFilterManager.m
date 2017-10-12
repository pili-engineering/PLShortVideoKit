

#import "KWGlobalFilterManager.h"
#import "KWGlobalFilter.h"

@interface KWGlobalFilterManager ()

@property(nonatomic, copy) NSString *jsonPath;

@property(nonatomic, strong) NSMutableArray *filters;


@end

@implementation KWGlobalFilterManager
{
    dispatch_queue_t _ioQueue;
}

KWGlobalFilterManager *sharedColorFilterManager = nil;

+ (instancetype)sharedManager {
    if (sharedColorFilterManager == nil) {
        sharedColorFilterManager = [[KWGlobalFilterManager alloc] init];
    }
    return sharedColorFilterManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _ioQueue = dispatch_queue_create("com.sobrr.colorfilters", DISPATCH_QUEUE_SERIAL);
        self.filters = [[NSMutableArray alloc] init];

        self.jsonPath =
                [[[NSBundle mainBundle] pathForResource:@"KWResource" ofType:@"bundle"] stringByAppendingPathComponent:@"filter"];

        if (![[NSFileManager defaultManager] fileExistsAtPath:self.jsonPath isDirectory:NULL]) {
            NSLog(@"filter folder do not exist");
        }
    }
    return self;
}

/**
 Asynchronous mode reads all the colorfilter information from the file
 
 @param completion Read the callback after completion
 */
- (void)loadColorFiltersWithCompletion:(void (^)(NSMutableArray<KWGlobalFilter *> *filters))completion {

    dispatch_async(_ioQueue, ^{

        if ([self getColorsFilterFromJson]) {

            completion(self.filters);
        }
    });
}

- (BOOL)getColorsFilterFromJson {
    BOOL isLoadSuccess = NO;

    // Read the config file in the resource directory
    NSString *configPath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"filters.json"];

    if (![[NSFileManager defaultManager] fileExistsAtPath:configPath isDirectory:NULL]) {
        NSLog(@"The general configuration file for the filter in the resource directory does not exist");
        return isLoadSuccess;
    }

    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:configPath];
    NSDictionary *oldDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error || !oldDict) {
        NSLog(@"Resource directory under the general configuration file to read the filters failed:%@", error);
        return isLoadSuccess;
    }

    NSArray *jsonArr = [oldDict objectForKey:@"filters"];

    //遍历json返回sticker数组
    for (NSDictionary *itemDict in jsonArr) {

        NSString *filterDir = [NSString stringWithFormat:@"%@/%@/", self.jsonPath, [itemDict valueForKey:@"dir"]];

        if ([[itemDict valueForKey:@"category"] isEqual:@"inner"]) {

            KWGlobalFilter *filter =
                    [[KWGlobalFilter alloc] initWithName:[itemDict valueForKey:@"name"] filterResourceDir:filterDir type:KWFilterTypeInner];

            [self.filters addObject:filter];

        } else if ([[itemDict valueForKey:@"category"] isEqual:@"default"]) {

            KWGlobalFilter *filter =
                    [[KWGlobalFilter alloc] initWithName:[itemDict valueForKey:@"name"] filterResourceDir:filterDir type:KWFilterTypeDefault];

            [self.filters addObject:filter];
        }
    }

    isLoadSuccess = YES;
    return isLoadSuccess;
}

+ (void)removeAllColorFilters {
    [[KWGlobalFilterManager sharedManager].filters removeAllObjects];
    [KWGlobalFilterManager sharedManager].filters = nil;
    [KWGlobalFilterManager sharedManager].jsonPath = nil;
    sharedColorFilterManager = nil;
}

@end
