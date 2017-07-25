//
//  KWFilterCell.h
//  KWMediaStreamingKitDemo
//
//  Created by 伍科 on 16/12/7.
//  Copyright © 2016年 0dayZh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWFilterCell : UICollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;

- (void)setName:(NSString *)name andIcon:(UIImage *)image index:(NSInteger)index;

/**
 是否隐藏背景框
 */
-(void)hideBackView:(BOOL)hidden;

@end
