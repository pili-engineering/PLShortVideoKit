//
//  TuSDKICWebView.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/21.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TuSDKICWebView;

/**
 *  Web视图委托
 */
@protocol TuSDKICWebViewDelegate <UIWebViewDelegate>
@optional
- (BOOL)webView:(TuSDKICWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(TuSDKICWebView *)webView;
- (void)webViewDidFinishLoad:(TuSDKICWebView *)webView;
- (void)webView:(TuSDKICWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webView:(TuSDKICWebView *)webView updateProgress:(CGFloat)progress;
@end

/**
 *  Web视图
 */
@interface TuSDKICWebView : UIWebView
{
    // 进度栏
    UIView *_progressBar;
}

/**
 *  Web视图委托
 */
@property (nonatomic, weak) id <TuSDKICWebViewDelegate> delegate;

/**
 *  进度栏
 */
@property (nonatomic, readonly) UIView *progressBar;

/**
 *  当前加载进度 0-1
 */
@property (nonatomic, readonly) CGFloat progress;

/**
 *  加载链接
 *
 *  @param url 链接
 */
- (void)loadUrl:(NSString*)url;
@end
