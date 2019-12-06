//
//  QNScopeCutView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/4/16.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNScopeCutView.h"

@implementation QNScopeCutView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *color = [UIColor whiteColor];
        UIView *rowView1 = [[UIView alloc] init];
        rowView1.backgroundColor = color;
        [self addSubview:rowView1];
        
        UIView *rowView2 = [[UIView alloc] init];
        rowView2.backgroundColor = color;
        [self addSubview:rowView2];
        
        UIView *rowView3 = [[UIView alloc] init];
        rowView3.backgroundColor = color;
        [self addSubview:rowView3];
        
        UIView *rowView4 = [[UIView alloc] init];
        rowView4.backgroundColor = color;
        [self addSubview:rowView4];
        
        UIView *colView1 = [[UIView alloc] init];
        colView1.backgroundColor = color;
        [self addSubview:colView1];
        
        UIView *colView2 = [[UIView alloc] init];
        colView2.backgroundColor = color;
        [self addSubview:colView2];
        
        UIView *colView3 = [[UIView alloc] init];
        colView3.backgroundColor = color;
        [self addSubview:colView3];
        
        UIView *colView4 = [[UIView alloc] init];
        colView4.backgroundColor = color;
        [self addSubview:colView4];
        
        NSArray *rowArray = @[rowView1, rowView2, rowView3, rowView4];
        [rowArray mas_distributeViewsAlongAxis:(MASAxisTypeVertical) withFixedItemLength:0.5 leadSpacing:0 tailSpacing:0];
        [rowArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
        }];
        
        NSArray *colArray = @[colView1, colView2, colView3, colView4];
        [colArray mas_distributeViewsAlongAxis:(MASAxisTypeHorizontal) withFixedItemLength:0.5 leadSpacing:0 tailSpacing:0];
        [colArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
        }];
        
        
        UIView *leftTopRowView = [[UIView alloc] init];
        leftTopRowView.backgroundColor = color;
        [self addSubview:leftTopRowView];
        [leftTopRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(rowView1.mas_top);
            make.left.equalTo(rowView1.mas_left).offset(-1);
            make.width.equalTo(50);
            make.height.equalTo(1.5);
        }];
        
        UIView *rightTopRowView = [[UIView alloc] init];
        rightTopRowView.backgroundColor = color;
        [self addSubview:rightTopRowView];
        [rightTopRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(rowView1.mas_top);
            make.right.equalTo(rowView1.mas_right).offset(1);
            make.width.equalTo(50);
            make.height.equalTo(1.5);
        }];
        
        UIView *leftBottomRowView = [[UIView alloc] init];
        leftBottomRowView.backgroundColor = color;
        [self addSubview:leftBottomRowView];
        [leftBottomRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rowView4.mas_bottom);
            make.left.equalTo(rowView4.mas_left).offset(-1);
            make.width.equalTo(50);
            make.height.equalTo(1.5);
        }];
        
        UIView *rightBottomRowView = [[UIView alloc] init];
        rightBottomRowView.backgroundColor = color;
        [self addSubview:rightBottomRowView];
        [rightBottomRowView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rowView4.mas_bottom);
            make.right.equalTo(rowView4.mas_right).offset(1);
            make.width.equalTo(50);
            make.height.equalTo(1.5);
        }];
        
        UIView *leftTopColView = [[UIView alloc] init];
        leftTopColView.backgroundColor = color;
        [self addSubview:leftTopColView];
        [leftTopColView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(colView1.mas_top).offset(-1);
            make.right.equalTo(colView1.mas_left);
            make.width.equalTo(1.5);
            make.height.equalTo(50);
        }];
        
        UIView *rightTopColView = [[UIView alloc] init];
        rightTopColView.backgroundColor = color;
        [self addSubview:rightTopColView];
        [rightTopColView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(colView4.mas_top).offset(-1);
            make.left.equalTo(colView4.mas_right);
            make.width.equalTo(1.5);
            make.height.equalTo(50);
        }];
        
        UIView *leftBottomColView = [[UIView alloc] init];
        leftBottomColView.backgroundColor = color;
        [self addSubview:leftBottomColView];
        [leftBottomColView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(colView1.mas_bottom).offset(1);
            make.right.equalTo(colView1.mas_left);
            make.width.equalTo(1.5);
            make.height.equalTo(50);
        }];
        
        UIView *rightBottomColView = [[UIView alloc] init];
        rightBottomColView.backgroundColor = color;
        [self addSubview:rightBottomColView];
        [rightBottomColView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(colView4.mas_bottom).offset(1);
            make.left.equalTo(colView4.mas_right);
            make.width.equalTo(1.5);
            make.height.equalTo(50);
        }];
    }
    return self;
}

@end
