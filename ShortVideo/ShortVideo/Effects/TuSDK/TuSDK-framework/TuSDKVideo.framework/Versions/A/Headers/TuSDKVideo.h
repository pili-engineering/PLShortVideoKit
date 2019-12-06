//
//  TuSDKVideo.h
//  TuSDKVideo
//
//  Created by Yanlin on 3/5/16.
//  Copyright © 2016 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TuSDKVideoImport.h"
#import "TuSDKLiveVideoCamera.h"
#import "TuSDKRecordVideoCamera.h"
#import "TuSDKLiveVideoProcessor.h"
#import "TuSDKLiveRTCProcessor.h"
#import "TuSDKVideoFocusTouchView.h"
#import "TuSDKFilterConfigProtocol.h"
#import "TuSDKFilterConfigViewBase.h"
#import "TuSDKVideoResult.h"
#import "TuSDKAudioResult.h"
#import "TuSDKMoiveFragment.h"
#import "TuSDK2DImageFilterWrap.h"


// 视频渲染特效
#import "TuSDKMediaEffectCore.h"
#import "TuSDKMediaAudioEffect.h"
#import "TuSDKMediaStickerAudioEffect.h"
#import "TuSDKMediaParticleEffect.h"
#import "TuSDKMediaSceneEffect.h"
#import "TuSDKMediaTextEffect.h"
#import "TuSDKMediaFilterEffect.h"
#import "TuSDKMediaComicEffect.h"
#import "TuSDKMediaPlasticFaceEffect.h"
#import "TuSDKMediaSkinFaceEffect.h"
#import "TuSDKMediaMonsterFaceEffect.h"
#import "TuSDKMediaStickerImageEffect.h"

// 时间特效
#import "TuSDKMediaTimeEffect.h"
#import "TuSDKMediaSpeedTimeEffect.h"
#import "TuSDKMediaRepeatTimeEffect.h"
#import "TuSDKMediaReverseTimeEffect.h"

// 大片特效
#import "TuSDKMediaPacketShapeEffect.h"
#import "TuSDKMediaPacketFrostedEffect.h"
#import "TuSDKMediaPacketSlowEffect.h"
#import "TuSDKMediaPacketMirrorEffect.h"
#import "TuSDKMediaPacketStoryEffect.h"
#import "TuSDKMediaPacketSpeedEffect.h"

// 转场特效
#import "TuSDKMediaTransitionEffect.h"

// API
#import "TuSDKFilterProcessor.h"
#import "TuSDKMovieEditor.h"
#import "TuSDKMediaMovieFilmEditor.h"
#import "TuSDKMediaMutableAssetMoviePlayer.h"
#import "TuSDKMediaMovieAssetTranscoder.h"
#import "TuSDKMediaSampleBufferAssistant.h"

#import "TuSDKGIFImageEncoder.h"
#import "TuSDKGIFImage.h"

#import "TuSDKAssetVideoComposer.h"
#import "TuSDKTSAudioMixer.h"
#import "TuSDKTSMovieMixer.h"
#import "TuSDKTSMovieSplicer.h"
#import "TuSDKMovieClipper.h"
#import "TuSDKTSAudioRecorder.h"
#import "TuSDKTSMovieCompresser.h"
#import "TuSDKVideoImageExtractor.h"
#import "TuSDKVideoFileWriter.h"

#import "TuSDKMediaAssetInfo.h"
#import "TuSDKMediaTimelineSlice.h"
#import "TuSDKMediaAudioRender.h"
#import "TuSDKMediaVideoRender.h"

#import "TuSDKMediaAssetExportSession.h"
#import "TuSDKMediaMovieAssetExportSession.h"
#import "TuSDKMediaMovieEditorSaver.h"
#import "TuSDKMediaMovieAssetTranscoder.h"
// 音效API

#import "TuSDKAudioPitchEngine.h"
#import "TuSDKAudioResampleEngine.h"

// 音频录制API

#import "TuSDKMediaAudioRecorder.h"
#import "TuSDKMediaAssetAudioRecorder.h"

// 图片视频合成API
#import "TuSDKMediaVideoTrackComposition.h"
#import "TuSDKMediaImageComposition.h"
#import "TuSDKMediaMutableVideoComposition.h"

#import "TuSDKMediaAudioTrackComposition.h"
#import "TuSDKMediaMutableAudioComposition.h"
#import "TuSDKMediaAudioMuteComposition.h"

#import "TuSDKMediaMovieCompositionComposer.h"


#import "TuSDKGPUVideoPixelBufferForTexture.h"
#import "TuSDKAssetVideoTrackPixelBufferOutput.h"
#import "TuSDKMediaAssetExtractor.h"
#import "TuSDKFileWriter.h"
#import "TuSDKAsyncEncodecBridge.h"

/** Video版本号 */
extern NSString * const lsqVideoVersion;

@interface TuSDKVideo : NSObject

@end
