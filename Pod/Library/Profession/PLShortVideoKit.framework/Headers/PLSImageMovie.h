
// 参考 THImageMovie

// 保证加了 MV 特效之后，为了让 MV 彩色层 和 黑白层 视频帧能同步，实现 MV 特效的正常显示

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "PLSRenderEngine.h"
#import "PLSImageMovieWriter.h"

@class PLSImageMovie;
/*! Protocol for getting Movie played callback.
 */
@protocol PLSImageMovieDelegate <NSObject>

- (void)didCompletePlayingMovie;

- (CVPixelBufferRef)ImageMovie:(PLSImageMovie *)ImageMovie didOutputPixelBuffer:(CVPixelBufferRef)pixelBuffer timestamp:(CMTime)timestamp;;

@end

/*! Source object for filtering movies
 */
@interface PLSImageMovie : PLSGPUImageOutput
{
    PLSGPUImageMovieWriter *synchronizedMovieWriter;
    BOOL _audioEncodingIsFinished, _videoEncodingIsFinished;
    CMTime previousFrameTime, processingFrameTime;
    CFAbsoluteTime previousActualFrameTime;
    BOOL keepLooping;
}
@property (readwrite, retain) AVAsset *asset;
@property (readwrite, retain) AVPlayerItem *playerItem;
@property(readwrite, retain) NSURL *url;

/*! This enables the benchmarking mode, which logs out instantaneous and average frame times to the console
 */
@property(readwrite, nonatomic) BOOL runBenchmark;

/*! This determines whether to play back a movie as fast as the frames can be processed, or if the original speed of the movie should be respected. Defaults to NO.
 */
@property(readwrite, nonatomic) BOOL playAtActualSpeed;

/*! This determines whether the video should repeat (loop) at the end and restart from the beginning. Defaults to NO.
 */
@property(readwrite, nonatomic) BOOL shouldRepeat;

/*! This specifies the progress of the process on a scale from 0 to 1.0. A value of 0 means the process has not yet begun, A value of 1.0 means the conversaion is complete.
    This property is not key-value observable.
 */
@property(readonly, nonatomic) float progress;

/*! This is used to send the delete Movie did complete playing alert
 */
@property (readwrite, nonatomic, assign) id <PLSImageMovieDelegate>delegate;

@property (readonly, nonatomic) AVAssetReader *assetReader;
@property (readonly, nonatomic) BOOL audioEncodingIsFinished;
@property (readonly, nonatomic) BOOL videoEncodingIsFinished;

// add by ahx for change MV file frameRate, 2018-09-12
@property (readonly, nonatomic) CMTime lastVideoFrameTime;

/// @name Initialization and teardown
- (id)initWithAsset:(AVAsset *)asset;
- (id)initWithPlayerItem:(AVPlayerItem *)playerItem;
- (id)initWithURL:(NSURL *)url;
- (void)yuvConversionSetup;

/// @name Movie processing
- (void)enableSynchronizedEncodingUsingMovieWriter:(PLSGPUImageMovieWriter *)movieWriter;
- (BOOL)readNextVideoFrameFromOutput:(AVAssetReaderOutput *)readerVideoTrackOutput;
- (BOOL)readNextAudioSampleFromOutput:(AVAssetReaderOutput *)readerAudioTrackOutput;
- (void)startProcessing;
- (void)endProcessing;
- (void)cancelProcessing;
- (void)processMovieFrame:(CMSampleBufferRef)movieSampleBuffer;

//=== NEW METHODS
//@property(readwrite, nonatomic, retain)  PLSImageMovieWriter *audioEncodingTarget;

// comment by ahx, use @selector(renderFrameAtTimeStamp) replace
//- (BOOL)renderNextFrame;

// add for MV by ahx
- (BOOL)renderFrameAtTimeStamp:(CMTime)timeStamp;

@end
