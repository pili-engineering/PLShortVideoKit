//
//  MatterImportViewController.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/9/17.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "MatterImportViewController.h"
#import "PLSListFunctionTableViewCell.h"

#import "ImageVideoMixViewController.h"
#import "H265MovieViewController.h"
#import "MulitPhotoAlbumViewController.h"

@interface MatterImportViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *matterTableView;
@property (nonatomic, strong) NSArray *matterArray;
@end

@implementation MatterImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"素材导入编辑";
    self.navigationController.navigationBar.barTintColor  = PLS_RGBCOLOR(65, 154, 208);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"get_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 26, 26);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 2, 8);
    [backButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.view.backgroundColor = PLS_RGBCOLOR(242, 242, 242);
    
    self.matterArray = @[@"视频截取", @"视频分割", @"视频拼接", @"视频转码", @"图片视频混排", @"导入 H.265 视频"];
    
    [self setupMatterTableView];
}

- (void)setupMatterTableView {
    self.matterTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.matterTableView.backgroundColor = PLS_RGBCOLOR(242, 242, 242);
    self.matterTableView.delegate = self;
    self.matterTableView.dataSource = self;
    self.matterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.matterTableView registerClass:[PLSListFunctionTableViewCell class] forCellReuseIdentifier:@"matterCell"];
    [self.view addSubview:_matterTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _matterArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLSListFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"matterCell"];
    cell.titlelabel.text = _matterArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        // 视频剪辑
        PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
        photoAlbumViewController.mediaType = PHAssetMediaTypeVideo;
        photoAlbumViewController.maxSelectCount = 1;
        photoAlbumViewController.typeIndex = 0;
        photoAlbumViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:photoAlbumViewController animated:YES completion:nil];
    } else if (indexPath.row == 1) {
        // 视频分割
        MulitPhotoAlbumViewController *mulitPhotoAlbumViewController = [[MulitPhotoAlbumViewController alloc] init];
        mulitPhotoAlbumViewController.mediaType = PHAssetMediaTypeVideo;
        mulitPhotoAlbumViewController.maxSelectCount = 10;
        mulitPhotoAlbumViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:mulitPhotoAlbumViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 2) {
        // 视频拼接
        PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
        photoAlbumViewController.mediaType = PHAssetMediaTypeVideo;
        photoAlbumViewController.maxSelectCount = 10;
        photoAlbumViewController.typeIndex = 2;
        photoAlbumViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:photoAlbumViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 3) {
        // 视频转码
        PhotoAlbumViewController *photoAlbumViewController = [[PhotoAlbumViewController alloc] init];
        photoAlbumViewController.mediaType = PHAssetMediaTypeVideo;
        photoAlbumViewController.maxSelectCount = 1;
        photoAlbumViewController.typeIndex = 1;
        photoAlbumViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:photoAlbumViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 4) {
        // 图片视频混排
        ImageVideoMixViewController *imageVideoMixViewController = [[ImageVideoMixViewController alloc] init];
        imageVideoMixViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imageVideoMixViewController animated:YES completion:nil];
        
    } else if (indexPath.row == 5) {
        // 导入 H.265
        H265MovieViewController *h265MovieViewController = [[H265MovieViewController alloc] init];
        h265MovieViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController pushViewController:h265MovieViewController animated:YES];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (void)getBack {
    [self.navigationController popViewControllerAnimated:YES];
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
