//
//  QNMusicPickerView.m
//  QNShortVideoDemo
//
//  Created by hxiongan on 2018/8/29.
//  Copyright © 2018年 hxiongan. All rights reserved.
//

#import "QNMusicPickerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "QNMusicDecibelView.h"
#import "QNPanImageView.h"
#import "QNBaseViewController.h"

@interface QNMusicPickerView ()
<
UITableViewDelegate,
UITableViewDataSource,
AVAudioPlayerDelegate
>

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *musicArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, strong) QNMusicModel *selectedModel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) UIButton *cancelbutton;
@property (nonatomic, strong) UIButton *donebutton;

@property (nonatomic, strong) QNMusicDecibelView *decibelView;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) UIImageView*    leftPanView;
@property (nonatomic, strong) UIImageView*    rightPanView;
@property (nonatomic, strong) UIImageView*    positionLineView;

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *centerLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, assign) CGFloat dbViewHeight;
@property (nonatomic, assign) CGFloat edgeSpace;
@property (nonatomic, assign) CGFloat minAvalibeWidth;//两个划片之间的最小距离

@property (nonatomic, strong) UIImpactFeedbackGenerator *feedback;
@property (nonatomic, assign) BOOL isPanning;

@property (nonatomic, assign) BOOL haveNULLModel;

@end

@implementation QNMusicPickerView

- (void)dealloc {
    [self destoryAudioPlayer];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame needNullModel:NO];
}

- (instancetype)initWithFrame:(CGRect)frame needNullModel:(BOOL)isNeedNullModel {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = QN_COMMON_BACKGROUND_COLOR;
        self.minMusicSelectDuration = 2.0;
        self.haveNULLModel = isNeedNullModel;
        self.dbViewHeight = 40;
        self.edgeSpace = 30;
        
        UIView *barView = [[UIView alloc] init];
        barView.backgroundColor = [UIColor colorWithWhite:.2 alpha:.2];
        [self addSubview:barView];
        [barView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(44);
        }];
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textColor = [UIColor lightTextColor];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.titleLabel];
        
        self.cancelbutton = [[UIButton alloc] init];
        [self.cancelbutton setTitle:@"取消" forState:(UIControlStateNormal)];
        self.cancelbutton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.cancelbutton addTarget:self action:@selector(clickCancelButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.cancelbutton];
        
        self.donebutton = [[UIButton alloc] init];
        [self.donebutton setTitle:@"确定" forState:(UIControlStateNormal)];
        self.donebutton.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.donebutton addTarget:self action:@selector(clickDoneButton) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:self.donebutton];
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:(UITableViewStylePlain)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.allowsSelection = YES;
        self.tableView.allowsMultipleSelection = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        
        self.playerView = [[UIView alloc] init];
        [self addSubview:self.playerView];
        
        self.decibelView = [[QNMusicDecibelView alloc] init];
        [self.playerView addSubview:self.decibelView];
        
        [self.cancelbutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.size.equalTo(CGSizeMake(60, 44));
        }];
        
        [self.donebutton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(self);
            make.size.equalTo(CGSizeMake(60, 44));
        }];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.cancelbutton.mas_right);
            make.right.equalTo(self.donebutton.mas_left);
            make.top.equalTo(self);
            make.bottom.equalTo(self.cancelbutton);
        }];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.cancelbutton.mas_bottom);
            make.bottom.equalTo(self.playerView.mas_top);
        }];
        
        CGFloat height = 65;
        if (iPhoneX_SERIES) {
            height = 95;
        }
        
        [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_bottom);
            make.height.equalTo(height);
        }];
        
        [self.decibelView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.playerView).offset(self.edgeSpace);
            make.right.equalTo(self.playerView).offset(-self.edgeSpace);
            make.top.equalTo(self.playerView);
            make.height.equalTo(self.dbViewHeight);
        }];
        
        [self initBorder];
        [self loadMusic];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self addRoundedCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) withRadii:CGSizeMake(10, 10) viewRect:self.bounds];
}

#pragma mark - load music

- (void)loadMusic {
    self.musicArray = [[NSMutableArray alloc] init];
    if (self.haveNULLModel) {
        QNMusicModel *model = [[QNMusicModel alloc] init];
        model.musicURL = nil;
        model.musicName = @"无音乐";
        model.duration = kCMTimeZero;
        self.selectRow = 0;
        self.selectedModel = model;
        [self.musicArray addObject:model];
        self.cancelbutton.hidden = YES;
    } else {
        self.selectRow = -1;
    }
    
    NSString *bundlePath = [NSBundle mainBundle].bundlePath;
    bundlePath = [bundlePath stringByAppendingPathComponent:@"audio.bundle"];
    NSString *jsonPath = [bundlePath stringByAppendingPathComponent:@"short_audio.json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error;
    NSDictionary *dicFromJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    NSArray *array = [dicFromJson objectForKey:@"short_audio"];
    
    for (NSDictionary *dic in array) {
        NSString *name = dic[@"name"];
        CGFloat duration = [dic[@"duration"] floatValue];
        
        QNMusicModel *model = [[QNMusicModel alloc] init];
        NSString *path = [bundlePath stringByAppendingPathComponent:[name stringByAppendingString:@".mp3"]];
        model.musicURL = [NSURL fileURLWithPath:path];
        model.musicName = name;
        model.duration = CMTimeMake(1000000 * duration, 1000000);

        [self.musicArray addObject:model];
    }
    
    MPMediaQuery *query = [MPMediaQuery songsQuery];
    for (MPMediaItemCollection *conllection in query.collections) {
        for (MPMediaItem *mediaItem in conllection.items) {
            NSURL *url = [mediaItem valueForProperty:MPMediaItemPropertyAssetURL];
            if (!url) continue;
            
            QNMusicModel *model = [[QNMusicModel alloc] init];
            model.musicURL = url;
            model.musicName = mediaItem.title;
            model.duration = CMTimeMake(1000000 * mediaItem.playbackDuration, 1000000);
            [self.musicArray addObject:model];
        }
        [self.tableView reloadData];
    }
}

#pragma mark - init border

- (void)initBorder{
    UIView *topLineView  = [[UIView alloc] init];
    UIView *bottomLineView = [[UIView alloc] init];
    topLineView.backgroundColor  = QN_MAIN_COLOR;
    bottomLineView.backgroundColor = QN_MAIN_COLOR;
    
    self.leftPanView    = [[QNPanImageView alloc]init];
    self.rightPanView   = [[QNPanImageView alloc]init];
    self.leftPanView.clipsToBounds  = YES;
    self.rightPanView.clipsToBounds = YES;
    self.leftPanView.userInteractionEnabled = YES;
    self.rightPanView.userInteractionEnabled = YES;
    UIImage *panImage = [UIImage imageNamed:@"qn_video_pan"];
    self.leftPanView.image  = panImage;
    self.rightPanView.image = panImage;
    UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.leftPanView addGestureRecognizer:panGesture];
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self.rightPanView addGestureRecognizer:panGesture];
    
    self.positionLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qn_btn_cut_line"]];
    
    UIView* superView = self.playerView;
    
    [superView addSubview:self.positionLineView];
    [superView addSubview:topLineView];
    [superView addSubview:bottomLineView];
    [superView addSubview:self.leftPanView];
    [superView addSubview:self.rightPanView];
    
    [topLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftPanView.mas_right);
        make.right.equalTo(self.rightPanView.mas_left);
        make.height.equalTo(3);
        make.top.equalTo(self.decibelView);
    }];
    
    [bottomLineView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftPanView.mas_right);
        make.right.equalTo(self.rightPanView.mas_left);
        make.height.equalTo(3);
        make.bottom.equalTo(self.decibelView);
    }];
    
    self.leftPanView.frame  = CGRectMake(self.edgeSpace - panImage.size.width, self.decibelView.frame.origin.y, panImage.size.width, self.dbViewHeight);
    self.rightPanView.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - self.edgeSpace, self.decibelView.frame.origin.y, panImage.size.width, self.dbViewHeight);
    self.positionLineView.frame = CGRectMake(self.edgeSpace, self.decibelView.frame.origin.y, 4, self.dbViewHeight);
    
    self.leftLabel = [[UILabel alloc] init];
    self.leftLabel.textColor = [UIColor lightTextColor];
    self.leftLabel.textAlignment = NSTextAlignmentCenter;
    self.leftLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.textColor = [UIColor lightTextColor];
    self.rightLabel.textAlignment = NSTextAlignmentCenter;
    self.rightLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    self.centerLabel = [[UILabel alloc] init];
    self.centerLabel.textColor = [UIColor lightTextColor];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.centerLabel.font = [UIFont monospacedDigitSystemFontOfSize:12 weight:(UIFontWeightRegular)];
    
    [superView addSubview:self.leftLabel];
    [superView addSubview:self.rightLabel];
    [superView addSubview:self.centerLabel];
    
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.decibelView);
        make.top.equalTo(self.decibelView.mas_bottom).offset(5);
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.decibelView);
        make.top.equalTo(self.decibelView.mas_bottom).offset(5);
    }];
    [self.centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decibelView);
        make.top.equalTo(self.decibelView.mas_bottom).offset(5);
    }];
}

#pragma mark - button action

- (void)clickCancelButton {
    if ([self.delegate respondsToSelector:@selector(musicViewCancelButtonClick:)]) {
        [self.delegate musicViewCancelButtonClick:self];
    }
}

- (void)clickDoneButton {
    if ([self.delegate respondsToSelector:@selector(musicPickerView:didEndPickerWithMusic:)]) {
        [self.delegate musicPickerView:self didEndPickerWithMusic:self.selectedModel];
    }
}

#pragma mark - show/hide player view

- (void)showPlayerView {
    if (self.playerView.frame.origin.y >= self.bounds.size.height) {
        [self.playerView autoLayoutBottomShow:YES];
    }
}

- (void)hidePlayerView {
    if (self.playerView.frame.origin.y < self.bounds.size.height) {
        [self.playerView autoLayoutBottomHide:YES];
    }
}

#pragma mark - format time string

- (NSString *)formatTimeString:(NSTimeInterval)time {
    int intValue = round(time);
    int min = intValue / 60;
    int second = intValue % 60;
    return [NSString stringWithFormat:@"%02d:%02d", min, second];
}

#pragma mark - UITableView delegate

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleValue1) reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }

    QNMusicModel *model = self.musicArray[indexPath.row];
    cell.textLabel.text = model.musicName;
    cell.detailTextLabel.text = [self formatTimeString:CMTimeGetSeconds(model.duration)];

    if (indexPath.row == self.selectRow) {
        cell.textLabel.textColor = QN_MAIN_COLOR;
        cell.detailTextLabel.textColor = QN_MAIN_COLOR;
    } else {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.selectRow) return;
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectRow inSection:indexPath.section]];
    if (oldCell) {
        oldCell.textLabel.textColor = [UIColor whiteColor];
        oldCell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    self.selectRow = indexPath.row;
    cell.textLabel.textColor = QN_MAIN_COLOR;
    cell.detailTextLabel.textColor = QN_MAIN_COLOR;

    self.selectedModel = self.musicArray[indexPath.row];
    if (self.selectedModel.musicURL) {
        self.selectedModel.startTime = kCMTimeZero;
        self.selectedModel.endTime = self.selectedModel.duration;
        self.leftLabel.text = @"0s";
        self.centerLabel.text = @"滑动滑块选取时间段";
        self.rightLabel.text = [NSString stringWithFormat:@"%0.1f", CMTimeGetSeconds(self.selectedModel.duration)];
        
        CGRect rc = self.leftPanView.frame;
        rc.origin.x = self.edgeSpace - rc.size.width;
        self.leftPanView.frame = rc;
        rc.origin.x = self.decibelView.frame.origin.x + self.decibelView.frame.size.width;
        self.rightPanView.frame = rc;
        
        CGFloat minDuration = MIN(self.minMusicSelectDuration, CMTimeGetSeconds(self.selectedModel.duration));
        self.minAvalibeWidth = self.decibelView.bounds.size.width * minDuration / CMTimeGetSeconds(self.selectedModel.duration);
        
        [self.decibelView setNeedsDisplay];
        
        [self showPlayerView];
        
    } else {
        [self hidePlayerView];
    }
    [self updatePlayer];
}


- (void)setCurrentTime:(CMTime)currentTime {
    CGFloat position = [self positionWithTime:currentTime];
    self.positionLineView.center = CGPointMake(position, self.positionLineView.center.y);
}

- (CGFloat)mostLeftX{
    return self.decibelView.frame.origin.x - self.leftPanView.frame.size.width;
}

- (CGFloat)mostRightX{
    return self.decibelView.frame.origin.x + self.decibelView.frame.size.width;
}

- (CMTime)timeWithPosition:(CGFloat)x {
    CMTime duration = self.selectedModel.duration;
    int64_t value = (MAX((x - self.decibelView.frame.origin.x), 0) / self.decibelView.frame.size.width ) * duration.value;
    duration.value = MIN(duration.value, value);
    return duration;
}

- (CGFloat)positionWithTime:(CMTime)time {
    
    CGFloat positionTime = CMTimeGetSeconds(time);
    CGFloat duration = CMTimeGetSeconds(self.selectedModel.duration);
    
    CGFloat percent = MIN(1, MAX(0, positionTime / duration));
    
    return self.decibelView.frame.origin.x + percent * self.decibelView.frame.size.width;
}

- (void)updateLabelText {
    self.leftLabel.text = [NSString stringWithFormat:@"%0.1fs", CMTimeGetSeconds(self.selectedModel.startTime)];
    self.rightLabel.text = [NSString stringWithFormat:@"%0.1fs", CMTimeGetSeconds(self.selectedModel.endTime)];
    self.centerLabel.text = [NSString stringWithFormat:@"已选取 %0.1fs", CMTimeGetSeconds(CMTimeSubtract(self.selectedModel.endTime, self.selectedModel.startTime))];
}

#pragma mark - 手势事件

- (void)panGestureAction:(UIPanGestureRecognizer*)gesture{
    self.positionLineView.hidden = YES;
    BOOL needFeedback = NO;
    
    CGPoint point = [gesture translationInView:gesture.view.superview];
    if (gesture.view == self.leftPanView) {
        
        switch (gesture.state) {
            
            case UIGestureRecognizerStateBegan:{
                self.positionLineView.hidden = YES;
                if (@available(iOS 10.0, *)) {
                    self.feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
                    [self.feedback prepare];
                }
                [self.audioPlayer stop];
                self.isPanning = YES;
            }
            break;
            
            case UIGestureRecognizerStateChanged:{
                
                CGFloat lOriginX = self.leftPanView.frame.origin.x;
                CGFloat rOriginX = self.rightPanView.frame.origin.x;
                
                lOriginX += point.x;
                
                if (lOriginX < self.mostLeftX) {
                    lOriginX = self.mostLeftX;
                    needFeedback = YES;
                }
                
                if (lOriginX + self.leftPanView.frame.size.width + self.minAvalibeWidth > rOriginX) {
                    lOriginX = rOriginX - self.minAvalibeWidth - self.leftPanView.frame.size.width;
                    needFeedback = YES;
                }
                
                self.leftPanView.center = CGPointMake(lOriginX + self.leftPanView.bounds.size.width / 2, self.leftPanView.center.y);
                CMTime time = [self timeWithPosition:lOriginX + self.leftPanView.bounds.size.width];
                
                self.selectedModel.startTime =  time;
            }
            break;
            
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                CGRect rc = self.positionLineView.frame;
                rc.origin.x = self.leftPanView.frame.origin.x + self.leftPanView.frame.size.width;
                self.positionLineView.frame = rc;
                self.positionLineView.hidden = NO;
                self.feedback = nil;
                self.isPanning = NO;
                
                self.audioPlayer.currentTime = CMTimeGetSeconds(self.selectedModel.startTime);
                [self.audioPlayer play];
                
            }
            break;
            
            default:
            break;
        }
        
    } else if (gesture.view == self.rightPanView) {
        
        switch (gesture.state) {
            case UIGestureRecognizerStateBegan:{
                self.positionLineView.hidden = YES;
                if (@available(iOS 10.0, *)) {
                    self.feedback = [[UIImpactFeedbackGenerator alloc] initWithStyle:(UIImpactFeedbackStyleMedium)];
                    [self.feedback prepare];
                }
                [self.audioPlayer stop];
                self.isPanning = YES;
            }
            break;
            
            case UIGestureRecognizerStateChanged:{
                
                CGFloat lOriginX = self.leftPanView.frame.origin.x;
                CGFloat rOriginX = self.rightPanView.frame.origin.x;
                
                rOriginX += point.x;
                
                if (rOriginX > self.mostRightX) {
                    rOriginX = self.mostRightX;
                    needFeedback = YES;
                }
                
                if (lOriginX + self.leftPanView.frame.size.width + self.minAvalibeWidth > rOriginX) {
                    rOriginX = lOriginX + self.leftPanView.frame.size.width + self.minAvalibeWidth;
                    needFeedback = YES;
                }
                
                CGPoint center = self.rightPanView.center;
                self.rightPanView.center = CGPointMake(rOriginX + self.rightPanView.bounds.size.width / 2, center.y);
                
                self.selectedModel.endTime = [self timeWithPosition:rOriginX];
            }
            break;
            
            case UIGestureRecognizerStateFailed:
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:{
                CGRect rc = self.positionLineView.frame;
                rc.origin.x = self.leftPanView.frame.origin.x + self.leftPanView.frame.size.width;
                self.positionLineView.frame = rc;
                self.positionLineView.hidden = NO;
                self.feedback = nil;
                self.isPanning = NO;
                
                [self.audioPlayer setCurrentTime:CMTimeGetSeconds(self.selectedModel.startTime)];
                [self.audioPlayer play];
            }
            break;
            
            default:
            break;
        }
    }
    
    [self updateLabelText];
    [gesture setTranslation:CGPointMake(0, 0) inView:gesture.view.superview];
    if (needFeedback) {
        [self.feedback impactOccurred];
        
        // 强行结束手势
        [gesture setEnabled:NO];
        [gesture setEnabled:YES];
    }
}

#pragma mark - timer

- (void)startTimer{
    if (self.timer) return;
    
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer timerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            if (weakSelf.isPanning) return;
            
            [weakSelf setCurrentTime:CMTimeMake(weakSelf.audioPlayer.currentTime * 1000000, 1000000)];
            
            if (weakSelf.audioPlayer.currentTime >= CMTimeGetSeconds(weakSelf.selectedModel.endTime)) {
                [weakSelf.audioPlayer setCurrentTime:CMTimeGetSeconds(weakSelf.selectedModel.startTime)];
            }
        }];
    } else {
        // Fallback on earlier versions
        
        self.timer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(updateAudioPlayer:) userInfo:nil repeats:YES];
    }
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateAudioPlayer:(NSTimer *)timer {
    if (self.isPanning) return;
    
    [self setCurrentTime:CMTimeMake(self.audioPlayer.currentTime * 1000000, 1000000)];
    
    if (self.audioPlayer.currentTime >= CMTimeGetSeconds(self.selectedModel.endTime)) {
        [self.audioPlayer setCurrentTime:CMTimeGetSeconds(self.selectedModel.startTime)];
    }
}

#pragma mark - player

- (void)updatePlayer {
    [self.audioPlayer pause];
    
    if (self.selectedModel.musicURL) {
        [self startAudioPlay];
    } else {
        [self stopAudioPlay];
    }
}

- (void)startAudioPlay {
    if (self.selectedModel.musicURL) {
        NSLog(@"startAudioPlay ====");
        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:self.selectedModel.musicURL error:nil];
        self.audioPlayer.delegate = self;
        self.audioPlayer.numberOfLoops = -1;
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer setCurrentTime:CMTimeGetSeconds(self.selectedModel.startTime)];
        [self.audioPlayer play];
        
        // 预防 josn 文件中的时长错误
        if (fabs(self.audioPlayer.duration - CMTimeGetSeconds(self.selectedModel.duration)) > FLT_EPSILON) {
            self.selectedModel.duration = CMTimeMake(self.audioPlayer.duration * 1000000, 1000000);
            if (CMTimeCompare(self.selectedModel.endTime, self.selectedModel.duration) > 0 ) {
                self.selectedModel.endTime = self.selectedModel.duration;
            }
        }
        
        [self startTimer];
    }
}

- (void)stopAudioPlay {
    [self.audioPlayer stop];
    self.audioPlayer = nil;
    [self stopTimer];
    NSLog(@"=== stopAudioPlay");
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.audioPlayer setCurrentTime:CMTimeGetSeconds(self.selectedModel.startTime)];
    [self.audioPlayer play];
}

- (void)destoryAudioPlayer {
    [self stopTimer];
    [self.audioPlayer  stop];
    self.audioPlayer.delegate = nil;
    self.audioPlayer = nil;
}

- (CGFloat)minViewHeight {
    return 200;
}

@end
