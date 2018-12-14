//
//  ViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ViewController.h"
#import "RecordViewController.h"
#import "PhotoAlbumViewController.h"
#import "MulitPhotoAlbumViewController.h"
#import "H265MovieViewController.h"
#import "ImageRotateViewController.h"
#import "MultiVideoViewController.h"
#import "VersionViewController.h"
#import "ImageVideoMixViewController.h"

#define PLS_RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface ViewController () 
@property (nonatomic, strong) UIImpactFeedbackGenerator *clickFeedback;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (@available(iOS 10.0, *)) {
        self.clickFeedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
    }
    
    self.view.backgroundColor = PLS_RGBCOLOR(25, 24, 36);

    CGFloat height = 64;
    if (UIScreen.mainScreen.bounds.size.height < 667) {
        height = 54;
    }
    int index = 0;
    
    UIButton *recordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [recordButton setTitle:@"短视频录制" forState:UIControlStateNormal];
    recordButton.backgroundColor = [UIColor grayColor];
    [recordButton addTarget:self action:@selector(pressRecordButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:recordButton];
    
    index ++;
    UIButton *imagesToMovieButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [imagesToMovieButton setTitle:@"图片合成视频" forState:UIControlStateNormal];
    imagesToMovieButton.backgroundColor = [UIColor grayColor];
    [imagesToMovieButton addTarget:self action:@selector(imagesToMovieButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:imagesToMovieButton];

    index ++;
    UIButton *cutMediaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [cutMediaButton setTitle:@"视频切割" forState:UIControlStateNormal];
    cutMediaButton.backgroundColor = [UIColor grayColor];
    [cutMediaButton addTarget:self action:@selector(cutMediaButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cutMediaButton];
    
    index ++;
    UIButton *importH265VideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [importH265VideoButton setTitle:@"导入H.265视频" forState:UIControlStateNormal];
    importH265VideoButton.backgroundColor = [UIColor grayColor];
    [importH265VideoButton addTarget:self action:@selector(importH265VideoButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:importH265VideoButton];
    
    index ++;
    UIButton *imageRotateRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [imageRotateRecordButton setTitle:@"图片旋转录制" forState:UIControlStateNormal];
    imageRotateRecordButton.backgroundColor = [UIColor grayColor];
    [imageRotateRecordButton addTarget:self action:@selector(imageRotateRecordButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:imageRotateRecordButton];
    
    index ++;
    UIButton *mulitRecordButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [mulitRecordButton setTitle:@"多屏视频" forState:UIControlStateNormal];
    mulitRecordButton.backgroundColor = [UIColor grayColor];
    [mulitRecordButton addTarget:self action:@selector(mulitVideoButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:mulitRecordButton];
    
    index ++;
    UIButton *imageVideoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, height + index * (height + 10), self.view.bounds.size.width, height)];
    [imageVideoButton setTitle:@"图片视频混排" forState:UIControlStateNormal];
    imageVideoButton.backgroundColor = [UIColor grayColor];
    [imageVideoButton addTarget:self action:@selector(imageVideoButtonEvent:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:imageVideoButton];
    
    UIButton *versionButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [versionButton setTitle:@"查看版本信息" forState:(UIControlStateNormal)];
    [versionButton setTintColor:[UIColor whiteColor]];
    [versionButton addTarget:self action:@selector(versionButtonEvent:) forControlEvents:(UIControlEventTouchUpInside)];
    [versionButton sizeToFit];
    versionButton.center =  CGPointMake(self.view.center.x, self.view.bounds.size.height - 30);
    [self.view addSubview:versionButton];
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 短视频录制
- (void)pressRecordButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    RecordViewController *recordViewController = [[RecordViewController alloc] init];
    [self presentViewController:recordViewController animated:YES completion:nil];
}

// 图片合成视频
- (void)imagesToMovieButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
    photoAlbumViewController.mediaType = PHAssetMediaTypeImage;
    photoAlbumViewController.maxSelectCount = 10;
    [self presentViewController:photoAlbumViewController animated:YES completion:nil];
}

// 切割视频
- (void)cutMediaButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    MulitPhotoAlbumViewController *mulitPhotoAlbumViewController = [[MulitPhotoAlbumViewController alloc] init];
    mulitPhotoAlbumViewController.mediaType = PHAssetMediaTypeVideo;
    mulitPhotoAlbumViewController.maxSelectCount = 10;
    [self presentViewController:mulitPhotoAlbumViewController animated:YES completion:nil];
}

// 导入H.265视频
- (void)importH265VideoButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    H265MovieViewController *h265MovieViewController = [[H265MovieViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:h265MovieViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

// 图片动画录制
- (void)imageRotateRecordButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    ImageRotateViewController *imageRotateViewController = [[ImageRotateViewController alloc] init];
    [self presentViewController:imageRotateViewController animated:YES completion:nil];
}

// 多屏视频
- (void)mulitVideoButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    MultiVideoViewController *multiVideoViewController = [[MultiVideoViewController alloc] init];
    [self presentViewController:multiVideoViewController animated:YES completion:nil];
}

// 查看版本信息
- (void)versionButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    VersionViewController *versionViewController = [[VersionViewController alloc] init];
    [self presentViewController:versionViewController animated:YES completion:nil];
}

- (void)imageVideoButtonEvent:(id)sender {
    [self.clickFeedback impactOccurred];
    
    ImageVideoMixViewController *imageVideoMixViewController = [[ImageVideoMixViewController alloc] init];
    [self presentViewController:imageVideoMixViewController animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
