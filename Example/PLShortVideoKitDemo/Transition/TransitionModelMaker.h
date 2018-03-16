//
//  TransitionModelView.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/25.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PLShortVideoKit/PLShortVideoKit.h>


@interface TransitionModelMaker : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailTitle;

@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIFont  *titleFont;

@property (nonatomic, strong)UIColor *detailTitleColor;
@property (nonatomic, strong)UIFont  *detailTitleFont;

/**
@abstract 根据配置的参数，返回一个CAAnimation对象，预览view的尺寸和导出视频的尺寸不一样的时候，为了能让预览效果达到和导出视频一样效果，需要对动画的位置等做比例缩放
@param videoSize 最终生成的文字转mp4视频的width、heigh
 
@return 包含imageSetting和textSetting
 */
- (NSDictionary *)settingsWithVideoSize:(CGSize)videoSize;
@end

// 大标题
@interface TransitionModelMakerBigTitle : TransitionModelMaker

@property (nonatomic, assign) NSInteger bigTitleSettingID;

- (NSArray <PLSTransition *> *)bigSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

@end

// 章节
@interface TransitionModelMakerChapter : TransitionModelMaker

@property (nonatomic, assign) NSInteger chapterSettingID;
@property (nonatomic, assign) NSInteger textSettingID;

- (NSArray <PLSTransition *> *)textSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)chapterSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

@end

// 简约
@interface TransitionModelMakerSimple : TransitionModelMaker

@property (nonatomic, assign) NSInteger imageSettingID;
@property (nonatomic, assign) NSInteger textSettingID;

- (NSArray <PLSTransition *> *)textSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)imageSettingTranstionWithImageSetting:(PLSImageSetting *)imageSetting;

@end

// 引用
@interface TransitionModelMakerQuote : TransitionModelMaker

@property (nonatomic, assign) NSInteger imageSettingID;
@property (nonatomic, assign) NSInteger textSettingID;

- (NSArray <PLSTransition *> *)textSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)imageSettingTranstionWithImageSetting:(PLSImageSetting *)imageSetting;

@end

// 标题和副标题
@interface TransitionModelMakerDetail : TransitionModelMaker

@property (nonatomic, assign) NSInteger detailSettingID;
@property (nonatomic, assign )NSInteger titleSettingID;

- (NSArray <PLSTransition *> *)titleSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)detailSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

@end

// 片尾
@interface TransitionModelMakerTail : TransitionModelMaker

@property (nonatomic, assign) NSInteger directorNameSettingID;
@property (nonatomic, assign) NSInteger dateLocationValueSettingID;
@property (nonatomic, assign) NSInteger directorSettingID;
@property (nonatomic, assign) NSInteger dateLocationSettingID;

- (NSArray <PLSTransition *> *)directorSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)directorNameSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)dateLocationSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

- (NSArray <PLSTransition *> *)dateLocationValueSettingTranstionWithTextSetting:(PLSTextSetting *)textSetting;

@end
