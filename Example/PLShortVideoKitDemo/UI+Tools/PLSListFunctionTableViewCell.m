//
//  PLSListFunctionTableViewCell.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/9/17.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSListFunctionTableViewCell.h"

@implementation PLSListFunctionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = PLS_RGBCOLOR(242, 242, 242);
        self.contentView.backgroundColor = [UIColor whiteColor];
        CGFloat width = CGRectGetWidth([UIScreen mainScreen].bounds);
        
        self.titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, 120, 57.5)];
        self.titlelabel.textAlignment = NSTextAlignmentLeft;
        self.titlelabel.textColor = [UIColor blackColor];
        self.titlelabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titlelabel];
        
        self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width - 34, 17, 24, 24)];
        self.nextImageView.image = [UIImage imageNamed:@"next"];
        self.nextImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_nextImageView];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 57.5, width, 0.5)];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:lineView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
