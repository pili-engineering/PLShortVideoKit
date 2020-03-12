//
//  QNSettingsViewController.m
//  ShortVideo
//
//  Created by 冯文秀 on 2019/11/13.
//  Copyright © 2019 ahx. All rights reserved.
//

#import "QNSettingsViewController.h"

#define QN_SET_X_SPACE 16
#define QN_ROW_HEIGHT 38

@interface QNSettingsViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UIView *viewBar;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITableView *selectTableView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) CALayer *selectLayer;

@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) NSMutableArray *defaultArrays;
@property (nonatomic, strong) NSArray *infoNames;

@end

@implementation QNSettingsViewController

static NSString * const reuseIdentifier = @"selectCell";

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.infoNames = [NSMutableArray arrayWithArray:[self getSettingInfos]];
    self.defaultArrays = [NSMutableArray arrayWithArray:[self configureGlobalSettings]];
    
    [self setupTitleBar];
    
    [self setupSettings];
    
    [self setupSelectTableView];
}

- (void)setupTitleBar {
    CGFloat ySpace = 24;
    if (QN_iPhoneX || QN_iPhoneXR || QN_iPhoneXSMAX) {
        ySpace = 44;
    }
    
    self.viewBar = [[UIView alloc] init];
    self.viewBar.backgroundColor = QN_MAIN_COLOR;
    [self.view addSubview:_viewBar];
    [self.viewBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(ySpace);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *backButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [backButton setTintColor:UIColor.whiteColor];
    [backButton setImage:[UIImage imageNamed:@"qn_icon_back"] forState:(UIControlStateNormal)];
    [backButton addTarget:self action:@selector(getBack) forControlEvents:(UIControlEventTouchUpInside)];
    [self.viewBar addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(CGSizeMake(44, 44));
        make.left.bottom.equalTo(self.viewBar);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"参数配置";
    self.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [self.titleLabel sizeToFit];
    [self.viewBar addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.viewBar);
        make.centerY.equalTo(backButton);
    }];
}

- (void)setupSettings {
    NSArray *settings = @[@"预览尺寸", @"音频声道", @"编码尺寸", @"编码码率"];
    for (NSInteger i = 0; i < settings.count; i++) {
        UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(QN_SET_X_SPACE, 96 + 80 * i, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2, 40)];
        infoLabel.text = settings[i];
        infoLabel.textColor = [UIColor blackColor];
        infoLabel.font = [UIFont systemFontOfSize:15 weight:1.2];
        [self.view addSubview:infoLabel];
        
        UIButton *selectButton = [[UIButton alloc] initWithFrame:CGRectMake(QN_SET_X_SPACE, 96 + 40 * i + 40 * (i + 1) , QN_SCREEN_WIDTH - QN_SET_X_SPACE*2, 30)];
        selectButton.tag = 1000 + i;
        [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [selectButton setTitle:self.defaultArrays[i] forState:UIControlStateNormal];
        selectButton.titleLabel.font = [UIFont systemFontOfSize:15];
        selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        selectButton.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
        [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchDown];
        [self.view addSubview:selectButton];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qn_sel_down"]];
        imageView.frame = CGRectMake(QN_SCREEN_WIDTH - QN_SET_X_SPACE - 40, 96 + 35 * i + 40 * (i + 1) + 6, 28, 28);
        [self.view addSubview:imageView];
    }
}

- (void)setupSelectTableView {
    self.selectTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, QN_SCREEN_WIDTH - QN_SET_X_SPACE * 2 - 40, 0) style:UITableViewStylePlain];
    self.selectTableView.delegate = self;
    self.selectTableView.dataSource = self;
    self.selectTableView.rowHeight = QN_ROW_HEIGHT;
    self.selectTableView.layer.cornerRadius = 4;
    self.selectTableView.clipsToBounds = YES;
    self.selectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.selectTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];

       
    self.selectLayer = [CALayer layer];
    self.selectLayer.frame = CGRectMake(0, 0, QN_SCREEN_WIDTH - QN_SET_X_SPACE * 2 - 40, 0);
    self.selectLayer.backgroundColor = QN_RGBCOLOR(247, 248, 250).CGColor;
    self.selectLayer.shadowColor = QN_RGBCOLOR(195, 198, 198).CGColor;
    self.selectLayer.shadowOffset = CGSizeMake(1, 1);
    self.selectLayer.shadowOpacity = 1;
    self.selectLayer.shadowRadius = 4;
    self.selectLayer.cornerRadius = 4;
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.selectArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *value = self.selectArray[indexPath.row];
    [self.selectButton setTitle:value forState:UIControlStateNormal];
    NSInteger index = self.selectButton.tag - 1000;
    NSString *key = self.infoNames[index];
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [self hideSelectView];
}

#pragma mark - button action

- (void)selectAction:(UIButton *)button {
    if ([self.view.subviews containsObject:self.selectTableView]) {
        [self hideSelectView];
    }
    self.selectButton = button;
    
    NSInteger index = button.tag - 1000;
    
    switch (index) {
        case 0:{
            self.selectArray = [NSMutableArray arrayWithArray:@[@"640x480", @"960x540", @"1280x720", @"1920x1080"]];
        }
            break;
        case 1:{
            self.selectArray = [NSMutableArray arrayWithArray:@[@"单声道", @"双声道"]];
        }
            break;
        case 2:{
            self.selectArray = [NSMutableArray arrayWithArray:@[@"480x480", @"480x640", @"540x540", @"540x960", @"960x540", @"720x720", @"960x720", @"720x960", @"1280x720", @"720x1280", @"1280x1280", @"1920x1080", @"1080x1920"]];
        }
            break;
        case 3:{
            self.selectArray = [NSMutableArray arrayWithArray:@[@"800kbps", @"1000kbps", @"1200kbps", @"1600kbps", @"2000kbps", @"2500kbps", @"4000kbps", @"8000kbps"]];
        }
            break;
            
        default:
            break;
    }
    
    [self showSelectView];
}

- (void)getBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - hide/show select view

- (void)hideSelectView {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(QN_SET_X_SPACE, self.selectButton.frame.origin.y, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2 - 40, 0);
        self.selectLayer.frame = frame;
        self.selectTableView.frame = frame;
        [self.selectLayer removeFromSuperlayer];
        [self.selectTableView removeFromSuperview];
    }];
}

- (void)showSelectView {
    self.selectTableView.frame = CGRectMake(QN_SET_X_SPACE, self.selectButton.frame.origin.y, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2 - 40, 0);
    self.selectLayer.frame = CGRectMake(QN_SET_X_SPACE, self.selectButton.frame.origin.y, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2 - 40, 0);
    
    CGFloat height = self.selectButton.frame.origin.y + self.selectArray.count * QN_ROW_HEIGHT;
    if (height > QN_SCREEN_HEIGHT) {
        self.selectTableView.frame = CGRectMake(QN_SET_X_SPACE, QN_SCREEN_HEIGHT - self.selectArray.count * QN_ROW_HEIGHT - 10, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2 - 40, 0);
        self.selectLayer.frame = CGRectMake(QN_SET_X_SPACE, QN_SCREEN_HEIGHT - self.selectArray.count * QN_ROW_HEIGHT - 10, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2 - 40, 0);
    }

    [self.selectTableView reloadData];
    
    self.selectTableView.hidden = NO;
    [self.view.layer addSublayer:_selectLayer];
    [self.view bringSubviewToFront:_selectTableView];
    
    [self.view addSubview:_selectTableView];

    [UIView animateWithDuration:0.3 animations:^{
        self.selectLayer.frame = CGRectMake(QN_SET_X_SPACE, self.selectTableView.frame.origin.y, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2, self.selectArray.count * QN_ROW_HEIGHT);
        self.selectTableView.frame = CGRectMake(QN_SET_X_SPACE, self.selectTableView.frame.origin.y, QN_SCREEN_WIDTH - QN_SET_X_SPACE*2, self.selectArray.count * QN_ROW_HEIGHT);;
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([self.view.subviews containsObject:self.selectTableView]) {
        [self hideSelectView];
    }
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
