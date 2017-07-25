//
//  Stalker
//
//  Created by Luca Querella on 23/05/14.
//  Copyright (c) 2014 BendingSpoons. All rights reserved.
//

@import ObjectiveC;

#import "NSObject+Stalker.h"

@implementation NSObject (Stalker)

- (STStalker *)stalker
{
    id stalker = objc_getAssociatedObject(self, @selector(stalker));
    if (!stalker) {
        stalker = [[STStalker alloc] init];
        objc_setAssociatedObject(self, @selector(stalker), stalker, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return stalker;
}

@end
