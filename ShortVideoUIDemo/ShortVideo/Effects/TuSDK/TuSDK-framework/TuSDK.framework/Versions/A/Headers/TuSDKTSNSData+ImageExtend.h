//
//  TuSDKTSNSData+ImageExtend.h
//  TuSDK
//
//  Created by Clear Hu on 15/2/3.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  图片数据解析
 */
@interface NSData(TuSDKTSNSDataImageExtend)
/**
 *  解析为图片
 *
 *  @return 返回图片对象
 */
- (UIImage *)lsqDecodedToImage;

@end
