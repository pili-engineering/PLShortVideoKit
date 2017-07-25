//
//  Stalker
//
//  Created by Luca Querella on 23/05/14.
//  Copyright (c) 2014 BendingSpoons. All rights reserved.
//

@import ObjectiveC;
@import libkern;

#import "STStalker.h"

@interface BPKVOStalking : NSObject
@property(nonatomic, weak) STStalker *stalker;
@property(nonatomic) NSString *keyPath;
@property(nonatomic) NSKeyValueObservingOptions options;
@property(nonatomic) dispatch_queue_t dispatchQueue;
@property(nonatomic, strong) STStalkerKVONotificationBlock block;
@end

@implementation BPKVOStalking
- (instancetype)initWithStalker:(STStalker *)stalker
                        keyPath:(NSString *)keyPath
                        options:(NSKeyValueObservingOptions)options
                  dispatchQueue:(dispatch_queue_t)dispatchQueue
                          block:(STStalkerKVONotificationBlock)block
{
    self = [super init];
    if (self) {
        self.stalker = stalker;
        self.keyPath = [keyPath copy];
        self.options = options;
        self.block = [block copy];
        self.dispatchQueue = dispatchQueue;
    }

    return self;
}

- (NSUInteger)hash
{
    return [self.keyPath hash];
}

- (BOOL)isEqual:(id)object
{
    if (!object) return NO;

    if (self == object) return YES;

    if (![object isKindOfClass:[self class]]) return NO;

    return [self.keyPath isEqualToString:((BPKVOStalking *)object).keyPath];
}

@end

#pragma mark - BPSharedStalker

@interface BPSharedStalker : NSObject
@property(nonatomic, strong) NSHashTable *KVOStalkers;
@property(nonatomic) OSSpinLock lock;
@end

@implementation BPSharedStalker
+ (instancetype)sharedStalker
{
    static BPSharedStalker *sharedStalker;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      sharedStalker = [[BPSharedStalker alloc] init];
    });
    return sharedStalker;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.KVOStalkers = [[NSHashTable alloc]
            initWithOptions:NSPointerFunctionsWeakMemory | NSPointerFunctionsObjectPointerPersonality
                   capacity:0];
        self.lock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)observeKVO:(id)object info:(BPKVOStalking *)info
{
    if (!object) return;

    OSSpinLockLock(&_lock);
    [self.KVOStalkers addObject:info];
    OSSpinLockUnlock(&_lock);

    [object addObserver:self forKeyPath:info.keyPath options:info.options context:(void *)info];
}

- (void)unobserveKVO:(id)object info:(BPKVOStalking *)info
{
    if (!object) return;

    OSSpinLockLock(&_lock);
    [self.KVOStalkers removeObject:info];
    OSSpinLockUnlock(&_lock);

    [object removeObserver:self forKeyPath:info.keyPath context:(void *)info];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    BPKVOStalking *KVOStalking;
    {
        OSSpinLockLock(&_lock);
        KVOStalking = [self.KVOStalkers member:(__bridge id)context];
        OSSpinLockUnlock(&_lock);
    }

    STStalker *stalker = KVOStalking.stalker;
    NSDictionary *copyOfChange = change.copy;

    if (stalker && KVOStalking.block) {
        if (KVOStalking.dispatchQueue) {
            dispatch_async(KVOStalking.dispatchQueue, ^{
              KVOStalking.block(object, copyOfChange);
            });
        } else {
            KVOStalking.block(object, copyOfChange);
        }
    }
}

@end

#pragma mark - BPStalker

@interface STStalker ()
@property(atomic, weak) id target;
@property(nonatomic, strong) NSMapTable *KVOStalkingsMap;
@property(nonatomic) OSSpinLock lock;
@property(nonatomic) NSMutableArray *notificationCenterObservers;

@end

@implementation STStalker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.notificationCenter = [NSNotificationCenter defaultCenter];
        self.notificationCenterObservers = [@[] mutableCopy];

        NSPointerFunctionsOptions keyOptions =
            NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPointerPersonality;
        self.KVOStalkingsMap =
            [[NSMapTable alloc] initWithKeyOptions:keyOptions
                                      valueOptions:NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPersonality
                                          capacity:0];
        self.lock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)setNotificationCenter:(NSNotificationCenter *)notificationCenter
{
    NSAssert(!self.notificationCenterObservers.count, @"notication center can't be changed after being used");
    _notificationCenter = notificationCenter;
}

- (void)whenPath:(NSString *)path
 changeForObject:(id)object
         options:(NSKeyValueObservingOptions)options
            then:(STStalkerKVONotificationBlock)block
{
    [self whenPath:path changeForObject:object options:options dispatchQueue:nil then:block];
}

- (void)whenPath:(NSString *)path
 changeForObject:(id)object
         options:(NSKeyValueObservingOptions)options
   dispatchQueue:(dispatch_queue_t)dispatchQueue
            then:(STStalkerKVONotificationBlock)block;
{
    NSParameterAssert(path.hash);
    NSParameterAssert(block);
    NSParameterAssert(object);

    BPKVOStalking *stalking = [[BPKVOStalking alloc] initWithStalker:self
                                                             keyPath:path
                                                             options:options
                                                       dispatchQueue:dispatchQueue
                                                               block:block];
    OSSpinLockLock(&_lock);

    NSMutableSet *stalkingsForObject = [self.KVOStalkingsMap objectForKey:object];
    if (!stalkingsForObject) {
        stalkingsForObject = [NSMutableSet set];
        [self.KVOStalkingsMap setObject:stalkingsForObject forKey:object];
    }

    NSAssert(![stalkingsForObject member:stalking], @"observation already exists");

    [stalkingsForObject addObject:stalking];
    OSSpinLockUnlock(&_lock);

    [[BPSharedStalker sharedStalker] observeKVO:object info:stalking];
}

- (void)when:(NSString *)notification then:(STStalkerNotificationBlock)block
{
    NSParameterAssert(notification);
    NSParameterAssert(block);

    id observer = [self.notificationCenter addObserverForName:notification
                                                       object:nil
                                                        queue:[NSOperationQueue mainQueue]
                                                   usingBlock:block];

    [self.notificationCenterObservers addObject:observer];
}

- (void)unobserveAll
{
    for (id observer in self.notificationCenterObservers) [self.notificationCenter removeObserver:observer];

    [self.notificationCenter removeObserver:self];

    OSSpinLockLock(&_lock);
    NSMapTable *KVOStalkingsMap = [self.KVOStalkingsMap copy];

    [self.KVOStalkingsMap removeAllObjects];
    OSSpinLockUnlock(&_lock);

    BPSharedStalker *sharedStalker = [BPSharedStalker sharedStalker];

    for (id object in KVOStalkingsMap) {
        NSSet *paths = [KVOStalkingsMap objectForKey:object];
        for (BPKVOStalking *stalking in paths) {
            [sharedStalker unobserveKVO:object info:stalking];
        }
    }
}

- (void)dealloc
{
    [self unobserveAll];
}

@end
