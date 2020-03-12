//
//  VersionViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/7/19.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "VersionViewController.h"
#import "PLShortVideoKit/PLShortVideoKit.h"

@interface VersionViewController ()

@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nextButton removeFromSuperview];
    
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [infoDict objectForKey:@"CFBundleIdentifier"];
    NSString *demoBuildNumber = [infoDict objectForKey:@"CFBundleVersion"];
    NSString *sdkVersion = [PLShortVideoRecorder versionInfo];
    
    NSString *texts[] = {
        [NSString stringWithFormat:@"BundleID: %@", bundleId],
        [NSString stringWithFormat:@"Demo version: %@", demoBuildNumber],
        [NSString stringWithFormat:@"SDK version: %@", sdkVersion]
    };
    for (int i = 0; i < ARRAY_SIZE(texts); i ++) {
        UILabel *versionLabel = [[UILabel alloc] init];
        versionLabel.textColor = [UIColor colorWithWhite:1.0 alpha:.5];
        versionLabel.textAlignment = NSTextAlignmentLeft;
        versionLabel.font = [UIFont systemFontOfSize:12];
        versionLabel.text = texts[i];
        [versionLabel sizeToFit];
        versionLabel.frame = CGRectMake(20, 80 + i * 30, versionLabel.bounds.size.width , versionLabel.bounds.size.height);
        [self.view addSubview:versionLabel];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
