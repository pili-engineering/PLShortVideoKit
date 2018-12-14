//
//  TuSDKVerticeCoordinateBuilder.h
//  TuSDKVideo
//
//  Created by sprint on 04/05/2018.
//  Copyright © 2018 TuSDK. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TuSDKOpenGLAssistant.h"


@protocol TuSDKVerticeCoordinateBuilder

- (void)setOutputSize:(CGSize)outputSize;

- (BOOL)calculate:(CGSize) size orientation:(LSQGPUImageRotationMode) orientation verticesCoordinates:(GLfloat[]) verticesCoordinates textureCoorinates:(GLfloat[])textureBuffer;

@end
