//
//  TransitionModelView.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/25.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "TransitionModelMaker.h"
#import <UIKit/UIKit.h>


@implementation TransitionModelMaker

- (CGFloat)edagSpace {
    return 30;
}

- (CGSize)sizeWithFont:(UIFont *)font andMaxSize:(CGSize)size text:(NSString *)text {
    NSDictionary*attrs =@{NSFontAttributeName: font};
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    return  CGSizeMake(textSize.width + 10, textSize.height);
}

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    return nil;
}

- (UIColor *)colorWithHexString:(NSString *)hexString{
    return [self colorWithHexString:hexString alpha:1];
}

- (UIColor *)colorWithHexString:(NSString *)hexString alpha:(float)alpha{
    
    if ([hexString hasPrefix:@"#"]) {
        hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexString substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(alpha*1.0f)];
}

- (PLSFadeTranstion *)fadeTransitionWithStartTime:(NSTimeInterval)startTime
                                         duration:(NSTimeInterval)duration
                                      fromOpacity:(CGFloat)fromOpacity
                                        toOpacity:(CGFloat)toOpacity {
    
    PLSFadeTranstion *fadeTransition = [[PLSFadeTranstion alloc] init];
    fadeTransition.startTimeInMs = startTime;
    fadeTransition.durationInMs  = duration;
    fadeTransition.fromOpacity   = fromOpacity;
    fadeTransition.toOpacity     = toOpacity;

    return fadeTransition;
}

- (PLSPositionTransition *)positionTransitionWithStartTime:(NSTimeInterval)startTime
                                                  duration:(NSTimeInterval)duration
                                                 fromPoint:(CGPoint)fromPoint
                                                   toPoint:(CGPoint)toPoint {
    
    PLSPositionTransition *positionTransition = [[PLSPositionTransition alloc] init];
    positionTransition.startTimeInMs    = startTime;
    positionTransition.durationInMs     = duration;
    positionTransition.fromPoint        = fromPoint;
    positionTransition.toPoint          = toPoint;
    
    return positionTransition;
}

- (PLSRotateTransition *)rotateTransitionWithStartTime:(NSTimeInterval)startTime
                                              duration:(NSTimeInterval)duration
                                             fromAngle:(CGFloat)fromAngle
                                               toAngle:(CGFloat)toAngle {
    
    PLSRotateTransition *rotateTransition = [[PLSRotateTransition alloc] init];
    rotateTransition.startTimeInMs  = startTime;
    rotateTransition.durationInMs   = duration;
    rotateTransition.fromAngle      = fromAngle;
    rotateTransition.toAngle        = toAngle;
    
    return rotateTransition;
}

- (PLSScaleTransition *)scaleTransitionWithStartTime:(NSTimeInterval)startTime
                                            duration:(NSTimeInterval)duration
                                           fromScale:(CGFloat)fromScale
                                             toScale:(CGFloat)toScale {
    
    PLSScaleTransition *scaleTransition = [[PLSScaleTransition alloc] init];
    scaleTransition.startTimeInMs = startTime;
    scaleTransition.durationInMs  = duration;
    scaleTransition.fromScale     = fromScale;
    scaleTransition.toScale       = toScale;
    
    return scaleTransition;
}

@end


@implementation TransitionModelMakerBigTitle

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    
    CGFloat sizeScale = videoSize.width / 375.0;
    
    if (!self.title.length) {
        self.title = @"七月与安生";
    }
    if (!self.titleFont) {
        // PingFangSC iOS9之后才加入的字体，如果iOS9之前的需要自己导入PingFangSC字体
        if (@available(iOS 9, *)) {
            self.titleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:38*sizeScale];
        } else {
//            self.titleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:38*sizeScale];
            self.titleFont = [UIFont systemFontOfSize:38 * sizeScale];
        }
        
    }
    if (!self.titleColor) {
        self.titleColor = [self colorWithHexString:@"#FFFFFF"];
    }
    
    CGSize textSize = [self sizeWithFont:self.titleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.title];
    
    PLSTextSetting *textSetting = [[PLSTextSetting alloc] init];
    textSetting.textFont = self.titleFont;
    textSetting.textColor = self.titleColor;
    textSetting.startX = (videoSize.width - textSize.width)/2;
    textSetting.startY = (videoSize.height - textSize.height)/2;
    textSetting.text = self.title;
    textSetting.textSize = textSize;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:textSetting ,@"titleSetting", nil];
}

- (NSArray<PLSTransition *> *)bigSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0.0f duration:1250.0f fromOpacity:0.0f toOpacity:1.0f];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

@end



@implementation TransitionModelMakerChapter

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    
    CGFloat sizeScale = videoSize.width / 375.0;
    
    if (!self.title.length) {
        self.title = @"第一章 七年";
    }
    
    if (!self.titleFont) {
        if (@available(iOS 9, *)) {
            self.titleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:28 * sizeScale];
        } else {
            self.titleFont = [UIFont systemFontOfSize:28 * sizeScale];
        }
    }
    
    if (!self.titleColor) {
        self.titleColor = [self colorWithHexString:@"#FFFFFF"];
    }

    CGSize chapterSize = [self sizeWithFont:self.titleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.title];
    
    PLSTextSetting *chapterTextSetting = [[PLSTextSetting alloc] init];
    chapterTextSetting.textFont = self.titleFont;
    chapterTextSetting.textColor = self.titleColor;
    chapterTextSetting.startX   = videoSize.width - chapterSize.width - [self edagSpace];
    chapterTextSetting.startY   = (videoSize.height - chapterSize.height) / 2;
    chapterTextSetting.text     = self.title;
    chapterTextSetting.textSize = chapterSize;
    
    UIFont *font = nil;
    if (@available(iOS 9, *)) {
         font = [UIFont fontWithName:@"PingFangSC-Thin" size:16 * sizeScale];
    } else {
        font = [UIFont systemFontOfSize:16 * sizeScale];
    }
    
    chapterSize = [self sizeWithFont:font andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:@"CHAPTER"];

    PLSTextSetting *chapterSetting = [[PLSTextSetting alloc] init];
    chapterSetting.textFont = font;
    chapterSetting.textColor = [self colorWithHexString:@"#FFCC99"];
    chapterSetting.startX = videoSize.width - chapterSize.width - [self edagSpace];
    chapterSetting.startY = chapterTextSetting.startY - chapterSize.height - 10;
    chapterSetting.text = @"CHAPTER";
    chapterSetting.textSize = chapterSize;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            chapterTextSetting, @"textSetting",
            chapterSetting, @"chapterSetting",
            nil];
}

- (NSArray <PLSTransition *> *)textSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(2 * textSetting.startX + textSetting.textSize.width, center.y)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

- (NSArray <PLSTransition *> *)chapterSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    return @[fadeTransition];
}

@end


@implementation TransitionModelMakerSimple

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    
    CGFloat sizeScale = videoSize.width / 375.0;
    
    if (!self.title.length) {
        self.title = @"第二章 暖暖";
    }
    
    if (!self.titleFont) {
        self.titleFont = [UIFont systemFontOfSize:28 * sizeScale];//default
    }
    
    if (!self.titleColor) {
        self.titleColor = [self colorWithHexString:@"#FFFFFF"];
    }
    
    CGSize textSize = [self sizeWithFont:self.titleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.title];
    
    PLSTextSetting *textSetting = [[PLSTextSetting alloc] init];
    textSetting.textFont = self.titleFont;
    textSetting.textColor = self.titleColor;
    textSetting.startX = [self edagSpace];
    textSetting.startY = (videoSize.height - textSize.height)/2;
    textSetting.text = self.title;
    textSetting.textSize = textSize;
    
    PLSImageSetting *imageSetting = [[PLSImageSetting alloc] init];
    imageSetting.image = [UIImage imageNamed:@"pink_line"];
    imageSetting.imageSize = CGSizeMake(imageSetting.image.size.width * sizeScale, imageSetting.image.size.height * sizeScale);
    imageSetting.startY = textSetting.startY - imageSetting.imageSize.height - 20;
    imageSetting.startX = [self edagSpace];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            textSetting, @"textSetting",
            imageSetting, @"imageSetting",
            nil];
}

- (NSArray <PLSTransition *> *)textSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(-textSetting.textSize.width, center.y)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

- (NSArray <PLSTransition *> *)imageSettingTranstionWithImageSetting:(PLSImageSetting *)imageSetting {
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    return @[fadeTransition];
}


@end


@implementation TransitionModelMakerQuote

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    
    CGFloat sizeScale = videoSize.width / 375.0;
    
    if (!self.title.length) {
        self.title = @"村上春树于1949年1月12日出生在日本京都市伏见区，为国语教师村上千秋、村上美幸夫妇的长子。出生不久，家迁至兵库县西宫市夙川。村上春树于1949年1月12日出生在日本京都市伏见区，为国语教师村上千秋、村上美幸夫妇的长子。出生不久，家迁至兵库县西宫市夙川。";
    }
    
    if (!self.titleFont) {
        self.titleFont = [UIFont systemFontOfSize:20 * sizeScale];
    }
    
    if (!self.titleColor) {
        self.titleColor = [self colorWithHexString:@"#339900"];
    }
    
    CGSize textSize = [self sizeWithFont:self.titleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.title];
    
    PLSTextSetting *textSetting = [[PLSTextSetting alloc] init];
    textSetting.textFont = self.titleFont;
    textSetting.textColor = self.titleColor;
    textSetting.startX = [self edagSpace];
    textSetting.startY = (videoSize.height - textSize.height)/2;
    textSetting.text = self.title;
    textSetting.textSize = textSize;
    
    PLSImageSetting *imageSetting = [[PLSImageSetting alloc] init];
    imageSetting.image = [UIImage imageNamed:@"green_quot"];
    imageSetting.imageSize = CGSizeMake(imageSetting.image.size.width * sizeScale, imageSetting.image.size.height * sizeScale);
    imageSetting.startY = textSetting.startY - imageSetting.imageSize.height - 30;
    imageSetting.startX = [self edagSpace];

    return [NSDictionary dictionaryWithObjectsAndKeys:
            textSetting, @"quoteSetting",
            imageSetting, @"imageSetting",
            nil];
}

- (NSArray <PLSTransition *> *)textSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];

}

- (NSArray <PLSTransition *> *)imageSettingTranstionWithImageSetting:(PLSImageSetting *)imageSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(imageSetting.startX + imageSetting.imageSize.width / 2, imageSetting.startY + imageSetting.imageSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    
    return @[fadeTransition, positionTransition];
}

@end


@implementation TransitionModelMakerDetail

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    
    CGFloat sizeScale = videoSize.width / 375.0;
    
    if (!self.title.length) {
        self.title = @"挪威的森林";
    }

    if (!self.titleFont) {
        self.titleFont = [UIFont systemFontOfSize:36 * sizeScale];
    }
    
    if (!self.titleColor) {
        self.titleColor = [self colorWithHexString:@"#FFFFFF"];
    }
    CGSize textSize = [self sizeWithFont:self.titleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.title];
    
    PLSTextSetting *titleSetting = [[PLSTextSetting alloc] init];
    titleSetting.textFont = self.titleFont;
    titleSetting.textColor = self.titleColor;
    titleSetting.startX   = (videoSize.width - textSize.width)/2;
    titleSetting.startY   = (videoSize.height - textSize.height)/2;
    titleSetting.text     = self.title;
    titleSetting.textSize = textSize;
    
    if (!self.detailTitle.length) {
        self.detailTitle = @"- 村上春树 -";
    }
    
    if (!self.detailTitleFont) {
        self.detailTitleFont = [UIFont systemFontOfSize:20 * sizeScale];
    }
    
    if (!self.detailTitleColor) {
        self.detailTitleColor = [self colorWithHexString:@"#FFCC99"];
    }
    
    textSize = [self sizeWithFont:self.detailTitleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.detailTitle];
    
    PLSTextSetting *detailSetting = [[PLSTextSetting alloc] init];
    detailSetting.textFont = self.detailTitleFont;
    detailSetting.textColor = self.detailTitleColor;
    detailSetting.startX = (videoSize.width - textSize.width)/2;
    detailSetting.startY = titleSetting.startY + titleSetting.textSize.height + 10;
    detailSetting.text = self.detailTitle;
    detailSetting.textSize = textSize;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            titleSetting, @"titleSetting",
            detailSetting, @"detailSetting",
            nil];
}

- (NSArray <PLSTransition *> *)titleSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    
    return @[fadeTransition, positionTransition];
}

- (NSArray <PLSTransition *> *)detailSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

@end


@implementation TransitionModelMakerTail

- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize {
    
    CGFloat sizeScale = videoSize.width / 375.0;
    
    if (!self.title.length) {
        self.title = @"七牛";
    }
    
    if (!self.titleFont) {
        self.titleFont = [UIFont systemFontOfSize:18 * sizeScale];
    }
    
    if (!self.titleColor) {
        self.titleColor = [self colorWithHexString:@"#FFCC99"];
    }
    
    if (!self.detailTitle.length) {
        self.detailTitle = @"2018.1.1 上海";
    }

    CGSize textSize = [self sizeWithFont:self.titleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.title];
    
    PLSTextSetting *directorNameSetting = [[PLSTextSetting alloc] init];
    directorNameSetting.textFont = self.titleFont;
    directorNameSetting.textColor = self.titleColor;
    directorNameSetting.startX   = (videoSize.width - textSize.width ) / 2;
    directorNameSetting.startY   = videoSize.height / 2 - 10 - textSize.height;
    directorNameSetting.text     = self.title;
    directorNameSetting.textSize = textSize;

    UIFont *font = [UIFont systemFontOfSize:18 * sizeScale];
    NSString *director = @"DIRECTOR";
    textSize = [self sizeWithFont:font andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:director];
    PLSTextSetting *directorSetting = [[PLSTextSetting alloc] init];
    directorSetting.textFont = font;
    directorSetting.textColor = [UIColor whiteColor];
    directorSetting.startX   = (videoSize.width - textSize.width ) / 2;
    directorSetting.startY   = directorNameSetting.startY - textSize.height - 10;
    directorSetting.text     = director;
    directorSetting.textSize = textSize;

    NSString *dateLocation = @"DATE & LOCATION";
    textSize = [self sizeWithFont:font andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:dateLocation];
    PLSTextSetting *dateLocationSetting = [[PLSTextSetting alloc] init];
    dateLocationSetting.textFont = font;
    dateLocationSetting.textColor = [UIColor whiteColor];
    dateLocationSetting.startX   = (videoSize.width - textSize.width ) / 2;
    dateLocationSetting.startY   = videoSize.height / 2 + 10;
    dateLocationSetting.text     = dateLocation;
    dateLocationSetting.textSize = textSize;

    if (!self.detailTitleFont) {
        self.detailTitleFont = [UIFont systemFontOfSize:18 * sizeScale];
    }
    if (!self.detailTitleColor) {
        self.detailTitleColor = [self colorWithHexString:@"#FFCC99"];
    }
    textSize = [self sizeWithFont:self.detailTitleFont andMaxSize:CGSizeMake(videoSize.width - 2 * [self edagSpace], videoSize.height - 2 * [self edagSpace]) text:self.detailTitle];
    PLSTextSetting *dateLocationValueSetting = [[PLSTextSetting alloc] init];
    dateLocationValueSetting.textFont = self.detailTitleFont;
    dateLocationValueSetting.textColor = self.detailTitleColor;
    dateLocationValueSetting.startX   = (videoSize.width - textSize.width ) / 2;
    dateLocationValueSetting.startY   = dateLocationSetting.startY + dateLocationSetting.textSize.height + 10;
    dateLocationValueSetting.text     = self.detailTitle;
    dateLocationValueSetting.textSize = textSize;
    
    return [NSDictionary dictionaryWithObjectsAndKeys:
            directorNameSetting, @"directorNameSetting",
            directorSetting, @"directorSetting",
            dateLocationValueSetting, @"dateLocationValueSetting",
            dateLocationSetting, @"dateLocationSetting",
            nil];
}

- (NSArray <PLSTransition *> *)directorSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];

}

- (NSArray <PLSTransition *> *)directorNameSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

- (NSArray <PLSTransition *> *)dateLocationSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {
    
    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

- (NSArray <PLSTransition *> *)dateLocationValueSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting {

    PLSFadeTranstion *fadeTransition = [self fadeTransitionWithStartTime:0 duration:1250 fromOpacity:0 toOpacity:1];
    
    CGPoint center = CGPointMake(textSetting.startX + textSetting.textSize.width / 2, textSetting.startY + textSetting.textSize.height/2);
    PLSPositionTransition *positionTransition = [self positionTransitionWithStartTime:0
                                                                             duration:1250
                                                                            fromPoint:CGPointMake(center.x, center.y + 50)
                                                                              toPoint:center];
    return @[fadeTransition, positionTransition];
}

@end
