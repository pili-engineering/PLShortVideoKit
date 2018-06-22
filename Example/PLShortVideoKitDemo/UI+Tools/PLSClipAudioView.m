//
//  PLSClipAudioView.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/6/21.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSClipAudioView.h"
#import <AVFoundation/AVFoundation.h>

#define PLS_AUDIO_TIMERANGE_VIEW_CONTENT_VIEW_WIDTH   280
#define PLS_AUDIO_TIMERANGE_VIEW_CONTENT_VIEW_HEIGHT  200
#define PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING         20
#define PLS_AUDIO_TIMERANGE_VIEW_INTERVAL_PADDING     10

@interface PLSClipAudioView ()
{
    UIView *bgView;
    UIView *contentView;
    UILabel *musicTimeRangeLabel;
    UIImageView *musicImageView;
    UISlider *musicTimeRangeSlider;
    UIButton *confirmBtn;
    CMTimeRange orgMusicTimeRange;
    
    UILabel *musicStartTimeLabel;
    UILabel *musicEndTimeLabel;
    
    CMTime musicTotalDuration; // 音乐文件的原始总时长
}

@property (assign, nonatomic) CMTimeRange currentMusicTimeRange;

@end

@implementation PLSClipAudioView

- (id)initWithMuiscURL:(NSURL *)url timeRange:(CMTimeRange)currentMusicTimeRange {
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        _currentMusicTimeRange = currentMusicTimeRange;
        orgMusicTimeRange = currentMusicTimeRange;
        
        musicTotalDuration = CMTimeMake([self getFileDuration:url], 1);
        
        [self performLayout];
    }
    return self;
}

- (void)performLayout {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    bgView = [[UIView alloc] initWithFrame:window.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.0;
    [bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundViewTapped:)]];
    [self addSubview:bgView];
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_AUDIO_TIMERANGE_VIEW_CONTENT_VIEW_WIDTH,PLS_AUDIO_TIMERANGE_VIEW_CONTENT_VIEW_HEIGHT)];
    contentView.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2 - 32);
    contentView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    contentView.alpha = 1.0;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    musicTimeRangeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING, PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING, contentView.frame.size.width - PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING*2, 21)];
    musicTimeRangeLabel.textAlignment = NSTextAlignmentLeft;
    musicTimeRangeLabel.text = @"Music TimeRange";
    musicTimeRangeLabel.textColor = [UIColor grayColor];
    [contentView addSubview:musicTimeRangeLabel];
    
    musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING, musicTimeRangeLabel.frame.origin.y + musicTimeRangeLabel.frame.size.height + PLS_AUDIO_TIMERANGE_VIEW_INTERVAL_PADDING, 20, 20)];
    musicImageView.image = [UIImage imageNamed:@"music"];
    [contentView addSubview:musicImageView];
    
    musicTimeRangeSlider = [[UISlider alloc] initWithFrame:CGRectMake(musicImageView.frame.origin.x + musicImageView.frame.size.width + PLS_AUDIO_TIMERANGE_VIEW_INTERVAL_PADDING, musicImageView.frame.origin.y, contentView.frame.size.width - PLS_AUDIO_TIMERANGE_VIEW_INTERVAL_PADDING*2 - musicImageView.frame.origin.x - musicImageView.frame.size.width - PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING, 20)];
    musicTimeRangeSlider.tag = 0;
    musicTimeRangeSlider.minimumTrackTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1];
    [musicTimeRangeSlider setThumbImage:[UIImage imageNamed:@"slide_volume"] forState:UIControlStateNormal];
    [musicTimeRangeSlider setThumbTintColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1]];
    musicTimeRangeSlider.minimumValue = 0.f;
    musicTimeRangeSlider.maximumValue = CMTimeGetSeconds(self.currentMusicTimeRange.start) + CMTimeGetSeconds(self.currentMusicTimeRange.duration);
    musicTimeRangeSlider.value = CMTimeGetSeconds(self.currentMusicTimeRange.start);
    [musicTimeRangeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    musicTimeRangeSlider.continuous = NO;
    [contentView addSubview:musicTimeRangeSlider];
    
    musicStartTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING, musicImageView.frame.origin.y + musicImageView.frame.size.height + PLS_AUDIO_TIMERANGE_VIEW_INTERVAL_PADDING, contentView.frame.size.width - PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING*2, 21)];
    musicStartTimeLabel.textAlignment = NSTextAlignmentLeft;
    musicStartTimeLabel.text = [NSString stringWithFormat:@"Start: %@", [self timeFormatter:CMTimeGetSeconds(_currentMusicTimeRange.start)]];
    musicStartTimeLabel.textColor = [UIColor redColor];
    [contentView addSubview:musicStartTimeLabel];
    
    musicEndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING, musicImageView.frame.origin.y + musicImageView.frame.size.height + PLS_AUDIO_TIMERANGE_VIEW_INTERVAL_PADDING, contentView.frame.size.width - PLS_AUDIO_TIMERANG_VIEW_LEFT_PADDING*2, 21)];
    musicEndTimeLabel.textAlignment = NSTextAlignmentRight;
    musicEndTimeLabel.text = [NSString stringWithFormat:@"End: %@", [self timeFormatter:(CMTimeGetSeconds(_currentMusicTimeRange.start) + CMTimeGetSeconds(_currentMusicTimeRange.duration))]];
    musicEndTimeLabel.textColor = [UIColor redColor];
    [contentView addSubview:musicEndTimeLabel];

    UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 41, contentView.frame.size.width, 1)];
    seperateLineView.backgroundColor = [UIColor grayColor];
    [contentView addSubview:seperateLineView];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(0, contentView.frame.size.height - 40, contentView.frame.size.width, 40);
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmBtn];
}

- (void)sliderValueDidChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (slider.tag == 0) {
        //music timeRange
        self.currentMusicTimeRange = CMTimeRangeMake(CMTimeMake(slider.value, 1), CMTimeSubtract(musicTotalDuration, CMTimeMake(slider.value, 1)));
        
        // update UI
        dispatch_async(dispatch_get_main_queue(), ^{
            musicStartTimeLabel.text = [NSString stringWithFormat:@"Start: %@", [self timeFormatter:CMTimeGetSeconds(_currentMusicTimeRange.start)]];
        });
        
        if (_delegate && [_delegate respondsToSelector:@selector(clipAudioView:musicTimeRangeChangedTo:)]) {
            [_delegate clipAudioView:self musicTimeRangeChangedTo:self.currentMusicTimeRange];
        }
    }
}

- (void)showAtView:(UIView *)view {
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    contentView.layer.opacity = 0.5f;
    contentView.layer.transform = CATransform3DMakeScale(1.1f, 1.1f, 1.0);
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         bgView.alpha = 0.3;
                         contentView.layer.opacity = 1.0f;
                         contentView.layer.transform = CATransform3DMakeScale(1, 1, 1);
                     }
                     completion:NULL
     ];
}

- (void)hide {
    [self removeFromSuperview];
}

- (void)backgroundViewTapped:(id)sender {
    [self hide];
}

- (void)confirmButtonPressed:(id)sender {
    [self hide];
}

//Time format: "hh:mm:ss"
//if hh=00, return:"mm:ss"
- (NSString *)timeFormatter:(int)timeOnSecond {
    int hour = timeOnSecond / 3600;
    int minute = (timeOnSecond - hour * 3600) / 60;
    int second = timeOnSecond - hour * 3600 - minute * 60;
    if (hour != 0) {
        return [NSString stringWithFormat:@"%02d:%o2d:%02d", hour, minute, second];
    }else{
        return [NSString stringWithFormat:@"%02d:%02d", minute, second];
    }
}

- (CGFloat)getFileDuration:(NSURL*)URL {
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:URL options:opts];
    
    CMTime duration = asset.duration;
    float durationSeconds = CMTimeGetSeconds(duration);
    
    return durationSeconds;
}

@end

