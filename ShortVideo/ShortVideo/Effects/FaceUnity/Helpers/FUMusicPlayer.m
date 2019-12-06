//
//  FUMusicPlayer.m
//  FULive
//
//  Created by 刘洋 on 2017/10/13.
//  Copyright © 2017年 liuyang. All rights reserved.
//

#import "FUMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>

@implementation FUMusicPlayer
{
    AVAudioPlayer *audioPlayer;
    NSString *musicName;
}

+ (FUMusicPlayer *)sharePlayer{
    static FUMusicPlayer *_sharePlayer;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharePlayer = [[FUMusicPlayer alloc] init];
        _sharePlayer.enable = YES;
    });
    
    return _sharePlayer;
}

- (void)setEnable:(BOOL)enable{
    if (_enable == enable) {
        return;
    }
    _enable = enable;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (enable) {
            [self rePlay];
        }else [self pause];
    });
}

- (void)playMusic:(NSString *)music{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
            audioPlayer = nil;
        }
        
        if (music) {
            NSString *path = [[NSBundle mainBundle] pathForResource:music ofType:nil];
            if (path) {
                NSURL *musicUrl = [NSURL fileURLWithPath:path];
                if (musicUrl) {
                    musicName = music;
                    
                    if (self.enable) {
                        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:nil];
                        audioPlayer.numberOfLoops = 100000;
                        
                        [audioPlayer play];
                    }
                }
            }
        }
    });
}

- (void)resume{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![audioPlayer isPlaying]) {
            [audioPlayer play];
        }
    });
}

- (void)rePlay{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self playMusic:musicName];
    });
}

- (void)pause{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([audioPlayer isPlaying]) {
            [audioPlayer pause];
        }
    });
}

- (void)stop{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([audioPlayer isPlaying]) {
            [audioPlayer stop];
        }
        
        audioPlayer = nil;
    });
}

- (float)playProgress {
    if (audioPlayer.duration > 0) {
        return audioPlayer.currentTime / (audioPlayer.duration);
    }else return 0.0;
}

- (NSTimeInterval)currentTime {
    return audioPlayer.currentTime;
}

@end
