//
//  SceneEffectTools.m
//  TuSDKVideoDemo
//
//  Created by wen on 27/12/2017.
//  Copyright © 2017 TuSDK. All rights reserved.
//

#import "SceneEffectTools.h"

@interface SceneEffectTools(){
    // 是否正在添加新的特效
    BOOL _isAdding;
    // 是否正在重置数组
    BOOL _isResetting;
    // 当前操作进行叠加时间覆盖后的结果数组
    NSMutableArray<TuSDKMediaSceneEffectData *> *_resultArr;
    // 当前使用的特效index
    NSInteger _effectIndex;
    // 当前应展示的特效code
    NSString *_currentCode;
    // 正在添加的特效的开始时间
    CGFloat _addingStartProgress;
    // 正在添加的特效的code
    NSString *_addingEffectCode;
}
@end

@implementation SceneEffectTools

#pragma mark - init method

- (instancetype)init;
{
    if (self = [super init]) {
        [self initData];
    }
    return self;
}

- (void)initData;
{
    _historyArr = [NSMutableArray new];
    _resultArr = [NSMutableArray new];
}

#pragma mark - function method

/**
 开始添加一个场景特效
 
 @param effectCode 特效code
 @param startProgress 特效开始的progress
 */
- (void)addEffectBegin:(NSString *)effectCode withProgress:(CGFloat)startProgress;
{
    _addingStartProgress = startProgress;
    _addingEffectCode = effectCode;
    _isAdding = YES;
}

/**
 结束当前正在添加的一个场景特效 - begin与end 成对出现
 
 @param effectCode 特效code - 需与begin 中的code 一致
 @param endProgress 特效结束的progress
 */
- (void)addEffectEnd:(NSString *)effectCode withProgress:(CGFloat)endProgress;
{
    if (!_isAdding || effectCode != _addingEffectCode) return;
    
    if (endProgress - _addingStartProgress > 0) {
        TuSDKTimeRange *timeRange = [TuSDKTimeRange makeTimeRangeWithStartSeconds:_addingStartProgress*_videoDuration endSeconds:endProgress*_videoDuration];
        TuSDKMediaSceneEffectData *effect = [[TuSDKMediaSceneEffectData alloc]initEffectInfoWithTimeRange:timeRange];
        effect.effectsCode = effectCode;
        [self addNewEffect:effect];
    }
    
    _addingEffectCode = nil;
    _isAdding = NO;
}

/**
 根据传入的progress判断是否需要切换特效
 
 @param currentProgress 当前的progress
 @return 是否需要进行切换 YES：需要进行切换
 */
- (BOOL)needSwitchEffectWithProgress:(CGFloat)currentProgress;
{
    if (_isAdding || _isResetting || _videoDuration == 0) return NO;
    if (currentProgress == 0) _effectIndex = 0;
    if (_effectIndex >= _resultArr.count) return NO;

    // TuSDK mark - 特效切换逻辑中，不包含特效覆盖以及时间叠加的判断，如需要此逻辑，可自行修改
    TuSDKMediaSceneEffectData *effect = _resultArr[_effectIndex];
    
    // 判断是否已开始当前特效，若没有，进行设置
    if (currentProgress >= effect.atTimeRange.startSeconds/_videoDuration && _currentCode != effect.effectsCode) {
        if (effect.isValid) {
            _currentCode = effect.effectsCode;
            return YES;
        }
    }
    
    // 判断是都当前特效已结束，若已结束，切换特效
    if (currentProgress >= effect.atTimeRange.endSeconds/_videoDuration && _currentCode == effect.effectsCode) {
        _effectIndex ++;
        
        if (_effectIndex < _resultArr.count) {
            effect =_resultArr[_effectIndex];
            
            // 判断是否可直接开始下一个特效
            if (currentProgress >= effect.atTimeRange.startSeconds/_videoDuration && effect.isValid){
                _currentCode = effect.effectsCode;
                return YES;
            }else{
                _currentCode = nil;
                return YES;
            }
        }else{
            _currentCode = nil;
            return YES;
        }
    }
    
    return NO;
}

/**
 获取当前应该展示的特效code  -  调用前应使用 needSwitchEffectWithProgress 判断是否需要进行切换
 
 @return 应该展示的特效code
 */
- (NSString *)currentEffectCode;
{
    return _currentCode;
}

/**
 获取最终已完成时间叠加覆盖的有效数组
 */
- (NSArray<TuSDKMediaSceneEffectData *> *)getResultArr;
{
    return _resultArr;
}

/**
 移除上一个添加的特效
 */
- (void)removeLastEffect;
{
    [_historyArr removeLastObject];
    [self resetResultArr];
}

/**
 重置覆盖后的结果数组
 */
- (void)resetResultArr;
{
    _isResetting = YES;
    [_resultArr removeAllObjects];
    for (int i = 0; i < _historyArr.count; i++) {
        [self refreshResultArrWithNewEffect:_historyArr[i]];
    }
    _isResetting = NO;
    [self getResultArr];
}

/**
 想数组中添加一个新的特效设置

 @param newEffect 新加入的特效设置
 */
- (void)addNewEffect:(TuSDKMediaSceneEffectData *)newEffect;
{
    [_historyArr addObject:newEffect];
    [self refreshResultArrWithNewEffect:newEffect];
}

/**
 刷新覆盖后的结果数组
 
 @param effect 新加入的特效设置
 */
- (void)refreshResultArrWithNewEffect:(TuSDKMediaSceneEffectData *)effect;
{
    TuSDKTimeRange *timeRange = [TuSDKTimeRange makeTimeRangeWithStart:effect.atTimeRange.start end:effect.atTimeRange.end];
    TuSDKMediaSceneEffectData *newEffect = [[TuSDKMediaSceneEffectData alloc]initEffectInfoWithTimeRange:timeRange];
    newEffect.effectsCode = effect.effectsCode;
    
    if (_resultArr.count == 0){
        [_resultArr addObject:newEffect];
        return;
    }
    
    NSInteger __block index = 0;
    [_resultArr enumerateObjectsUsingBlock:^(TuSDKMediaSceneEffectData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // 结束循环
        if (CMTIME_COMPARE_INLINE(obj.atTimeRange.start, >=, newEffect.atTimeRange.end)){
            *stop = YES;
        }
        if (CMTIME_COMPARE_INLINE(obj.atTimeRange.end, <=, newEffect.atTimeRange.start)){
            index = idx+1;
        }
        
        // 移除
        if (CMTIME_COMPARE_INLINE(obj.atTimeRange.start, >=, newEffect.atTimeRange.start) &&
            CMTIME_COMPARE_INLINE(obj.atTimeRange.end, <=, newEffect.atTimeRange.end)) {
            [_resultArr removeObject:obj];
            return;
        }
        // 隔开元素
        if (CMTIME_COMPARE_INLINE(obj.atTimeRange.start, <, newEffect.atTimeRange.start) &&
            CMTIME_COMPARE_INLINE(obj.atTimeRange.end, >, newEffect.atTimeRange.end)) {
            
            TuSDKTimeRange *timeRange = [TuSDKTimeRange makeTimeRangeWithStart:newEffect.atTimeRange.end end:obj.atTimeRange.end];
            TuSDKMediaSceneEffectData *nextEffect = [[TuSDKMediaSceneEffectData alloc]initEffectInfoWithTimeRange:timeRange];
            nextEffect.effectsCode = obj.effectsCode;
            obj.atTimeRange.duration = CMTimeSubtract(newEffect.atTimeRange.start, obj.atTimeRange.start) ;
            [_resultArr insertObject:nextEffect atIndex:idx+1];
            index = idx+1;
            return;
        }
        // 修改开始时间
        if (CMTIME_COMPARE_INLINE(obj.atTimeRange.start, >, newEffect.atTimeRange.start) &&
            CMTIME_COMPARE_INLINE(obj.atTimeRange.start, <, newEffect.atTimeRange.end)) {
            obj.atTimeRange.start = newEffect.atTimeRange.end;
            return;
        }
        // 修改结束时间
        if (CMTIME_COMPARE_INLINE(obj.atTimeRange.start, <, newEffect.atTimeRange.start) &&
            CMTIME_COMPARE_INLINE(obj.atTimeRange.end, >, newEffect.atTimeRange.start)) {
            obj.atTimeRange.duration = CMTimeSubtract(newEffect.atTimeRange.start, obj.atTimeRange.start) ;
            index = idx+1;
            return;
        }
    }];
    [_resultArr insertObject:newEffect atIndex:index];
}

@end
