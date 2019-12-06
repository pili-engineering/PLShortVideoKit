//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/03.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"

@interface QBAssetCell ()

@property (nonatomic, weak) IBOutlet UIView *overlayView;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation QBAssetCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    // Show/hide overlay view
    self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
    [self bringSubviewToFront:self.infoLabel];
}

- (void)setInfoString:(NSString *)infoString {
    _infoString = infoString;
    if ([self.infoLabel.text isEqualToString:infoString]) return;
    self.infoLabel.text = infoString;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.infoLabel) {
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [self.layer addSublayer:gradientLayer];
        gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 50);
        gradientLayer.colors = @[
                                 (__bridge id)[[UIColor blackColor] CGColor],
                                 (__bridge id)[[UIColor clearColor] CGColor]
                                 ];
        
        self.infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
        self.infoLabel.font = [UIFont systemFontOfSize:12];
        self.infoLabel.textColor = [UIColor whiteColor];
        self.infoLabel.text = self.infoString;
        self.infoLabel.textAlignment = NSTextAlignmentNatural;
        self.infoLabel.numberOfLines = 3;
        self.infoLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.infoLabel];
    }
}

@end
