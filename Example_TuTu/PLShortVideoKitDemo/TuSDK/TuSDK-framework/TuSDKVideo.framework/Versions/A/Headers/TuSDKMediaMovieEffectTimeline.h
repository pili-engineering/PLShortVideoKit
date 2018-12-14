//
//  TuSDKMediaMovieEffectTimeline.h
//  TuSDKVideo
//
//  Created by sprint on 17/09/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import "TuSDKMediaEffectTimeline.h"


@interface TuSDKMediaMovieEffectTimeline : NSObject <TuSDKMediaEffectTimeline>
{
    @protected
    NSMutableDictionary<NSNumber *,NSMutableArray<id<TuSDKMediaEffect>> *> *_allEffectsDic;
}

@end
