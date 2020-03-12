//
//  PLSTimelineItemCell.h
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 时间线百分比
 */
@interface PLSTimelinePercent : NSObject

@property (nonatomic, assign) CGFloat leftPercent;
@property (nonatomic, assign) CGFloat rightPercent;
@property (nonatomic, strong) UIColor *color;

@end

@interface PLSTimelineItemCell : UICollectionViewCell

@property (nonatomic, assign) CGFloat mappedBeginTime;
@property (nonatomic, assign) CGFloat mappedEndTime;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setMappedBeginTime:(CGFloat)mappedBeginTime
                   endTime:(CGFloat)mappedEndTime
                     image:(UIImage *)image
          timelinePercents:(NSArray *)percents
     timelineAudioPercents:(NSArray *)audioPercents;
@end

