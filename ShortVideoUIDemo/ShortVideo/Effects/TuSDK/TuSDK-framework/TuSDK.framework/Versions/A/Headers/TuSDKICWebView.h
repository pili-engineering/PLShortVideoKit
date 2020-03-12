//
//  TuSDKICWebView.h
//  TuSDK
//
//  Created by Clear Hu on 15/3/21.
//  Copyright (c) 2015年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class TuSDKICWebView;

/**
 *  Web视图委托
 */
@protocol TuSDKICWebViewDelegate <NSObject>
@optional
- (BOOL)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction;
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation;
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error;
- (void)webView:(TuSDKICWebView *)webView updateProgress:(CGFloat)progress;
@end

/**
 *  Web视图
 */
@interface TuSDKICWebView : WKWebView
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
