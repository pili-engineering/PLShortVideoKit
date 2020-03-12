//
//  PLSColumnListView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2017/11/27.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSColumnListView.h"
#import <AVFoundation/AVFoundation.h>
@interface PLSColumnListView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) NSArray *listArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, assign) PLSListViewType listType;
@property (nonatomic, assign) BOOL isSection;

@end

@implementation PLSColumnListView
- (id)initWithFrame:(CGRect)frame listArray:(NSArray *)listArray titleArray:(NSArray *)titleArray listType:(PLSListViewType)listType {
    if (titleArray) {
        self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    } else {
        self = [super initWithFrame:frame style:UITableViewStylePlain];
    }
    self.listArray = listArray;
    self.titleArray = titleArray;
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 48;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self registerClass:[PLSTableListCell class] forCellReuseIdentifier:NSStringFromClass([PLSTableListCell class])];
    }
    
    return self;
}

- (void)setTableHeaderView:(UIView *)tableHeaderView {
    if (_listType == PLSTableHeaderType || _listType  == PLSHeaderFooterType) {
        self.tableHeaderView = tableHeaderView;
    }
}

- (void)setTableFooterView:(UIView *)tableFooterView {
    if (_listType == PLSTableFooterType || _listType  == PLSHeaderFooterType) {
        self.tableHeaderView = tableFooterView;
    }
}

- (void)updateListViewWithListArray:(NSArray *)listArray titleArray:(NSArray *)titleArray {
    _listArray = listArray;
    _titleArray = titleArray;
    [self reloadData];
}

# pragma mark ---- tableView  delegate ----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_titleArray) {
        return _listArray.count;
    } else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_titleArray) {
        NSArray *rowListArray = _listArray[section];
        return rowListArray.count;
    } else{
        return _listArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PLSTableListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PLSTableListCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dic;
    if (_titleArray) {
        NSArray *rowListArray = _listArray[indexPath.section];
        dic = rowListArray[indexPath.row];
    } else{
        dic = self.listArray[indexPath.row];
    }
    // 流媒体文件
    NSURL *url = [dic objectForKey:@"url"];
    NSString *name = [dic objectForKey:@"name"];
    UIImage *coverImage = [self coverImageWithURL:url];
    [cell configLabelName:name image:coverImage width:self.frame.size.width];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 42)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width - 16, 26)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:titleLabel];
    titleLabel.text = _titleArray[section];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 42)];
    footerView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 8, self.frame.size.width - 16, 26)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [UIColor whiteColor];
    [footerView addSubview:titleLabel];
    titleLabel.text = _titleArray[section];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listDelegate && [self.listDelegate respondsToSelector:@selector(columnListView:didClickListIndex:)]) {
        [self.listDelegate columnListView:self didClickListIndex:indexPath.row];
    }
}

#pragma mark -- 获取音乐文件的封面
- (UIImage *)coverImageWithURL:(NSURL *)url {
    NSData *data = nil;
    // 初始化媒体文件
    AVURLAsset *mp3Asset = [AVURLAsset URLAssetWithURL:url options:nil];
    // 读取文件中的数据
    for (NSString *format in [mp3Asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [mp3Asset metadataForFormat:format]) {
            //artwork这个key对应的value里面存的就是封面缩略图，其它key可以取出其它摘要信息，例如title - 标题
            if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
                data = (NSData *)metadataItem.value;
                break;
            }
        }
    }
    if (!data) {
        // 如果流媒体没有封面图片，就返回默认图片
        return [UIImage imageNamed:@"mv"];
    }
    return [UIImage imageWithData:data];
}

- (void)dealloc {
    NSLog(@"dealloc: %@", [[self class] description]);
}

@end


@implementation PLSTableListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _iconPromptLabel = [[UILabel alloc] initWithFrame:CGRectMake(48, 8, 45, 32)];
        _iconPromptLabel.textAlignment = NSTextAlignmentLeft;
        _iconPromptLabel.font = [UIFont systemFontOfSize:13];
        _iconPromptLabel.textColor = [UIColor whiteColor];
        _iconPromptLabel.lineBreakMode = NSLineBreakByTruncatingHead; //前面部分文字以……方式省略，显示尾部文字内容。
        [self.contentView addSubview:_iconPromptLabel];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 32, 32)];
        _iconImageView.layer.cornerRadius = _iconImageView.frame.size.width / 2;
        _iconImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        _lineView = [[UIView alloc]initWithFrame:CGRectMake(8, 47.5, 45, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithRed:195/255 green:198/255 blue:198/255 alpha:1];
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)configLabelName:(NSString *)labelName image:(UIImage *)image width:(CGFloat)width{
    _iconPromptLabel.text = labelName;
    _iconImageView.image = image;
    _lineView.frame = CGRectMake(8, 47.5, width - 16, 0.5);
    CGRect bounds = [labelName boundingRectWithSize:CGSizeMake(width - 56, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil];
    if (bounds.size.height < 32) {
        _iconPromptLabel.frame = CGRectMake(48, (48 - bounds.size.height)/2, width - 56, bounds.size.height);
    }
}
@end
