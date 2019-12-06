//
//  QNTextStickerView.m
//  ShortVideo
//
//  Created by hxiongan on 2019/5/16.
//  Copyright © 2019年 ahx. All rights reserved.
//

#import "QNTextStickerView.h"

@interface QNTextStickerView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation QNTextStickerView

- (instancetype)initWithStickerModel:(QNStickerModel *)stickerModel {
    
    self = [super initWithStickerModel:stickerModel];
    if (self) {
        
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = stickerModel.font;
        _label.textColor = stickerModel.textColor;
        _label.adjustsFontSizeToFitWidth = YES;
        _label.text = @"点击输入文字";
        _label.numberOfLines = 0;
        [self addSubview:_label];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.label.frame = self.bounds;
}

- (void)setText:(NSString *)text {
    if (text.length > 0) {
        _label.text = text;
    } else {
        _label.text = @"点击输入文字";
    }
}

- (void)setFont:(UIFont *)font {
    _font = font;
    _label.font = font;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    _label.textColor = color;
}

- (NSString *)text {
    return _label.text;
}
@end
