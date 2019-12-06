//
//  UIImageView+TuSDKNetworkAdditions.h
//  TuSDK
//
/*
 * This file is part of the TuSDKWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>
#import "TuSDKNetworkImageCache.h"
#import "TuSDKNetworkOperation.h"

typedef NS_OPTIONS(NSUInteger, TuSDKWebImageOptions) {
    /**
     *  位置选项
     */
    TuSDKWebImageUnkown = 0,
    
    /**
     * This flag disables on-disk caching
     */
    TuSDKWebImageCacheMemoryOnly = 1 << 1,
    
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of TuSDKWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
     */
    TuSDKWebImageRefreshCached = 1 << 2,
    
    /**
     *  下载完成时使用动画 (缓存时不使用)
     */
    TuSDKWebImageAnimationDownloadedOnly = 1 << 3,
};

/**
 *  图片加载完成
 *
 *  @param image     加载完成的图片对象
 *  @param error     错误信息
 *  @param cacheType 缓存模式
 *  @param imageURL  图片链接
 */
typedef void(^TuSDKWebImageCompletionBlock)(UIImage *image, NSError *error, TuSDKNetworkImageCacheType cacheType, NSURL *imageURL);

@class TuSDKNetworkEngine;

/**
 *  图片扩展
 */
@interface UIImageView(TuSDKNetworkAdditions)
/**
 *  设置默认网络连接引擎
 *
 *  @param engine 网络连接引擎
 */
+(void) setDefaultEngine:(TuSDKNetworkEngine*) engine;

/**
 * Get the current image URL.
 *
 * Note that because of the limitations of categories this property can get out of sync
 * if you use lsq_setImage: directly.
 */
- (NSURL *)lsq_imageURL;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url The url for the image.
 */
- (void)lsq_setImageWithURL:(NSURL *)url;

/**
 * Set the imageView `image` with an `url` and a placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @see lsq_setImageWithURL:placeholderImage:options:
 */
- (void)lsq_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url         The url for the image.
 * @param placeholder The image to be set initially, until the image request finishes.
 * @param options     The options to use when downloading the image. @see TuSDKWebImageOptions for the possible values.
 */
- (void)lsq_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(TuSDKWebImageOptions)options;

/**
 * Set the imageView `image` with an `url`.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)lsq_setImageWithURL:(NSURL *)url
                  completed:(TuSDKWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)lsq_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                  completed:(TuSDKWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see TuSDKWebImageOptions for the possible values.
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)lsq_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(TuSDKWebImageOptions)options
                  completed:(TuSDKWebImageCompletionBlock)completedBlock;

/**
 * Set the imageView `image` with an `url`, placeholder and custom options.
 *
 * The download is asynchronous and cached.
 *
 * @param url            The url for the image.
 * @param placeholder    The image to be set initially, until the image request finishes.
 * @param options        The options to use when downloading the image. @see TuSDKWebImageOptions for the possible values.
 * @param progressBlock  A block called while image is downloading
 * @param completedBlock A block called when operation has been completed. This block has no return value
 *                       and takes the requested UIImage as first parameter. In case of error the image parameter
 *                       is nil and the second parameter may contain an NSError. The third parameter is a Boolean
 *                       indicating if the image was retrived from the local cache or from the network.
 *                       The fourth parameter is the original image url.
 */
- (void)lsq_setImageWithURL:(NSURL *)url
           placeholderImage:(UIImage *)placeholder
                    options:(TuSDKWebImageOptions)options
                   progress:(LSQNKProgressBlock)progressBlock
                  completed:(TuSDKWebImageCompletionBlock)completedBlock;

/**
 * Cancel the current download
 */
- (void)lsq_cancelCurrentImageLoad;
@end
