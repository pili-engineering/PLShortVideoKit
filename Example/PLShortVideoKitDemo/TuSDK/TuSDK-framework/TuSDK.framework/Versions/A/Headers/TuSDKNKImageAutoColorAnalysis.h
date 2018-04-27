//
//  TuSDKNKImageAutoColorAnalysis.h
//  TuSDK
//
//  Created by Clear Hu on 16/1/30.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKNKImageAnalysis.h"

/**
 * Image Auto Color Analysis Block
 *
 *  @param result  Image output Object
 *  @param type    Image Analysis processed type
 */
typedef void (^TuSDKNKImageAutoColorAnalysisBlock)(UIImage* result, lsqImageAnalysisType type);

/**
 * Image Auto Color Analysis Copy Block
 *
 *  @param file  Image output file path Object
 */
typedef void (^TuSDKNKImageAutoColorAnalysisCopyBlock)(NSString* file);

/**
 *  Image Auto Color Analysis
 */
@interface TuSDKNKImageAutoColorAnalysis : NSObject
/**
 *  Reset if need Analysis again
 */
- (void) reset;

/**
 *  analysis and procee auto color with image
 *
 *  @param image Image Object
 *  @param block Image Auto Color Analysis Block
 */
- (void)analysisWithImage:(UIImage *)image block:(TuSDKNKImageAutoColorAnalysisBlock)block;

/**
 *  copy Analysis to input image file, need run analysisWithImage:block first
 *
 *  @param inputFile  input image file path
 *  @param outputFile output image file path
 *  @param block      Image Auto Color Analysis Copy Block
 */
- (void)copyAnalysisWithInput:(NSString *)inputFile output:(NSString *)outputFile block:(TuSDKNKImageAutoColorAnalysisCopyBlock)block;

/**
 *  analysis and procee auto color with Thumb and image file
 *
 *  @param thumb      Image Thumb Object
 *  @param input      input image file path
 *  @param output     output image file path
 *  @param thumbBlock Image Auto Color Analysis Block
 *  @param copyBlock  Image Auto Color Analysis Copy Block
 */
- (void)analysisWithThumb:(UIImage *)thumb
                    input:(NSString *)input
                   output:(NSString *)output
               thumbBlock:(TuSDKNKImageAutoColorAnalysisBlock)thumbBlock
                copyBlock:(TuSDKNKImageAutoColorAnalysisCopyBlock)copyBlock;
@end
