//
//  MultiVideoViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/6/8.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MultiVideoViewController.h"
#import "MixRecordViewController.h"
#import "VideoMixViewController.h"
#import "VideoSelectViewController.h"

@interface MultiVideoViewController ()

@property (nonatomic, strong) UIButton *mulitMixButton;
@property (nonatomic, strong) UIButton *recordingButton;
@property (nonatomic, strong) UIButton *mix2Button;
@property (nonatomic, strong) UIButton *mix3Button;
@property (nonatomic, strong) UIButton *mix4Button;

@property (nonatomic, strong) UILabel *mulitMixLabel;
@property (nonatomic, strong) UILabel *recordingMixLabel;
@end

@implementation MultiVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nextButton.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"select_pintu"];
    _mulitMixButton = [[UIButton alloc] init];
    [_mulitMixButton setImage:image forState:(UIControlStateNormal)];
    [_mulitMixButton sizeToFit];
    _mulitMixButton.center = CGPointMake(self.view.center.x, self.view.center.y - image.size.height);
    [_mulitMixButton addTarget:self action:@selector(pressMulitMixButtonEvent) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_mulitMixButton];
    
    _mulitMixLabel = [[UILabel alloc] init];
    [_mulitMixLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:.6]];
    [_mulitMixLabel setText:@"视频拼图"];
    [_mulitMixLabel sizeToFit];
    _mulitMixLabel.center = CGPointMake(_mulitMixButton.center.x, _mulitMixButton.center.y + _mulitMixButton.bounds.size.height/2 + 20);
    [self.view addSubview:_mulitMixLabel];
    
    image = [UIImage imageNamed:@"select_meterial"];
    _recordingButton = [[UIButton alloc] init];
    [_recordingButton setImage:image forState:(UIControlStateNormal)];
    [_recordingButton sizeToFit];
    _recordingButton.center = CGPointMake(self.view.center.x, self.view.center.y + image.size.height);
    [_recordingButton addTarget:self action:@selector(pressBiRecordButtonEvent) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_recordingButton];
    
    _recordingMixLabel = [[UILabel alloc] init];
    [_recordingMixLabel setTextColor:[UIColor colorWithWhite:1.0 alpha:.6]];
    [_recordingMixLabel setText:@"素材合拍"];
    [_recordingMixLabel sizeToFit];
    _recordingMixLabel.center = CGPointMake(_recordingButton.center.x, _recordingButton.center.y + _recordingButton.bounds.size.height/2 + 20);
    [self.view addSubview:_recordingMixLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClick {
    if (nil == self.mulitMixLabel.superview) {
        
        [self.mix2Button removeFromSuperview];
        [self.mix3Button removeFromSuperview];
        [self.mix4Button removeFromSuperview];
        
        [self.view addSubview:self.mulitMixButton];
        [self.view addSubview:self.mulitMixLabel];
        [self.view addSubview:self.recordingButton];
        [self.view addSubview:self.recordingMixLabel];
        
    } else {
        [super backButtonClick];
    }
}

- (void)pressMulitMixButtonEvent {
    
    [self.mulitMixLabel removeFromSuperview];
    [self.mulitMixButton removeFromSuperview];
    [self.recordingMixLabel removeFromSuperview];
    [self.recordingButton removeFromSuperview];
    
    self.titleLabel.text = @"选择拼图样式";
    if (nil == self.mix2Button) {
        UIImage *image = [UIImage imageNamed:@"2video_template"];
        _mix2Button = [[UIButton alloc] init];
        _mix2Button.tag = 2;
        [_mix2Button setImage:image forState:(UIControlStateNormal)];
        [_mix2Button sizeToFit];
        _mix2Button.center = CGPointMake(self.view.center.x, self.view.center.y - 1.5 * image.size.height);
        [_mix2Button addTarget:self action:@selector(pressMixButton:) forControlEvents:UIControlEventTouchDown];
        
        image = [UIImage imageNamed:@"3video_template"];
        _mix3Button = [[UIButton alloc] init];
        _mix3Button.tag = 3;
        [_mix3Button setImage:image forState:(UIControlStateNormal)];
        [_mix3Button sizeToFit];
        _mix3Button.center = self.view.center;
        [_mix3Button addTarget:self action:@selector(pressMixButton:) forControlEvents:UIControlEventTouchDown];
        
        image = [UIImage imageNamed:@"4video_template"];
        _mix4Button = [[UIButton alloc] init];
        _mix4Button.tag = 4;
        [_mix4Button setImage:image forState:(UIControlStateNormal)];
        [_mix4Button sizeToFit];
        _mix4Button.center = CGPointMake(self.view.center.x, self.view.center.y + 1.5 * image.size.height);
        [_mix4Button addTarget:self action:@selector(pressMixButton:) forControlEvents:UIControlEventTouchDown];
    }
   
    [self.view addSubview:self.mix2Button];
    [self.view addSubview:self.mix3Button];
    [self.view addSubview:self.mix4Button];
}

- (void)pressMixButton:(UIButton *)button {
    VideoSelectViewController *videoSelectViewController = [[VideoSelectViewController alloc] init];
    videoSelectViewController.actionType = enumVideoNextActionPingtu;
    videoSelectViewController.needVideoCount = button.tag;
    
    [self presentViewController:videoSelectViewController animated:YES completion:nil];
}

- (void)pressBiRecordButtonEvent {
    VideoSelectViewController *videoSelectViewController = [[VideoSelectViewController alloc] init];
    videoSelectViewController.actionType = enumVideoNextActionRecording;
    videoSelectViewController.needVideoCount = 1;
    
    [self presentViewController:videoSelectViewController animated:YES completion:nil];
}

@end
