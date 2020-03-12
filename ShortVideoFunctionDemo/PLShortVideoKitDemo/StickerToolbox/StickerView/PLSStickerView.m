//
//  PLSStickerView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/8/16.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSStickerView.h"
#import "PLSStickerOverlayView.h"

@class PLSStickerOverlay;

@interface PLSStickerView()
<
UITextViewDelegate
>

@property (nonatomic, assign) CGFloat stickerWidth;
@property (nonatomic, assign) CGFloat stickerHeight;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *scaleButton;

@property (nonatomic, assign) CGPoint loc_in;
@property (nonatomic, assign) CGPoint ori_center;

@property (nonatomic, assign) CGAffineTransform currentTransform;
@property (nonatomic, assign) CGFloat currentScale;

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;

// StickerType_Image/StickerType_Gif
@property (nonatomic, strong, readwrite) UIImage *stickerImage;
@property (nonatomic, strong) UIImageView *imageView;

// StickerType_Text
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation PLSStickerView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame stickerType:(StickerType)type stickerURL:(NSURL *)stickerURL {
    self = [super initWithFrame:frame];
    if (self) {
        self.stickerURL = stickerURL;
        
        self.stickerType = type;
        self.layoutSpace = 4;
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.layoutSpace, self.layoutSpace, width - self.layoutSpace * 2, height - self.layoutSpace * 2)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.userInteractionEnabled = YES;
        
        if (type == StickerType_Image) {
            self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:stickerURL]];
        } else {
            [self setGifSource];
        }
        self.stickerImage = self.imageView.image;
        
        [self insertSubview:self.imageView atIndex:0];
    }
    return [self initWithFrame:frame stickerType:type];
}

- (instancetype)initWithFrame:(CGRect)frame content:(NSString *)content font:(UIFont *)font color:(UIColor *)color {
    self = [super initWithFrame:frame];
    if (self) {
        self.stickerType = StickerType_Text;
        
        self.textFont = font;
        self.textColor = color;
        self.textAlignment = TextAlignment_Center;
        self.textContent = content;
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.font = self.textFont;
        self.textLabel.textColor = self.textColor;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.text = self.textContent;
        self.textLabel.userInteractionEnabled = YES;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        [self insertSubview:self.textLabel atIndex:0];
        
        self.textView = [[UITextView alloc] initWithFrame:CGRectZero];
        self.textView.delegate = self;
        self.textView.returnKeyType = UIReturnKeyContinue;
        self.textView.font = self.textFont;
        self.textView.textColor = self.textColor;
        self.textView.textAlignment = NSTextAlignmentCenter;
        self.textView.text = self.textContent;
        [self addSubview:_textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
        
        UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTextEditing:)];
        doubleTapGes.numberOfTapsRequired = 2;
        [self.textLabel addGestureRecognizer:doubleTapGes];
    }
    return [self initWithFrame:frame stickerType:StickerType_Text];
}

- (instancetype)initWithFrame:(CGRect)frame stickerType:(StickerType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.stickerWidth = CGRectGetWidth(frame);
        self.stickerHeight = CGRectGetHeight(frame);
        
        self.stickerType = type;
        self.layerWidth = 0.8;
        self.layerCornerRadius = 3;
        self.layerColor = [UIColor colorWithRed:100 green:149 blue:237 alpha:1];
        self.isSelected = YES;
        self.layerImage = [[UIImage alloc] init];
        
        self.closePosition = IconPosition_Right_Top;
        self.scalePosition = IconPosition_Right_Bottom;
        
        self.layer.borderWidth = self.layerWidth;
        self.layer.cornerRadius = self.layerCornerRadius;
        self.layer.borderColor = self.layerColor.CGColor;
        
        self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.stickerWidth - 12, -12, 24, 24)];
        [self.closeButton setImage:[UIImage imageNamed:@"sticker_delete"] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeButton];
        
        self.scaleButton = [[UIButton alloc] initWithFrame:CGRectMake(self.stickerWidth - 12, self.stickerHeight - 12, 24, 24)];
        [self.scaleButton setImage:[UIImage imageNamed:@"sticker_rotate"] forState:UIControlStateNormal];
        [self.scaleButton addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scaleAndRotateGestureRecognizerEvent:)]];
        [self addSubview:_scaleButton];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerEvent:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveGestureRecognizerEvent:)];
        [self addGestureRecognizer:panGestureRecognizer];
        
        UIPinchGestureRecognizer *pinGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureRecognizerEvent:)];
        [self addGestureRecognizer:pinGestureRecognizer];
        
    }
    return self;
}

#pragma mark - common set

- (void)setStickerType:(StickerType)stickerType {
    if (stickerType == self.stickerType) {
        return;
    }
    _stickerType = stickerType;
}

- (void)setLayerWidth:(CGFloat)layerWidth {
    if (layerWidth == self.layerWidth) {
        return;
    }
    _layerWidth = layerWidth;
    self.layer.borderWidth = layerWidth;
}

- (void)setLayerColor:(UIColor *)layerColor {
    if (layerColor == self.layerColor) {
        return;
    }
    _layerColor = layerColor;
    self.layer.borderColor = layerColor.CGColor;
}

- (void)setLayerCornerRadius:(CGFloat)layerCornerRadius {
    if (layerCornerRadius == self.layerCornerRadius) {
        return;
    }
    _layerCornerRadius = layerCornerRadius;
    self.layer.cornerRadius = layerCornerRadius;
}

- (void)setClosePosition:(IconPosition)closePosition {
    if (closePosition == self.closePosition) {
        return;
    }
    _closePosition = closePosition;
    
    CGSize originSize = self.closeButton.frame.size;
    switch (closePosition) {
        case IconPosition_Left_Top:
            self.closeButton.frame = CGRectMake(- originSize.width/2, - originSize.height/2, originSize.width, originSize.height);
            break;
        case IconPosition_Right_Top:
            self.closeButton.frame = CGRectMake(self.stickerWidth - originSize.width/2, - originSize.height/2, originSize.width, originSize.height);
            break;
        case IconPosition_Left_Bottom:
            self.closeButton.frame = CGRectMake(- originSize.width/2, self.stickerHeight - originSize.height/2, originSize.width, originSize.height);
            break;
        case IconPosition_Right_Bottom:
            self.closeButton.frame = CGRectMake(self.stickerWidth - originSize.width/2, self.stickerHeight - originSize.height/2, originSize.width, originSize.height);
            break;
        default:
            break;
    }
}

- (void)setScalePosition:(IconPosition)scalePosition {
    if (scalePosition == self.scalePosition) {
        return;
    }
    _scalePosition = scalePosition;
    
    CGSize originSize = self.scaleButton.frame.size;
    switch (scalePosition) {
        case IconPosition_Left_Top:
            self.scaleButton.frame = CGRectMake(- originSize.width/2, - originSize.height/2, originSize.width, originSize.height);
            break;
        case IconPosition_Right_Top:
            self.scaleButton.frame = CGRectMake(self.stickerWidth - originSize.width/2, - originSize.height/2, originSize.width, originSize.height);
            break;
        case IconPosition_Left_Bottom:
            self.scaleButton.frame = CGRectMake(- originSize.width/2, self.stickerHeight - originSize.height/2, originSize.width, originSize.height);
            break;
        case IconPosition_Right_Bottom:
            self.scaleButton.frame = CGRectMake(self.stickerWidth - originSize.width/2, self.stickerHeight - originSize.height/2, originSize.width, originSize.height);
            break;
        default:
            break;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    if (isSelected == self.isSelected) {
        return;
    }
    _isSelected = isSelected;
    if (isSelected) {
        self.layer.borderWidth = self.layerWidth;
        self.layer.cornerRadius = self.layerCornerRadius;
        self.layer.borderColor = self.layerColor.CGColor;
        
        self.closeButton.hidden = NO;
        self.scaleButton.hidden = NO;
    } else {
        self.layer.borderWidth = 0;
        
        self.closeButton.hidden = YES;
        self.scaleButton.hidden = YES;
    }
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (self.stickerType == StickerType_Gif) {
        if (hidden) {
            [self stopAnimating];
        } else {
            [self startAnimating];
        }
    }
}

- (void)setLayerImage:(UIImage *)layerImage {
    if (layerImage == self.layerImage) {
        return;
    }
    _layerImage = layerImage;
    self.image = self.layerImage;
    if (self.layerImage == nil) {
        self.layer.borderWidth = self.layerWidth;
        self.layer.cornerRadius = self.layerCornerRadius;
        self.layer.borderColor = self.layerColor.CGColor;
    } else {
        self.layer.borderWidth = 0;
    }
}

#pragma mark - image/gif type set

- (void)setStickerURL:(NSURL *)stickerURL {
    if (stickerURL == nil || stickerURL == self.stickerURL) {
        return;
    }
    _stickerURL = stickerURL;
    
    if (self.stickerType == StickerType_Image) {
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:stickerURL]];
    } else {
        [self setGifSource];
    }
    self.stickerImage = self.imageView.image;
}

- (void)setLayoutSpace:(CGFloat)layoutSpace {
    if (layoutSpace < 0.5 || layoutSpace > 8) {
        NSLog(@"边框范围过大或过小！");
        return;
    }
    if (layoutSpace == self.layoutSpace) {
        return;
    }
    _layoutSpace = layoutSpace;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    self.imageView.frame = CGRectMake(layoutSpace, layoutSpace, width - layoutSpace * 2, height - layoutSpace * 2);
}

#pragma mark - text type set

- (void)setTextFont:(UIFont *)textFont {
    if (textFont == self.textFont) {
        return;
    }
    _textFont = textFont;
    self.textLabel.font = textFont;
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor == self.textColor) {
        return;
    }
    _textColor = textColor;
    self.textLabel.textColor = textColor;
}

- (void)setTextAlignment:(TextAlignment)textAlignment {
    if (textAlignment == self.textAlignment) {
        return;
    }
    _textAlignment = textAlignment;
    
    switch (self.textAlignment) {
        case TextAlignment_Center:
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
        case TextAlignment_Left:
            self.textLabel.textAlignment = NSTextAlignmentLeft;
            break;
        case TextAlignment_Right:
            self.textLabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            self.textLabel.textAlignment = NSTextAlignmentCenter;
            break;
    }
}

- (void)setTextContent:(NSString *)textContent {
    if (textContent == self.textContent) {
        return;
    }
    _textContent = textContent;
    self.textLabel.text = textContent;
}

#pragma mark - load gif image

- (void)setGifSource {
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)_stickerURL, nil);
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
    
    self.imageView.animationImages = allImage;
    self.imageView.animationDuration = totalDuration;
    
    [self.imageView startAnimating];
    CFRelease(imageSource);
}

#pragma mark - gesture recognizer

- (void)tapGestureRecognizerEvent:(UITapGestureRecognizer *)tapGes {
    if ([[tapGes view] isEqual:self]){
        PLSStickerOverlayView *overlay = (PLSStickerOverlayView *)self.superview;
        if (overlay.delegate && [overlay.delegate respondsToSelector:@selector(stickerOverlayView:didTapSticker:tap:)]) {
            [overlay.delegate stickerOverlayView:overlay didTapSticker:self tap:tapGes];
        }
    }
}

- (void)moveGestureRecognizerEvent:(UIPanGestureRecognizer *)panGes  {
    if ([[panGes view] isEqual:self]){
        UIView *bottomSuperView = self.superview.superview;
        CGPoint loc = [panGes locationInView:bottomSuperView];

        if (!self.isSelected) {
            return;
        }
        if (panGes.state == UIGestureRecognizerStateBegan) {
            _loc_in = [panGes locationInView:bottomSuperView];
            _ori_center = self.center;
        }
        
        CGFloat x;
        CGFloat y;
        x = _ori_center.x + (loc.x - _loc_in.x);
        
        y = _ori_center.y + (loc.y - _loc_in.y);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0 animations:^{
                self.center = CGPointMake(x, y);
            }];
        });
    }
}

- (void)pinchGestureRecognizerEvent:(UIPinchGestureRecognizer *)pinGes {
    if ([[pinGes view] isEqual:self]){
        if (pinGes.state ==UIGestureRecognizerStateBegan) {
            self.currentTransform = self.transform;
        }
        if (pinGes.state == UIGestureRecognizerStateChanged) {
            CGAffineTransform transform = CGAffineTransformScale(self.currentTransform, pinGes.scale, pinGes.scale);
            
            self.transform = transform;
        }
        
        // 当手指离开屏幕时,将lastscale设置为1.0
        if ((pinGes.state == UIGestureRecognizerStateEnded) || (pinGes.state == UIGestureRecognizerStateCancelled)) {
            self.currentScale = self.currentScale * pinGes.scale;
            pinGes.scale = 1;
        }
    }
}

- (void)scaleAndRotateGestureRecognizerEvent:(UIPanGestureRecognizer *)gesture {
    if (self.isSelected) {
        UIView *bottomSuperView = self.superview.superview;
        CGPoint curPoint = [gesture locationInView:bottomSuperView];
        if (gesture.state == UIGestureRecognizerStateBegan) {
            _loc_in = [gesture locationInView:bottomSuperView];
        }
        if (gesture.state == UIGestureRecognizerStateBegan) {
            self.currentTransform = self.transform;
        }
        
        // 计算缩放
        CGFloat preDistance = [self getDistance:_loc_in withPointB:self.center];
        CGFloat curDistance = [self getDistance:curPoint withPointB:self.center];
        CGFloat scale = curDistance / preDistance;
        // 计算弧度
        CGFloat preRadius = [self getRadius:self.center withPointB:_loc_in];
        CGFloat curRadius = [self getRadius:self.center withPointB:curPoint];
        CGFloat radius = curRadius - preRadius;
        radius = - radius;
        CGAffineTransform transform = CGAffineTransformScale(self.currentTransform, scale, scale);
        
        self.transform = CGAffineTransformRotate(transform, radius);
        
        if (gesture.state == UIGestureRecognizerStateEnded ||
            gesture.state == UIGestureRecognizerStateCancelled) {
            self.currentScale = scale * self.currentScale;
        }
    }
}

// 距离
- (CGFloat)getDistance:(CGPoint)pointA withPointB:(CGPoint)pointB {
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    
    return sqrt(x*x + y*y);
}

// 角度
- (CGFloat)getRadius:(CGPoint)pointA withPointB:(CGPoint)pointB {
    CGFloat x = pointA.x - pointB.x;
    CGFloat y = pointA.y - pointB.y;
    return atan2(x, y);
}

#pragma mark - button action

- (void)closeButtonClicked {
    if (!self.superview) {
        return;
    }
    PLSStickerOverlayView *overlay = (PLSStickerOverlayView *)self.superview;
    if (overlay.delegate && [overlay.delegate respondsToSelector:@selector(stickerOverlayView:didClickClose:)]) {
        [overlay.delegate stickerOverlayView:overlay didClickClose:self];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.textLabel setText:_textView.text];
}

- (void)textDidChange:(NSNotification *)notify {
    self.textLabel.text = self.textView.text;
}

- (void)startTextEditing:(UITapGestureRecognizer *)tapGes {
    if (self.delegate && [self.delegate respondsToSelector:@selector(stickerView:startTextEdit:)]) {
        [self.delegate stickerView:self startTextEdit:tapGes];
    }
}

#pragma mark - public

- (void)setScaleImage:(UIImage *)image selectedImage:(nonnull UIImage *)selectedImage size:(CGSize)size {
    if (image) {
        [self.scaleButton setImage:image forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [self.scaleButton setImage:selectedImage forState:UIControlStateSelected];
    }
    
    CGSize originSize = self.scaleButton.frame.size;
    if (!CGSizeEqualToSize(size, CGSizeZero) && !CGSizeEqualToSize(size, originSize)) {
        self.scaleButton.frame = CGRectMake(self.scaleButton.frame.origin.x + originSize.width/2 - size.width/2, self.scaleButton.frame.origin.y + originSize.height/2 - size.height/2, size.width, size.height);
    }
}

- (void)setScaleMinScaleValue:(CGFloat)minValue maxScaleValue:(CGFloat)maxValue {
    self.minValue = minValue;
    self.maxValue = maxValue;
}

- (void)setCloseImage:(UIImage *)image selectedImage:(UIImage *)selectedImage size:(CGSize)size {
    if (image) {
        [self.closeButton setImage:image forState:UIControlStateNormal];
    }
    if (selectedImage) {
        [self.closeButton setImage:selectedImage forState:UIControlStateSelected];
    }
    
    CGSize originSize = self.closeButton.frame.size;
    if (!CGSizeEqualToSize(size, CGSizeZero) && !CGSizeEqualToSize(size, originSize)) {
        self.closeButton.frame = CGRectMake(self.closeButton.frame.origin.x + originSize.width/2 - size.width/2, self.closeButton.frame.origin.y + originSize.height/2 - size.height/2, size.width, size.height);
    }
}

#pragma mark - super methods

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.alpha > 0.1 && !self.clipsToBounds) {
        for (UIView *subView in @[self.scaleButton, self.closeButton]) {
            CGPoint subPoint = [self convertPoint:point toView:subView];
            UIView *resultView = [subView hitTest:subPoint withEvent:event];
            if (resultView) {
                return resultView;
            }
        }
    }
    return [super hitTest:point withEvent:event];
}

- (BOOL)becomeFirstResponder {
    if (![self.textView canBecomeFirstResponder]) {
        return NO;
    }
    return [self.textView becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [super resignFirstResponder];
    return [self.textView resignFirstResponder];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
