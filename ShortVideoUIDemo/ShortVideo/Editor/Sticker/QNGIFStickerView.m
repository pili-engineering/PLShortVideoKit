//
//  QNGIFStickerView.m
//  PLVideoEditor
//
//  Created by suntongmian on 2018/5/24.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "QNGIFStickerView.h"


@interface QNGIFStickerView ()

@property (nonatomic, strong, readwrite) QNStickerModel *stickerModel;
@property (nonatomic, strong) NSMutableArray *allImage;
@end

@implementation QNGIFStickerView

- (instancetype)initWithStickerModel:(QNStickerModel *)stickerModel {
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;
        self.stickerModel = stickerModel;
        _oriScale = 1.0;
        [self setupUI];
        if (stickerModel.path) {
            [self setupGIF];
        }
    }
    return self;
}

- (void)setupUI{
    
    // 这里不使用自动布局，使用自动布局，在 iOS 10 以及以下手机上，scale 之后再移动贴纸会出现按钮位置不对的问题
    
    _dragBtn = [[QNPanImageView alloc] initWithImage:[UIImage imageNamed:@"qn_sticker_rotate"]];
    _dragBtn.userInteractionEnabled = YES;
    [self addSubview:_dragBtn];
    
    _closeBtn = [[UIButton alloc] init];
    [_closeBtn setImage:[UIImage imageNamed:@"qn_sticker_delete"] forState:UIControlStateNormal];
    [_closeBtn addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_closeBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _closeBtn.frame = CGRectMake(self.bounds.size.width - 22, -22, 44, 44);
    _dragBtn.frame = CGRectMake(self.bounds.size.width - 10, self.bounds.size.height - 10, 20, 20);

    NSLog(@"f = %@, b = %@,c = %@, d = %@", NSStringFromCGRect(self.frame), NSStringFromCGRect(self.bounds), NSStringFromCGRect(_closeBtn.frame), NSStringFromCGRect(_dragBtn.frame));
}

- (void)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(stickerViewClose:)]) {
        [self.delegate stickerViewClose:self];
    }
    [self removeFromSuperview];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.alpha > 0.1 && !self.clipsToBounds) {
        for (UIView *subView in @[self.dragBtn, self.closeBtn]) {
            CGPoint subPoint = [self convertPoint:point toView:subView];
            UIView *resultView = [subView hitTest:subPoint withEvent:event];
            if (resultView) {
                return resultView;
            }
        }
    }
    
    return [super hitTest:point withEvent:event];
}

- (void)setSelect:(BOOL)select{
    _select = select;
    if (select) {
        self.layer.borderWidth = .5;
        self.layer.borderColor = [[UIColor colorWithWhite:1 alpha:.5] CGColor];
        self.closeBtn.hidden = NO;
        self.dragBtn.hidden = NO;
    }else{
        self.layer.borderWidth = 0;
        self.closeBtn.hidden = YES;
        self.dragBtn.hidden = YES;
    }
}

- (CGAffineTransform)currentTransform {
    return self.transform;
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    if (hidden) {
        [self stopAnimating];
    } else {
        [self startAnimating];
    }
}

- (void)setupGIF {
    NSURL *url = [NSURL fileURLWithPath:self.stickerModel.path];
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, nil);
    CGFloat totalDuration = 0;
    size_t imageCount = CGImageSourceGetCount(imageSource);
    
    NSMutableArray *allImage = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageCount; i ++) {
        
        CFDictionaryRef cfDic = CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
        NSDictionary *properties = (__bridge NSDictionary *)cfDic;
        float frameDuration = [[[properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary]
                                objectForKey:(__bridge NSString *) kCGImagePropertyGIFUnclampedDelayTime] doubleValue];
        if (frameDuration < (1e-6)) {
            frameDuration = [[[properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary]
                              objectForKey:(__bridge NSString *) kCGImagePropertyGIFDelayTime] doubleValue];
        }
        if (frameDuration < (1e-6)) {
            frameDuration = 0.1;//如果获取不到，就默认 frameDuration = 0.1s
        }
        
        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
        UIImage *image = [UIImage imageWithCGImage:cgImage scale:UIScreen.mainScreen.scale orientation:(UIImageOrientationUp)];
        [allImage addObject:image];
        
        CFRelease(cgImage);
        CFRelease(cfDic);
        totalDuration += frameDuration;
    }
    
    self.animationImages = allImage;
    self.animationDuration = totalDuration;
    
    [self startAnimating];
    CFRelease(imageSource);
}


@end

