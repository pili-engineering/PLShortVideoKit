//
//  PLSAudioVolumeView.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2017/6/5.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSAudioVolumeView.h"

#define PLS_AUDIO_VOLUME_VIEW_CONTENT_VIEW_WIDTH   280
#define PLS_AUDIO_VOLUME_VIEW_CONTENT_VIEW_HEIGHT  200
#define PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING         20
#define PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING     10

@interface PLSAudioVolumeView ()
{
    UIView *bgView;
    UIView *contentView;
    UILabel *movieVolumeLabel;
    UILabel *musicVolumeLabel;
    UIImageView *movieImageView;
    UIImageView *musicImageView;
    UISlider *movieVolumeSlider;
    UISlider *musicVolumeSlider;
    UIButton *cancelBtn;
    UIButton *confirmBtn;
    CGFloat orgMovieVolume;
    CGFloat orgMusicVolune;
}

@property (assign, nonatomic) CGFloat currentMovieVolume;
@property (assign, nonatomic) CGFloat currentMusicVolume;

@end

@implementation PLSAudioVolumeView

- (id)initWithMovieVolume:(CGFloat)currentMovieVolume musicVolume:(CGFloat)currentMusicVolume {
    self = [super initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
    if (self) {
        _currentMovieVolume = currentMovieVolume;
        _currentMusicVolume = currentMusicVolume;
        orgMovieVolume = currentMovieVolume;
        orgMusicVolune = currentMusicVolume;
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
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PLS_AUDIO_VOLUME_VIEW_CONTENT_VIEW_WIDTH,PLS_AUDIO_VOLUME_VIEW_CONTENT_VIEW_HEIGHT)];
    contentView.center = CGPointMake(window.frame.size.width/2, window.frame.size.height/2 - 32);
    contentView.backgroundColor = [UIColor colorWithRed:40.0/255.0 green:40.0/255.0 blue:40.0/255.0 alpha:1];
    contentView.alpha = 1.0;
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    
    movieVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, contentView.frame.size.width - PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING*2, 21)];
    movieVolumeLabel.textAlignment = NSTextAlignmentLeft;
    movieVolumeLabel.text = @"Movie Volume";
    movieVolumeLabel.textColor = [UIColor grayColor];
    [contentView addSubview:movieVolumeLabel];
    
    movieImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, movieVolumeLabel.frame.origin.y + movieVolumeLabel.frame.size.height + PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING, 20, 20)];
    movieImageView.image = [UIImage imageNamed:@"icon_volume"];
    [contentView addSubview:movieImageView];
    
    movieVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(movieImageView.frame.origin.x + movieImageView.frame.size.width + PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING, movieImageView.frame.origin.y, contentView.frame.size.width - PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING*2 - movieImageView.frame.origin.x - movieImageView.frame.size.width - PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, 20)];
    movieVolumeSlider.tag = 0;
    movieVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1];
    [movieVolumeSlider setThumbImage:[UIImage imageNamed:@"slide_volume"] forState:UIControlStateNormal];
    [movieVolumeSlider setThumbTintColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1]];
    movieVolumeSlider.minimumValue = 0.f;
    movieVolumeSlider.maximumValue = 1.f;
    movieVolumeSlider.value = self.currentMovieVolume;
    [movieVolumeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:movieVolumeSlider];
    
    musicVolumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, movieVolumeSlider.frame.origin.x + movieVolumeSlider.frame.size.height + PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING, contentView.frame.size.width - PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING*2, 21)];
    musicVolumeLabel.textAlignment = NSTextAlignmentLeft;
    musicVolumeLabel.text = @"Music Volume";
    musicVolumeLabel.textColor = [UIColor grayColor];
    [contentView addSubview:musicVolumeLabel];
    
    musicImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, musicVolumeLabel.frame.origin.y + musicVolumeLabel.frame.size.height + PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING, 20, 20)];
    musicImageView.image = [UIImage imageNamed:@"icon_volume"];
    [contentView addSubview:musicImageView];
    
    musicVolumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(musicImageView.frame.origin.x + musicImageView.frame.size.width + PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING, musicImageView.frame.origin.y, contentView.frame.size.width - PLS_AUDIO_VOLUME_VIEW_INTERVAL_PADDING*2 - musicImageView.frame.origin.x - musicImageView.frame.size.width - PLS_AUDIO_VOLUME_VIEW_LEFT_PADDING, 20)];
    musicVolumeSlider.tag = 1;
    musicVolumeSlider.minimumTrackTintColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1];
    [musicVolumeSlider setThumbImage:[UIImage imageNamed:@"slide_volume"] forState:UIControlStateNormal];
    [musicVolumeSlider setThumbTintColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:87.0/255.0 alpha:1]];
    musicVolumeSlider.minimumValue = 0.f;
    musicVolumeSlider.maximumValue = 1.f;
    musicVolumeSlider.value = self.currentMusicVolume;
    [musicVolumeSlider addTarget:self action:@selector(sliderValueDidChanged:) forControlEvents:UIControlEventValueChanged];
    [contentView addSubview:musicVolumeSlider];
    
    UIView *seperateLineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.frame.size.height - 41, contentView.frame.size.width, 1)];
    seperateLineView.backgroundColor = [UIColor grayColor];
    [contentView addSubview:seperateLineView];
    
    cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, contentView.frame.size.height - 40, contentView.frame.size.width/2, 40);
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:cancelBtn];
    
    confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(contentView.frame.size.width/2+1, contentView.frame.size.height - 40, contentView.frame.size.width/2, 40);
    [confirmBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"OK" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:confirmBtn];
    
    UIView *seperateLineView1 = [[UIView alloc] initWithFrame:CGRectMake(contentView.frame.size.width/2, contentView.frame.size.height - 40, 1, 40)];
    seperateLineView1.backgroundColor = [UIColor grayColor];
    [contentView addSubview:seperateLineView1];
}

- (void)sliderValueDidChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (slider.tag == 0) {
        //movie volume
        self.currentMovieVolume = slider.value;
        [_delegate audioVolumeView:self movieVolumeChangedTo:self.currentMovieVolume musicVolumeChangedTo:self.currentMusicVolume];
    }else{
        //music volume
        self.currentMusicVolume = slider.value;
        [_delegate audioVolumeView:self movieVolumeChangedTo:self.currentMovieVolume musicVolumeChangedTo:self.currentMusicVolume];
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

- (void)cancelButtonPressed:(id)sender {
    [_delegate audioVolumeView:self movieVolumeChangedTo:orgMovieVolume musicVolumeChangedTo:orgMusicVolune];
    [self hide];
}

- (void)confirmButtonPressed:(id)sender {
    [_delegate audioVolumeView:self movieVolumeChangedTo:self.currentMovieVolume musicVolumeChangedTo:self.currentMusicVolume];
    [self hide];
}

@end
