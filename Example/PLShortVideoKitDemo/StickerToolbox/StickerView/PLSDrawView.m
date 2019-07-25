//
//  PLSDrawView.m
//  PLShortVideoKitDemo
//
//  Created by 冯文秀 on 2019/7/24.
//  Copyright © 2019 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "PLSDrawView.h"

NSString *const kPLSDrawViewData = @"PLSDrawViewData";

@interface PLSDrawBezierPath : UIBezierPath

@property (nonatomic, strong) UIColor *color;

@end
@implementation PLSDrawBezierPath

@end

@interface PLSDrawView()
{
    BOOL _isWork;
    BOOL _isBegan;
}
/** 笔画 */
@property (nonatomic, strong) NSMutableArray <PLSDrawBezierPath *>*lineArray;
/** 图层 */
@property (nonatomic, strong) NSMutableArray <CAShapeLayer *>*slayerArray;
@end

@implementation PLSDrawView

- (instancetype)initWithFrame:(CGRect)frame duration:(CMTime)duration{
    self = [super initWithFrame:frame];
    if (self) {
        self.drawModel = [[PLSDrawModel alloc] init];
        self.drawModel.startPositionTime = kCMTimeZero;
        self.drawModel.endPositiontime = duration;
        
        [self customInit];
    }
    return self;
}

- (void)customInit {
    _lineWidth = 5.f;
    _lineColor = [UIColor whiteColor];
    _slayerArray = [@[] mutableCopy];
    _lineArray = [@[] mutableCopy];
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    self.drawModel.lineColor = _lineColor;
    self.drawModel.lineWidth = _lineWidth;
}

- (void)getStickerModel {
    self.drawModel.lineColor = _lineColor;
    self.drawModel.lineWidth = _lineWidth;
}

#pragma mark - 创建图层
- (CAShapeLayer *)createShapeLayer:(PLSDrawBezierPath *)path {
    /** 1、渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
     2、高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
     3、不会被图层边界剪裁掉。
     4、不会出现像素化。 */
    
    CAShapeLayer *slayer = [CAShapeLayer layer];
    slayer.path = path.CGPath;
    slayer.backgroundColor = [UIColor clearColor].CGColor;
    slayer.fillColor = [UIColor clearColor].CGColor;
    slayer.lineCap = kCALineCapRound;
    slayer.lineJoin = kCALineJoinRound;
    slayer.strokeColor = path.color.CGColor;
    slayer.lineWidth = path.lineWidth;
    
    return slayer;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if ([event allTouches].count == 1) {
        _isWork = NO;
        _isBegan = YES;
        
        //1、每次触摸的时候都应该去创建一条贝塞尔曲线
        PLSDrawBezierPath *path = [PLSDrawBezierPath new];
        //2、移动画笔
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        //设置线宽
        path.lineWidth = self.lineWidth;
        path.lineCapStyle = kCGLineCapRound; //线条拐角
        path.lineJoinStyle = kCGLineJoinRound; //终点处理
        [path moveToPoint:point];
        //设置颜色
        path.color = self.lineColor;//保存线条当前颜色
        [self.lineArray addObject:path];
        
        CAShapeLayer *slayer = [self createShapeLayer:path];
        [self.layer addSublayer:slayer];
        [self.slayerArray addObject:slayer];
        
    } else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1){
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
        PLSDrawBezierPath *path = self.lineArray.lastObject;
        if (!CGPointEqualToPoint(path.currentPoint, point)) {
            if (_isBegan && self.drawBegan) self.drawBegan();
            _isBegan = NO;
            _isWork = YES;
            [path addLineToPoint:point];
            CAShapeLayer *slayer = self.slayerArray.lastObject;
            slayer.path = path.CGPath;
        }
        
    } else {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    if ([event allTouches].count == 1){
        if (_isWork) {
            if (self.drawEnded) self.drawEnded();
        } else {
            [self undo];
        }
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([event allTouches].count == 1){
        if (_isWork) {
            if (self.drawEnded) self.drawEnded();
        } else {
            [self undo];
        }
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

/** 是否可撤销 */
- (BOOL)canUndo {
    return self.lineArray.count;
}

//撤销
- (void)undo {
    [self.slayerArray.lastObject removeFromSuperlayer];
    [self.slayerArray removeLastObject];
    [self.lineArray removeLastObject];
}

- (void)clear {
    for (NSInteger i = self.slayerArray.count - 1; i > -1; i--) {
        CAShapeLayer *slayer = self.slayerArray[i];
        [slayer removeFromSuperlayer];
        [self.slayerArray removeObject:slayer];
    }
    self.lineArray = [NSMutableArray array];
}

#pragma mark  - 数据
- (NSDictionary *)data {
    if (self.lineArray.count) {
        return @{kPLSDrawViewData:[self.lineArray copy]};
    }
    return nil;
}

- (void)setData:(NSDictionary *)data {
    NSArray *lineArray = data[kPLSDrawViewData];
    if (lineArray.count) {
        for (PLSDrawBezierPath *path in lineArray) {
            CAShapeLayer *slayer = [self createShapeLayer:path];
            [self.layer addSublayer:slayer];
            [self.slayerArray addObject:slayer];
        }
        [self.lineArray addObjectsFromArray:lineArray];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
