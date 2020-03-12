//
//  PLSStickerOverlayView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/8/19.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSStickerOverlayView.h"

@interface PLSStickerOverlayView()
<
PLSStickerViewDelegate
>

@property (nonatomic, strong, readwrite) UIView *layoutView;
@property (nonatomic, strong) NSMutableArray *stickers;

@property (nonatomic, assign) CGPoint loc_in;
@property (nonatomic, assign) CGPoint ori_center;

@end

@implementation PLSStickerOverlayView

- (instancetype)initWithFrame:(CGRect)frame layoutView:(UIView *)layoutView {
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutView = layoutView;
        [self.layoutView addSubview:self];
        
        self.stickers = [NSMutableArray array];
        self.positionMode = PositionMode_All_Center;
    }
    return self;
}

- (void)setPositionMode:(PositionMode)positionMode {
    if (positionMode == self.positionMode) {
        return;
    }
    _positionMode = positionMode;
    
    [self adjustPositionWithPositionMode:positionMode];
}

- (NSArray *)stickersArray {
    return [NSArray arrayWithArray:_stickers];
}

#pragma mark - PLSStickerViewDelegate

- (void)stickerView:(PLSStickerView *)stickerView startTextEdit:(UITapGestureRecognizer *)tapGestureRecognizer {
    self.currentSticker = stickerView;
    self.currentSticker.isSelected = YES;
    [self.currentSticker becomeFirstResponder];
}

#pragma mark - public

- (void)addSticker:(PLSStickerView *)sticker positionMode:(PositionMode)positionMode{
    if ([self.stickers containsObject:sticker]) {
        return;
    } else{
        self.currentSticker.isSelected = NO;
        
        sticker.delegate = self;
        [self adjustPositionWithPositionMode:positionMode];
        [self addSubview:sticker];
        [self.stickers addObject:sticker];
        sticker.isSelected = YES;
        self.currentSticker = sticker;
    }
    
}

- (void)cancelCurrentSticker {
    PLSStickerView *baseSticker = _currentSticker;
    [self.stickers removeObject:baseSticker];
    [self.currentSticker removeFromSuperview];
    _currentSticker = self.stickers.lastObject;
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerOverlayView:didRemovedSticker:currentSticker:)]) {
        [self.delegate stickerOverlayView:self didRemovedSticker:baseSticker currentSticker:_currentSticker];
    }
}

- (void)clearAllStickers {
    self.stickers = [NSMutableArray array];
    self.currentSticker = [[PLSStickerView alloc] init];
}

#pragma mark - private

- (void)adjustPositionWithPositionMode:(PositionMode)positionMode {
    CGFloat totalWidth = CGRectGetWidth(self.frame);
    CGFloat totalHeight = CGRectGetHeight(self.frame);
    
    CGFloat width = CGRectGetWidth(self.currentSticker.frame);
    CGFloat height = CGRectGetHeight(self.currentSticker.frame);
    
    switch (positionMode) {
        case PositionMode_All_Center:
            self.currentSticker.frame = CGRectMake(totalWidth/2 - width/2, totalHeight/2 - height/2, width, height);
            break;
        case PositionMode_Ver_Center:
            self.currentSticker.frame = CGRectMake(self.currentSticker.frame.origin.x, totalHeight/2 - height/2, width, height);
            break;
        case PositionMode_Hor_Center:
            self.currentSticker.frame = CGRectMake(totalWidth/2 - width/2, self.currentSticker.frame.origin.y, width, height);
            break;
        case PositionMode_Top:
            self.currentSticker.frame = CGRectMake(self.currentSticker.frame.origin.x, 0, width, height);
            break;
        case PositionMode_Bottom:
            self.currentSticker.frame = CGRectMake(self.currentSticker.frame.origin.x, totalHeight - height, width, height);
            break;
        case PositionMode_Left:
            self.currentSticker.frame = CGRectMake(0, self.currentSticker.frame.origin.y, width, height);
            break;
        case PositionMode_Right:
            self.currentSticker.frame = CGRectMake(totalWidth - width, self.currentSticker.frame.origin.y, width, height);
            break;
            
        default:
            break;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    __block UIView *responseView = nil;
    [self.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint subPoint = [subView convertPoint:point fromView:self];
        UIView *resultView = [subView hitTest:subPoint withEvent:event];
        if (resultView) {
            responseView = resultView;
            *stop = YES;
        }
    }];
    return responseView ? responseView : nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
