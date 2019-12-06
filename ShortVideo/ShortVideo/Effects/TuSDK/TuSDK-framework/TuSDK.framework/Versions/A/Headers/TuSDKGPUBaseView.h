//
//  TuSDKGPUBaseView.h
//  TuSDK
//
//  Created by Clear Hu on 16/4/10.
//  Copyright © 2016年 tusdk.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLGPUImage.h"

/**
 *  GPU Base View 
 */
@interface TuSDKGPUBaseView : UIView<SLGPUImageInput>
{
    SLGLProgram *displayProgram;
    CGSize inputImageSize;
    LSQGPUImageRotationMode inputRotation;
    // 线程同步时使用的全局变量 (避免在分线程中使用bounds引起log警告)
    CGRect viewBounds;
}

/** This calculates the current display size, in pixels, taking into account Retina scaling factors
 */
@property(readonly, nonatomic) CGSize sizeInPixels;
@property(nonatomic) BOOL enabled;

+ (const GLfloat *)textureCoordinatesForRotation:(LSQGPUImageRotationMode)rotationMode;
- (void)setFragmentShader:(NSString *)fragmentShader;
- (void)setVertexShader:(NSString *)vertexShader fragmentShader:(NSString *)fragmentShader;

- (void)renderToDisplayWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;

/** Handling fill mode
 
 @param redComponent Red component for background color
 @param greenComponent Green component for background color
 @param blueComponent Blue component for background color
 @param alphaComponent Alpha component for background color
 */
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;

- (void)setCurrentlyReceivingMonochromeInput:(BOOL)newValue;

- (void)lsqInitView;

- (void)recalculateViewGeometry;
- (void)createDisplayFramebuffer;
@end
