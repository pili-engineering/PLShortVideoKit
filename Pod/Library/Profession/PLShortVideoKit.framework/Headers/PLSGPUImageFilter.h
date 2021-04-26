#import "PLSGPUImageOutput.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SHADER_STRING(text) @ STRINGIZE2(text)

#define PLSGPUImageHashIdentifier #
#define PLSGPUImageWrappedLabel(x) x
#define PLSGPUImageEscapedHashIdentifier(a) PLSGPUImageWrappedLabel(PLSGPUImageHashIdentifier)a

extern NSString *const kPLSGPUImageVertexShaderString;
extern NSString *const kPLSGPUImagePassthroughFragmentShaderString;

struct PLSGPUVector4 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
    GLfloat four;
};
typedef struct PLSGPUVector4 PLSGPUVector4;

struct PLSGPUVector3 {
    GLfloat one;
    GLfloat two;
    GLfloat three;
};
typedef struct PLSGPUVector3 PLSGPUVector3;

struct PLSGPUMatrix4x4 {
    PLSGPUVector4 one;
    PLSGPUVector4 two;
    PLSGPUVector4 three;
    PLSGPUVector4 four;
};
typedef struct PLSGPUMatrix4x4 PLSGPUMatrix4x4;

struct PLSGPUMatrix3x3 {
    PLSGPUVector3 one;
    PLSGPUVector3 two;
    PLSGPUVector3 three;
};
typedef struct PLSGPUMatrix3x3 PLSGPUMatrix3x3;

/*! PLSGPUImage's base filter class
 
 Filters and other subsequent elements in the chain conform to the PLSGPUImageInput protocol, which lets them take in the supplied or processed texture from the previous link in the chain and do something with it. Objects one step further down the chain are considered targets, and processing can be branched by adding multiple targets to a single output or filter.
 */
@interface PLSGPUImageFilter : PLSGPUImageOutput <PLSGPUImageInput>
{
    PLSGPUImageFramebuffer *firstInputFramebuffer;
    
    PLSGLProgram *filterProgram;
    GLint filterPositionAttribute, filterTextureCoordinateAttribute;
    GLint filterInputTextureUniform;
    GLfloat backgroundColorRed, backgroundColorGreen, backgroundColorBlue, backgroundColorAlpha;
    
    BOOL isEndProcessing;

    CGSize currentFilterSize;
    PLSGPUImageRotationMode inputRotation;
    
    BOOL currentlyReceivingMonochromeInput;
    
    NSMutableDictionary *uniformStateRestorationBlocks;
    dispatch_semaphore_t imageCaptureSemaphore;
}

@property(readonly) CVPixelBufferRef renderTarget;
@property(readwrite, nonatomic) BOOL preventRendering;
@property(readwrite, nonatomic) BOOL currentlyReceivingMonochromeInput;

/// @name Initialization and teardown

/*!
 Initialize with vertex and fragment shaders
 
 You make take advantage of the SHADER_STRING macro to write your shaders in-line.
 @param vertexShaderString Source code of the vertex shader to use
 @param fragmentShaderString Source code of the fragment shader to use
 */
- (id)initWithVertexShaderFromString:(NSString *)vertexShaderString fragmentShaderFromString:(NSString *)fragmentShaderString;

/*!
 Initialize with a fragment shader
 
 You may take advantage of the SHADER_STRING macro to write your shader in-line.
 @param fragmentShaderString Source code of fragment shader to use
 */
- (id)initWithFragmentShaderFromString:(NSString *)fragmentShaderString;
/*!
 Initialize with a fragment shader
 @param fragmentShaderFilename Filename of fragment shader to load
 */
- (id)initWithFragmentShaderFromFile:(NSString *)fragmentShaderFilename;
- (void)initializeAttributes;
- (void)setupFilterForSize:(CGSize)filterFrameSize;
- (CGSize)rotatedSize:(CGSize)sizeToRotate forIndex:(NSInteger)textureIndex;
- (CGPoint)rotatedPoint:(CGPoint)pointToRotate forRotation:(PLSGPUImageRotationMode)rotation;

/// @name Managing the display FBOs
/*! Size of the frame buffer object
 */
- (CGSize)sizeOfFBO;

/// @name Rendering
+ (const GLfloat *)textureCoordinatesForRotation:(PLSGPUImageRotationMode)rotationMode;
- (void)renderToTextureWithVertices:(const GLfloat *)vertices textureCoordinates:(const GLfloat *)textureCoordinates;
- (void)informTargetsAboutNewFrameAtTime:(CMTime)frameTime;
- (CGSize)outputFrameSize;

/// @name Input parameters
- (void)setBackgroundColorRed:(GLfloat)redComponent green:(GLfloat)greenComponent blue:(GLfloat)blueComponent alpha:(GLfloat)alphaComponent;
- (void)setInteger:(GLint)newInteger forUniformName:(NSString *)uniformName;
- (void)setFloat:(GLfloat)newFloat forUniformName:(NSString *)uniformName;
- (void)setSize:(CGSize)newSize forUniformName:(NSString *)uniformName;
- (void)setPoint:(CGPoint)newPoint forUniformName:(NSString *)uniformName;
- (void)setFloatVec3:(PLSGPUVector3)newVec3 forUniformName:(NSString *)uniformName;
- (void)setFloatVec4:(PLSGPUVector4)newVec4 forUniform:(NSString *)uniformName;
- (void)setFloatArray:(GLfloat *)array length:(GLsizei)count forUniform:(NSString*)uniformName;

- (void)setMatrix3f:(PLSGPUMatrix3x3)matrix forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setMatrix4f:(PLSGPUMatrix4x4)matrix forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setFloat:(GLfloat)floatValue forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setPoint:(CGPoint)pointValue forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setSize:(CGSize)sizeValue forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setVec3:(PLSGPUVector3)vectorValue forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setVec4:(PLSGPUVector4)vectorValue forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setFloatArray:(GLfloat *)arrayValue length:(GLsizei)arrayLength forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;
- (void)setInteger:(GLint)intValue forUniform:(GLint)uniform program:(PLSGLProgram *)shaderProgram;

- (void)setAndExecuteUniformStateCallbackAtIndex:(GLint)uniform forProgram:(PLSGLProgram *)shaderProgram toBlock:(dispatch_block_t)uniformStateBlock;
- (void)setUniformsForProgramAtIndex:(NSUInteger)programIndex;

@end
