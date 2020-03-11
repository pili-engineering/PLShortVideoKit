//
//  MulitPhotoAlbumViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MulitPhotoAlbumViewController.h"
#import "MulitClipViewController.h"

@interface MulitPhotoAlbumViewController ()

@end

@implementation MulitPhotoAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextButtonClick:(UIButton *)sender {
    
    NSMutableArray *assetArray = [self.dynamicScrollView selectedAssets];
    if (0 == assetArray.count) return;
    
    MulitClipViewController *mulitClipViewController = [[MulitClipViewController alloc] init];
    mulitClipViewController.phAssetArray = assetArray;
    mulitClipViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:mulitClipViewController animated:YES completion:nil];
}

@end
