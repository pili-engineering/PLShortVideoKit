//
//  TuSDKNKImageAnalysis.h
//  TuSDK
//
//  Created by Clear Hu on 16/1/30.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TuSDKDataJson.h"

#pragma mark - TuSDKNKImageColorArgument
/**
 *  Image analysis color arguments
 */
@interface TuSDKNKImageColorArgument : TuSDKDataJson
@property (nonatomic) float maxR;
@property (nonatomic) float maxG;
@property (nonatomic) float maxB;
@property (nonatomic) float maxY;
@property (nonatomic) float minR;
@property (nonatomic) float minG;
@property (nonatomic) float minB;
@property (nonatomic) float minY;
@property (nonatomic) float midR;
@property (nonatomic) float midG;
@property (nonatomic) float midB;
@end

#pragma mark - TuSDKNKFaceArgument
/**
 *  Face arguments
 */
@interface TuSDKNKFaceArgument : TuSDKDataJson
@property (nonatomic) NSString *identify;
@property (nonatomic) NSString *bin;
@property (nonatomic) CGRect rect;
@property (nonatomic) CGPoint contourLeft1;
@property (nonatomic) CGPoint contourLeft2;
@property (nonatomic) CGPoint contourLeft3;
@property (nonatomic) CGPoint contourLeft4;
@property (nonatomic) CGPoint contourLeft5;
@property (nonatomic) CGPoint contourLeft6;
@property (nonatomic) CGPoint contourLeft7;
@property (nonatomic) CGPoint contourLeft8;
@property (nonatomic) CGPoint contourChin;
@property (nonatomic) CGPoint contourRight1;
@property (nonatomic) CGPoint contourRight2;
@property (nonatomic) CGPoint contourRight3;
@property (nonatomic) CGPoint contourRight4;
@property (nonatomic) CGPoint contourRight5;
@property (nonatomic) CGPoint contourRight6;
@property (nonatomic) CGPoint contourRight7;
@property (nonatomic) CGPoint contourRight8;
@property (nonatomic) CGPoint leftBrowLeftCorner;
@property (nonatomic) CGPoint leftBrowLeftQuarter;
@property (nonatomic) CGPoint leftBrowMiddle;
@property (nonatomic) CGPoint leftBrowRightQuarter;
@property (nonatomic) CGPoint leftBrowRightCorner;
@property (nonatomic) CGPoint rightBrowLeftCorner;
@property (nonatomic) CGPoint rightBrowLeftQuarter;
@property (nonatomic) CGPoint rightBrowMiddle;
@property (nonatomic) CGPoint rightBrowRightQuarter;
@property (nonatomic) CGPoint rightBrowRightCorner;
@property (nonatomic) CGPoint noseTop;
@property (nonatomic) CGPoint noseUpperMiddle;
@property (nonatomic) CGPoint noseLowerMiddle;
@property (nonatomic) CGPoint noseBottom;
@property (nonatomic) CGPoint noseContourLeftCorner;
@property (nonatomic) CGPoint noseContourLeftQuarter;
@property (nonatomic) CGPoint noseContourMiddle;
@property (nonatomic) CGPoint noseContourRightQuarter;
@property (nonatomic) CGPoint noseContourRightCorner;
@property (nonatomic) CGPoint leftEyeLeftCorner;
@property (nonatomic) CGPoint leftEyeTopLeft;
@property (nonatomic) CGPoint leftEyeTopRight;
@property (nonatomic) CGPoint leftEyeRightCorner;
@property (nonatomic) CGPoint leftEyeBottomRight;
@property (nonatomic) CGPoint leftEyeBottomLeft;
@property (nonatomic) CGPoint rightEyeLeftCorner;
@property (nonatomic) CGPoint rightEyeTopLeft;
@property (nonatomic) CGPoint rightEyeTopRight;
@property (nonatomic) CGPoint rightEyeRightCorner;
@property (nonatomic) CGPoint rightEyeBottomRight;
@property (nonatomic) CGPoint rightEyeBottomLeft;
@property (nonatomic) CGPoint mouthLeftCornerContour;
@property (nonatomic) CGPoint mouthUpperLipContour1;
@property (nonatomic) CGPoint mouthUpperLipContour2;
@property (nonatomic) CGPoint mouthUpperLipContour3;
@property (nonatomic) CGPoint mouthUpperLipContour4;
@property (nonatomic) CGPoint mouthUpperLipContour5;
@property (nonatomic) CGPoint mouthRightCornerContour;
@property (nonatomic) CGPoint mouthLowerLipContour1;
@property (nonatomic) CGPoint mouthLowerLipContour2;
@property (nonatomic) CGPoint mouthLowerLipContour3;
@property (nonatomic) CGPoint mouthLowerLipContour4;
@property (nonatomic) CGPoint mouthLowerLipContour5;
@property (nonatomic) CGPoint mouthLeftCorner;
@property (nonatomic) CGPoint mouthUpperLip1;
@property (nonatomic) CGPoint mouthUpperLip2;
@property (nonatomic) CGPoint mouthUpperLip3;
@property (nonatomic) CGPoint mouthRightCorner;
@property (nonatomic) CGPoint mouthLowerLip1;
@property (nonatomic) CGPoint mouthLowerLip2;
@property (nonatomic) CGPoint mouthLowerLip3;
@end

#pragma mark - TuSDKNKImageAnalysisResult
/**
 *  Image online analysis result
 */
@interface TuSDKNKImageAnalysisResult : TuSDKDataJson
/**
 *  Image analysis color arguments
 */
@property (nonatomic, retain) TuSDKNKImageColorArgument *color;
/**
 *  Face arguments
 */
@property (nonatomic, retain) TuSDKNKFaceArgument *face;
@end

#pragma mark - TuSDKNKImageAnalysis
/**
 *  Image Analysis processed type
 */
typedef NS_ENUM(NSInteger, lsqImageAnalysisType)
{
    /**
     * Unknow
     */
    lsqImageAnalysisTypeUnknow,
    /**
     * Succeed
     */
    lsqImageAnalysisTypeSucceed,
    /**
     * Not Input Image Object
     */
    lsqImageAnalysisTypeNotInputImage,
    /**
     * Service Failed
     */
    lsqImageAnalysisTypeServiceFailed,
};
/**
 * Image Analysis Block
 *
 *  @param result  Image online analysis result
 *  @param type    Image Analysis processed type
 */
typedef void (^TuSDKNKImageAnalysisBlock)(TuSDKNKImageAnalysisResult* result, lsqImageAnalysisType type);
/**
 *  Image online analysis
 */
@interface TuSDKNKImageAnalysis : NSObject
/**
 *  Input Analysis Image
 */
@property (nonatomic, retain) UIImage* image;

/**
 *  analysis image color arguments
 *
 *  @param block Image Analysis Block
 */
- (void)analysisColorWithBlock:(TuSDKNKImageAnalysisBlock)block;

/**
 *  analysis face arguments
 *
 *  @param block Image Analysis Block
 */
- (void)analysisFaceWithBlock:(TuSDKNKImageAnalysisBlock)block params:(id)param;
/**
 *  cancel analysis
 */
- (void)cancel;
@end
