//
//  H265MovieViewController.m
//  PLShortVideoKitDemo
//
//  Created by suntongmian on 2018/2/12.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "H265MovieViewController.h"
#import "MovieTransCodeViewController.h"

static NSString *reuseIdentifier = @"reuseIdentifier";

@interface H265MovieViewController () <UIAlertViewDelegate>
{
    NSMutableArray *_h265VideoArray;
}

@end

@implementation H265MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.title = @"H.265";
    self.navigationController.navigationBar.barTintColor  = PLS_RGBCOLOR(65, 154, 208);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"get_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 26, 26);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(8, -6, 8, 20);
    [backButton addTarget:self action:@selector(clickBackItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    [self loadH265Videos];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
}

- (void)loadH265Videos {
    NSString *subpath = @"h265_video";
    _h265VideoArray = [[NSMutableArray alloc] init];
    
    NSBundle *bundle = [NSBundle mainBundle];
    [_h265VideoArray addObjectsFromArray:[bundle pathsForResourcesOfType:@"mp4" inDirectory:subpath]];
    [_h265VideoArray addObjectsFromArray:[bundle pathsForResourcesOfType:@"mov" inDirectory:subpath]];
}

- (void)clickBackItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _h265VideoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [_h265VideoArray[indexPath.row] lastPathComponent];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *h265VideoPath = _h265VideoArray[indexPath.row];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:h265VideoPath delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"转码", nil];
    alertView.tag = 10001;
    [alertView show];
}

#pragma mark -
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (10001 == alertView.tag) {
        NSURL *url = [NSURL fileURLWithPath:alertView.message];

        if (1 == buttonIndex) {
            // 转码
            MovieTransCodeViewController *transCodeViewController = [[MovieTransCodeViewController alloc] init];
            transCodeViewController.url = url;
            transCodeViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:transCodeViewController animated:YES completion:nil];
            
        }
    }
}

#pragma mark -- 隐藏状态栏
- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark -- dealloc
- (void)dealloc {

}

@end
