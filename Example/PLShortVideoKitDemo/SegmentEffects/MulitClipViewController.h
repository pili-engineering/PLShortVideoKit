//
//  MulitClipViewController.h
//  PLShortVideoKitDemo
//
//  Created by hxiongan on 2018/2/1.
//  Copyright © 2018年 Pili Engineering, Qiniu Inc. All rights reserved.
//



@interface MulitClipViewController : BaseViewController

@property (nonatomic, strong)NSMutableArray <PHAsset *> *phAssetArray;
@property (nonatomic, strong)NSMutableArray *urlArray;

@end


//需求:
//1，可以对一个或者多个视频进行同时切割
//2，可以对切割后的效果进行实时预览
//3，可以在段之间插入转场字幕，视频等
//
//切割实现：
//
//  1、逻辑切割问题、如对一个视频A(0~50s)进行分割成三段A1(0~10s),A2(10~30s),A3(30~50s),由于这个操作都只是逻辑的操作,并没有将A视频分成三个视频，但是得给人的感觉是将A分成了三个视频。这个过程可以将 A视频进行三份拷贝，每一份拷贝作为一个分段，对每一段视频在A中的起止位置进行标记。
//
//
//  2、预览和seek问题、对多个视频比如A(0~50s) 和 B(0~30)分别进行切割，分成A1(0~10s),A2(10~30s),A3(30~50s),B1(0~10s),B2(10~30s),
//   用户可以删除任何一段视频比如A2，现在要对剩下的4段视频进行预览和seek。
//   预览可以用AVPlayer，AVMutableComposition继承自AVAsset。因此用AVMutableComposition和AVMutableCompositionTrack将A视频的0~10s(A1),A视频的30~50s(A3),B视频的0~10s(B1)，B视频的10s~30s(B2)加入到AVMutableCompositionTrack中，让这几段视频在一个track中、这样用户在编辑操作中在进行seek的时候，可以准确的seek到需要的位置。
//
//
//  3、iOS设备home键在上、下、左、右四个方向拍摄的视频混合预览的问题，AVMutableCompositionTrack只能在整个时间段中设置一种preferredTransform，如果以某一个方向拍摄视频的transform去设置AVMutableCompositionTrack的transform，那么其他三种视频预览的时候，方向会出现不对的情况，因此不能在AVMutableCompositionTrack的preferredTransform中去处理这个问题。
//      AVPlayerItem中有属性AVMutableVideoComposition，AVMutableVideoComposition可以针对对不同的时间段进行transform操作，因此可以用AVMutableVideoComposition + AVMutableVideoCompositionInstruction + AVMutableVideoCompositionLayerInstruction来解决iOS不同方向拍摄的视频混合在一个track钟预览的方向问题。
//
//
//
//  代码实现思路：
//    开始的时候选择多个视频进行切割，用一个数组保存这些视频，并记下每一个视频的起止时间。当对其中某一个视频进行切割的时候，可以将该视频进行一个复制，然后标记切割之后两段视频的起止时间，然后更新播放器的AVPlayerItem，之后的每一次切割、删除或者插入新的视频，都用类似的方法进行操作。





