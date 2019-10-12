//
//  ViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 17/3/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "ViewController.h"
#import "PLSListFunctionTableViewCell.h"

#import "MatterImportViewController.h"

#import "RecordViewController.h"
#import "PhotoAlbumViewController.h"
#import "VideoSelectViewController.h"
#import "MultiVideoViewController.h"
#import "ImageRotateViewController.h"
#import "VersionViewController.h"


@interface ViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *functionTableView;
@property (nonatomic, strong) NSArray *functionArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"PLShortVideo";
    self.navigationController.navigationBar.barTintColor  = PLS_RGBCOLOR(65, 154, 208);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.view.backgroundColor = PLS_RGBCOLOR(242, 242, 242);
    
    self.functionArray = @[@[@"视频拍摄", @"屏幕录制", @"素材导入编辑"], @[@"制作视频合拍", @"制作视频拼图", @"制作音乐唱片", @"制作图片电影"], @[@"版本信息"]];
    
    [self setupFunctionTableView];
};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupFunctionTableView {
    self.functionTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.functionTableView.backgroundColor = PLS_RGBCOLOR(242, 242, 242);
    self.functionTableView.delegate = self;
    self.functionTableView.dataSource = self;
    self.functionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.functionTableView registerClass:[PLSListFunctionTableViewCell class] forCellReuseIdentifier:@"functionCell"];
    [self.view addSubview:_functionTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _functionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *rowArray = _functionArray[section];
    return rowArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLSListFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"functionCell"];
    NSArray *rowArray = _functionArray[indexPath.section];
    cell.titlelabel.text = rowArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                // 拍摄录制
                RecordViewController *recordViewController = [[RecordViewController alloc] init];
                recordViewController.screenRecord = NO;
                recordViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:recordViewController animated:YES completion:nil];
            }
            if (indexPath.row == 1) {
                // 录屏
                RecordViewController *recordViewController = [[RecordViewController alloc] init];
                recordViewController.screenRecord = YES;
                recordViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:recordViewController animated:YES completion:nil];
            }
            if (indexPath.row == 2) {
                // 素材导入编辑
                MatterImportViewController *importViewController = [[MatterImportViewController alloc] init];
                importViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.navigationController pushViewController:importViewController animated:YES];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                // 视频合拍
                VideoSelectViewController *videoSelectViewController = [[VideoSelectViewController alloc] init];
                videoSelectViewController.actionType = enumVideoNextActionRecording;
                videoSelectViewController.needVideoCount = 1;
                videoSelectViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:videoSelectViewController animated:YES completion:nil];
            }
            if (indexPath.row == 1) {
                // 视频拼图
                MultiVideoViewController *multiVideoViewController = [[MultiVideoViewController alloc] init];
                multiVideoViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:multiVideoViewController animated:YES completion:nil];
            }
            if (indexPath.row == 2) {
                // 图片动画录制
                ImageRotateViewController *imageRotateViewController = [[ImageRotateViewController alloc] init];
                imageRotateViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:imageRotateViewController animated:YES completion:nil];
            }
            if (indexPath.row == 3) {
                // 图片合成电影
                PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
                photoAlbumViewController.mediaType = PHAssetMediaTypeImage;
                photoAlbumViewController.maxSelectCount = 10;
                photoAlbumViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:photoAlbumViewController animated:YES completion:nil];
            }
        }else if (indexPath.section == 2) {
            // 查看版本信息
            VersionViewController *versionViewController = [[VersionViewController alloc] init];
            [self presentViewController:versionViewController animated:YES completion:nil];
        }
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, CGRectGetWidth(self.view.frame), 19)];
    footerView.backgroundColor = PLS_RGBCOLOR(242, 242, 242);
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 19.5, CGRectGetWidth(self.view.frame), 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [footerView addSubview:line];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _functionArray.count - 1) {
        return 0;
    }
    return 20;
}

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end
