//
//  FilterItemView.m
//  TuSDKVideoDemo
//
//  Created by wen on 2017/4/11.
//  Copyright © 2017年 TuSDK. All rights reserved.
//

#import "FilterItemView.h"

@interface FilterItemView (){
    // 滤镜名
    NSString *_viewName;
    
    // 图片按钮
    UIButton *_imageBtn;
    // 滤镜名label
    UILabel *_titleLabel;

}

@end


@implementation FilterItemView


- (void)setViewInfoWith:(NSString *)imageName title:(NSString *)title  titleFontSize:(CGFloat)fontSize{
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat ivWidth = viewHeight * 2/3;
    
    // 图片
    _imageBtn = [UIButton new];
    [_imageBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [_imageBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    _imageBtn.layer.cornerRadius = ivWidth/2;
    _imageBtn.clipsToBounds = true;
    [self addSubview:_imageBtn];
    
    // title
    _titleLabel = [UILabel new];
    _titleLabel.text = title;
    _titleLabel.font = [UIFont systemFontOfSize:fontSize];
    _titleLabel.textColor = [UIColor colorWithRed:159/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    _titleLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:_titleLabel];
    
    // 布局
    _imageBtn.frame = CGRectMake(0, 0, ivWidth, ivWidth);
    _titleLabel.frame = CGRectMake(0, viewHeight - viewHeight/3 + 5, ivWidth, viewHeight/3 - 10);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
}


- (void)clickBtn:(UIButton*)sender{
    if ([self.clickDelegate respondsToSelector:@selector(clickBasicViewWith:withBasicTag:)]) {
        [self.clickDelegate clickBasicViewWith:self.viewDescription withBasicTag:self.tag];
    }
    
}

// 传nil为使用默认
- (void)refreshClickColor:(UIColor*)color{
    if (color) {
        if (_imageBtn) {
            _imageBtn.layer.borderWidth = 2;
            _imageBtn.layer.borderColor =  color.CGColor;
            _titleLabel.textColor = color;
        }
    }else{
        if (_imageBtn) {
            _imageBtn.layer.borderWidth = 0;
            _imageBtn.layer.borderColor = [UIColor clearColor].CGColor;
            _titleLabel.textColor = [UIColor colorWithRed:159/255.0 green:160/255.0 blue:160/255.0 alpha:1];
        }
    }
}

@end
