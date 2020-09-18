//
//  TransitionViewController.m
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/1/23.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import "TransitionViewController.h"
#import <PLShortVideoKit/PLShortVideoKit.h>
#import <Masonry.h>
#import "TransitionModelSelectView.h"
#import "TransitionTextEditViewController.h"
#import "TransitionModelMaker.h"

@interface TransitionViewController ()
<
TransitionModelSelectViewDelegate,
TransitionTextEditViewControllerDelegate,
PLSTransitionMakerDelegate
>

@property (nonatomic, assign) CGFloat collectionViewHeight;

@property (nonatomic, strong) PLSTransitionMaker *transitionMaker;

@property (nonatomic, strong) UIView *waitingView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) TransitionModelSelectView *modelSelectView;

@property (nonatomic, assign) PLSTextModel textModel;

@property (nonatomic, strong) TransitionModelMakerBigTitle   *makerBigTitle;
@property (nonatomic, strong) TransitionModelMakerChapter    *makerChapter;
@property (nonatomic, strong) TransitionModelMakerSimple     *makerSimple;
@property (nonatomic, strong) TransitionModelMakerQuote      *makerQuote;
@property (nonatomic, strong) TransitionModelMakerDetail     *makerDetail;
@property (nonatomic, strong) TransitionModelMakerTail       *makerTail;

@end

@implementation TransitionViewController

- (void)dealloc {
    NSLog(@"dealloc self.class = %@", NSStringFromClass(self.class));
}

- (void)setBackgroundVideoURL:(NSURL *)backgroundVideoURL {
    _backgroundVideoURL = backgroundVideoURL;
    [self resetBackgroundURL:backgroundVideoURL];
}

- (void)resetBackgroundURL:(NSURL *)backgroundURL {
    
    self.transitionMaker.backgroundVideoURL = backgroundURL;
    
    // 设置输出视频的时候，根据视频方向校正一下宽高，避免预览和输出的视频宽高对换的问题出现
    AVAsset *asset = [AVAsset assetWithURL:backgroundURL];
    AVAssetTrack *videoAssetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    self.transitionMaker.totalDuration = 2.55;
    CGSize outSize = videoAssetTrack.naturalSize;
    
    if ([self checkForPortrait:videoAssetTrack.preferredTransform]) {
        outSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
    }
    self.transitionMaker.outPixelSize = outSize;
}

- (BOOL)checkForPortrait:(CGAffineTransform)transform {
    BOOL assetPortrait  = NO;
//    (CGAffineTransform) transform = (a = 1, b = 0, c = 0, d = 1, tx = 0, ty = 0)

    if(transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0) {
        //is portrait
        assetPortrait = YES;
    }
    else if(transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0) {
        //is portrait
        assetPortrait = YES;
    }
    else if(transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0) {
        //is landscape
    }
    else if(transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0) {
        //is landscape
    }
    
    return assetPortrait;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:(UIBarMetricsDefault)];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:(UIBarButtonItemStylePlain) target:self action:@selector(clickBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
//    UIBarButtonItem *trashItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemTrash) target:self action:@selector(clickTrashItem:)];
//    self.navigationItem.rightBarButtonItem = trashItem;
    
    NSURL *outURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingString:@"/transition_out.mp4"]];
    if ([[NSFileManager  defaultManager] fileExistsAtPath:outURL.path]) {
        [[NSFileManager  defaultManager] removeItemAtURL:outURL error:nil];
    }
    
    self.transitionMaker = [[PLSTransitionMaker alloc] init];
    if (nil == _backgroundVideoURL) {
        _backgroundVideoURL = [[NSBundle mainBundle] URLForResource:@"transition_black" withExtension:@"mp4"];
    }
    [self resetBackgroundURL:_backgroundVideoURL];
    
    self.transitionMaker.outputVideoURL = outURL;
    self.transitionMaker.delegate = self;
    self.transitionMaker.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:self.transitionMaker.preview];
    
    self.modelSelectView = [[TransitionModelSelectView alloc] init];
    self.modelSelectView.delegate = self;
    [self.view addSubview:self.modelSelectView];
    
    [self.modelSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@(120));
    }];
    [self.transitionMaker.preview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.modelSelectView.mas_top);
    }];
    
    self.makerBigTitle  = [[TransitionModelMakerBigTitle alloc] init];
    self.makerChapter   = [[TransitionModelMakerChapter alloc] init];
    self.makerSimple    = [[TransitionModelMakerSimple alloc] init];
    self.makerQuote     = [[TransitionModelMakerQuote alloc] init];
    self.makerDetail    = [[TransitionModelMakerDetail alloc] init];
    self.makerTail      = [[TransitionModelMakerTail alloc] init];
    
    self.textModel = PLSTextModelBigTitle;
    [self resetTransitionWithWithTitle:nil titleFont:nil titleColor:nil detailTitle:nil detailFont:nil detailColor:nil update:NO];
}

- (void)showWaitingInView:(UIView*)view {
    
    if (nil == self.waitingView) {
        self.waitingView = [[UIView alloc] init];
        self.waitingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:.5];
        self.indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        [self.waitingView addSubview:self.indicatorView];
        [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.equalTo(@(CGSizeMake(32, 32)));
            make.center.equalTo(self.waitingView);
        }];
    }
    
    [view addSubview:self.waitingView];
    [self.waitingView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [self.indicatorView startAnimating];
}

- (void)hideWaiting {
    [self.indicatorView stopAnimating];
    [self.waitingView removeFromSuperview];
}

- (void)clickBackItem:(UIBarButtonItem *)item {
    [self.transitionMaker cancelMaking];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickTrashItem:(UIBarButtonItem *)item {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (TransitionModelMaker *)selectModelMaker {
    switch (_textModel) {
        case PLSTextModelBigTitle:
            return self.makerBigTitle;
        case PLSTextModelchapter:
            return self.makerChapter;
        case PLSTextModelSimple:
            return self.makerSimple;
        case PLSTextModelQuote:
            return self.makerQuote;
        case PLSTextModelDetail:
            return self.makerDetail;
        case PLSTextModelTail:
            return self.makerTail;
    }
    return nil;
}

- (void)setTextModel:(PLSTextModel)textModel {
    if (textModel != _textModel) {
        _textModel = textModel;
        
        [self.transitionMaker removeAllResource];
        
        TransitionModelMaker *selecteMaker = [self selectModelMaker];
        
        [self resetTransitionWithWithTitle:selecteMaker.title
                                 titleFont:selecteMaker.titleFont
                                titleColor:selecteMaker.titleColor
                               detailTitle:selecteMaker.detailTitle
                                detailFont:selecteMaker.detailTitleFont
                               detailColor:selecteMaker.detailTitleColor
                                    update:NO];
    }
}

- (void)resetTransitionWithWithTitle:(NSString *)title
                           titleFont:(UIFont *)titleFont
                          titleColor:(UIColor *)titleColor
                         detailTitle:(NSString *)detail
                          detailFont:(UIFont *)detailFont
                         detailColor:(UIColor *)detailColor
                              update:(BOOL)update {

    TransitionModelMaker *modelMaker = [self selectModelMaker];
    modelMaker.title          = title;
    modelMaker.detailTitle    = detail;
    modelMaker.titleFont      = titleFont;
    modelMaker.detailTitleFont= detailFont;
    modelMaker.titleColor     = titleColor;
    modelMaker.detailTitleColor = detailColor;
    
    CGSize videoSize = CGSizeMake(self.transitionMaker.outPixelSize.width, self.transitionMaker.outPixelSize.height);
    
    switch (_textModel) {
        // 大标题
        case PLSTextModelBigTitle: {
            NSDictionary *dic = [self.makerBigTitle settingsWithVideoSize:videoSize];
            PLSTextSetting *textSetting = [dic objectForKey:@"titleSetting"];
            NSArray *transitions = [self.makerBigTitle bigSettingTranstionWithTextSetting:textSetting];
            if (update) {
                [self.transitionMaker updateTextWithResourceID:self.makerBigTitle.bigTitleSettingID newTextSetting:textSetting];
            } else {
                self.makerBigTitle.bigTitleSettingID = [self.transitionMaker addText:textSetting];
            }
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerBigTitle.bigTitleSettingID];
            }
        }
            break;
            
        // 章节
        case PLSTextModelchapter: {
            NSDictionary *dic = [self.makerChapter settingsWithVideoSize:videoSize];
            
            PLSTextSetting *textSetting = [dic objectForKey:@"textSetting"];
            PLSTextSetting *chapterSetting = [dic objectForKey:@"chapterSetting"];

            if (update) {
                [self.transitionMaker updateTextWithResourceID:self.makerChapter.textSettingID newTextSetting:textSetting];
                [self.transitionMaker updateTextWithResourceID:self.makerChapter.chapterSettingID newTextSetting:chapterSetting];
            }  else {
                self.makerChapter.textSettingID = [self.transitionMaker addText:textSetting];
                self.makerChapter.chapterSettingID = [self.transitionMaker addText:chapterSetting];
            }
            
            NSArray *transitions = [self.makerChapter textSettingTranstionWithTextSetting:textSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerChapter.textSettingID];
            }
            
            transitions = [self.makerChapter chapterSettingTranstionWithTextSetting:chapterSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerChapter.chapterSettingID];
            }
        }
            break;
            
        // 简约
        case PLSTextModelSimple: {
            NSDictionary *dic = [self.makerSimple settingsWithVideoSize:videoSize];
            PLSTextSetting *textSetting = [dic objectForKey:@"textSetting"];
            PLSImageSetting *imageSetting = [dic objectForKey:@"imageSetting"];

            if (update) {
                [self.transitionMaker updateTextWithResourceID:self.makerSimple.textSettingID newTextSetting:textSetting];
                [self.transitionMaker updateImageWithResourceID:self.makerSimple.imageSettingID newImageSetting:imageSetting];
            } else {
                self.makerSimple.textSettingID = [self.transitionMaker addText:textSetting];
                self.makerSimple.imageSettingID = [self.transitionMaker addImage:imageSetting];
            }
            NSArray *transitions = [self.makerSimple textSettingTranstionWithTextSetting:textSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerSimple.textSettingID];
            }
       
            transitions = [self.makerSimple imageSettingTranstionWithImageSetting:imageSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerSimple.imageSettingID];
            }
        }
            break;
            
        // 引用
        case PLSTextModelQuote: {
            NSDictionary *dic = [self.makerQuote settingsWithVideoSize:videoSize];
            PLSTextSetting *textSetting = [dic objectForKey:@"quoteSetting"];
            PLSImageSetting *imageSetting = [dic objectForKey:@"imageSetting"];

            if (update) {
                [self.transitionMaker updateTextWithResourceID:self.makerQuote.textSettingID newTextSetting:textSetting];
                [self.transitionMaker updateImageWithResourceID:self.makerQuote.imageSettingID newImageSetting:imageSetting];
            } else {
                self.makerQuote.textSettingID = [self.transitionMaker addText:textSetting];
                self.makerQuote.imageSettingID = [self.transitionMaker addImage:imageSetting];
            }
            
            NSArray *transitions = [self.makerQuote textSettingTranstionWithTextSetting:textSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerQuote.textSettingID];
            }
            
            transitions = [self.makerQuote imageSettingTranstionWithImageSetting:imageSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerQuote.imageSettingID];
            }
        }
            break;
            
        // 标题和副标题
        case PLSTextModelDetail: {
            
            NSDictionary *dic = [self.makerDetail settingsWithVideoSize:videoSize];
            
            PLSTextSetting *titleTextSetting = [dic objectForKey:@"titleSetting"];
            PLSTextSetting *detailTextSetting = [dic objectForKey:@"detailSetting"];

            if (update) {
                [self.transitionMaker updateTextWithResourceID:self.makerDetail.titleSettingID  newTextSetting:titleTextSetting];
                [self.transitionMaker updateTextWithResourceID:self.makerDetail.detailSettingID newTextSetting:detailTextSetting];
            } else {
                self.makerDetail.titleSettingID = [self.transitionMaker addText:titleTextSetting];
                self.makerDetail.detailSettingID = [self.transitionMaker addText:detailTextSetting];
            }
            
            NSArray *transitions = [self.makerDetail titleSettingTranstionWithTextSetting:titleTextSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerDetail.titleSettingID];
            }
            
            transitions = [self.makerDetail detailSettingTranstionWithTextSetting:detailTextSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerDetail.detailSettingID];
            }
        }
            break;
         
        // 片尾
        case PLSTextModelTail: {
            NSDictionary *dic = [self.makerTail settingsWithVideoSize:videoSize];
            
            PLSTextSetting *directorNameSetting = [dic objectForKey:@"directorNameSetting"];
            PLSTextSetting *directorSetting = [dic objectForKey:@"directorSetting"];
            PLSTextSetting *dateLocationSetting = [dic objectForKey:@"dateLocationSetting"];
            PLSTextSetting *dateLocationValueSetting = [dic objectForKey:@"dateLocationValueSetting"];
            
            if (update) {
                [self.transitionMaker updateTextWithResourceID:self.makerTail.directorNameSettingID newTextSetting:directorNameSetting];
                [self.transitionMaker updateTextWithResourceID:self.makerTail.directorSettingID newTextSetting:directorSetting];
                [self.transitionMaker updateTextWithResourceID:self.makerTail.dateLocationSettingID newTextSetting:dateLocationSetting];
                [self.transitionMaker updateTextWithResourceID:self.makerTail.dateLocationValueSettingID newTextSetting:dateLocationValueSetting];
            } else {
                self.makerTail.directorNameSettingID = [self.transitionMaker addText:directorNameSetting];
                self.makerTail.directorSettingID = [self.transitionMaker addText:directorSetting];
                self.makerTail.dateLocationSettingID = [self.transitionMaker addText:dateLocationSetting];
                self.makerTail.dateLocationValueSettingID = [self.transitionMaker addText:dateLocationValueSetting];
            }
            
            NSArray *transitions = [self.makerTail directorSettingTranstionWithTextSetting:directorSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerTail.directorSettingID];
            }
            
            transitions = [self.makerTail directorNameSettingTranstionWithTextSetting:directorNameSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerTail.directorNameSettingID];
            }
            
            transitions = [self.makerTail dateLocationSettingTranstionWithTextSetting:dateLocationSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerTail.dateLocationSettingID];
            }
            
            transitions = [self.makerTail dateLocationValueSettingTranstionWithTextSetting:dateLocationValueSetting];
            for (PLSTransition *transition in transitions) {
                [self.transitionMaker addTransition:transition resourceID:self.makerTail.dateLocationValueSettingID];
            }
        }
            break;
        default:
            break;
    }
    
    [self.transitionMaker play];
}

// PLSTransitionMakerDelegate
- (void)transitionMakerPreviewEnd:(PLSTransitionMaker *)transitionMaker {
    [self hideWaiting];
}

- (void)transitionMaker:(PLSTransitionMaker *)transitionMaker exportMediaSucceed:(NSURL *)outURL {

    [self hideWaiting];
    
    if (self.delegate) {
        [self.delegate transitionViewController:self transitionMedia:outURL];
    } else {
        UISaveVideoAtPathToSavedPhotosAlbum([outURL path], nil, nil, nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存视频成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)transitionMaker:(PLSTransitionMaker *)transitionMaker exportMediaFailed:(NSError *)error {
    
    [self hideWaiting];
    
    NSLog(@"error = %@", error);
}

// TransitionModelSelectViewDelegate
- (void)modelSelectedView:(TransitionModelSelectView *)selectView selectModel:(PLSTextModel)model {
    self.textModel = model;
}

- (void)modelSelectedViewEditButtonAction:(TransitionModelSelectView *)selectView {
    TransitionModelMaker *modelMaker = [self selectModelMaker];
    NSMutableDictionary *dics = [[NSMutableDictionary alloc] init];
    
    [dics setObject:modelMaker.title forKey:@"title"];
    [dics setObject:modelMaker.titleFont forKey:@"titleFont"];
    [dics setObject:modelMaker.titleColor forKey:@"titleColor"];
    if (modelMaker.detailTitle) {
        [dics setObject:modelMaker.detailTitle forKey:@"detailTitle"];
        [dics setObject:modelMaker.detailTitleFont forKey:@"detailFont"];
        [dics setObject:modelMaker.detailTitleColor forKey:@"detailColor"];
    }
    
    TransitionTextEditViewController *editViewController = [[TransitionTextEditViewController alloc] initWithDic:dics model:_textModel];
    editViewController.delegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)modelSelectedViewSureButtonAction:(TransitionModelSelectView *)selectView {
    
    [self showWaitingInView:self.view];
    
    if (nil == self.transitionMaker.exportProgressBlock) {
        self.transitionMaker.exportProgressBlock = ^(CGFloat progress){
            NSLog(@"progress = %f", progress);
        };
    }
    [self.transitionMaker startMaking];
}

//  TransitionTextEditViewControllerDelegate
- (void)editViewController:(TransitionTextEditViewController *)editController completeWithModel:(PLSTextModel)model textInfo:(NSDictionary *)textDics {
    
    NSString *title         = [textDics objectForKey:@"title"];
    NSString *detailTitle   = [textDics objectForKey:@"detailTitle"];
    UIFont *titleFont       = [textDics objectForKey:@"titleFont"];
    UIFont *detailFont      = [textDics objectForKey:@"detailFont"];
    UIColor *titleColor     = [textDics objectForKey:@"titleColor"];
    UIColor *detailColor    = [textDics objectForKey:@"detailColor"];
    
    [self resetTransitionWithWithTitle:title titleFont:titleFont titleColor:titleColor detailTitle:detailTitle detailFont:detailFont detailColor:detailColor update:YES];
}

@end
