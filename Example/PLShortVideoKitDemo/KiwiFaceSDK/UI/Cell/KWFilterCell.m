//
//  KWFilterCell.m
//  KWMediaStreamingKitDemo
//
//  Created by 伍科 on 16/12/7.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import "KWFilterCell.h"

@interface KWFilterCell()

@property (nonatomic, strong) UIImageView *backView;

@property(nonatomic ,strong)UIImageView *imageView;

@property(nonatomic ,strong)UILabel *label;

@end

@implementation KWFilterCell

-(UIImageView *)backView
{
    if (!_backView) {
        
        _backView=[[UIImageView alloc]initWithFrame:self.bounds];
        [_backView setImage:nil];
    }
    return _backView;
    
}

-(UIImageView *)imageView
{
    if (!_imageView) {
        _imageView=[[UIImageView alloc]init];
        
        [self.contentView addSubview:_imageView];
    }
    return _imageView  ;
    
}

-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]init];
        
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont fontWithName:@"Helvetica" size:8.f];
        _label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_label];
    }
    return _label;
    
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundView = self.backView;
        self.imageView.frame = CGRectMake(1 , 1, CGRectGetWidth(self.frame) - 2, CGRectGetWidth(self.frame) - 2);
         CGFloat margin = self.imageView.frame.size.height;
        self.label.frame = CGRectMake(0, margin + 5, margin,12);

    }
    return self;
}

- (void)setName:(NSString *)name andIcon:(UIImage *)image index:(NSInteger)index
{
    if (index == 0) {
        
        self.imageView.image = [UIImage imageNamed:@"cancel"];
        self.label.text = @"Origin";
        
    }else{
        
        self.label.text = name;
        self.imageView.image = image;
    }
    
}

-(void)hideBackView:(BOOL)hidden
{
    if (hidden) {
        
        self.backView.image = nil;
    }else{
        self.backView.image = [UIImage imageNamed:@"yellowBorderBackground"];
    }
}

@end
