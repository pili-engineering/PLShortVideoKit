//
//  Stalker
//
//  Created by Luca Querella on 23/05/14.
//  Copyright (c) 2014 BendingSpoons. All rights reserved.
//

@import Foundation;

typedef void (^STStalkerKVONotificationBlock)(id object, NSDictionary *change);
typedef void (^STStalkerNotificationBlock)(NSNotification *notification);

@interface STStalker : NSObject
@property(nonatomic, strong) NSNotificationCenter *notificationCenter;

- (void)whenPath:(NSString *)path
 changeForObject:(id)object
         options:(NSKeyValueObservingOptions)options
   dispatchQueue:(dispatch_queue_t)dispatchQueue
            then:(STStalkerKVONotificationBlock)block;

- (void)whenPath:(NSString *)path
 changeForObject:(id)object
         options:(NSKeyValueObservingOptions)options
            then:(STStalkerKVONotificationBlock)block;

- (void)when:(NSString *)notification then:(STStalkerNotificationBlock)block;

- (void)unobserveAll;

@end
