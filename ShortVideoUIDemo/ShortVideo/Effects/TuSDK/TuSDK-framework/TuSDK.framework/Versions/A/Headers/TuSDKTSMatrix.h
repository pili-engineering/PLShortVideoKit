//
//  TuSDKTSMatrix.h
//  TuSDK
//
//  Created by Clear Hu on 2018/1/11.
//  Copyright © 2018年 tusdk.com. All rights reserved.
//

#ifndef TuSDKTSMatrix_h
#define TuSDKTSMatrix_h

#include <stdio.h>

#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif    
    /**
     * Multiplies two 4x4 matrices together and stores the result in a third 4x4
     * matrix. In matrix notation: result = lhs x rhs. Due to the way
     * matrix multiplication works, the result matrix will have the same
     * effect as first multiplying by the rhs matrix, then multiplying by
     * the lhs matrix. This is the opposite of what you might expect.
     * <p>
     * The same float array may be passed for result, lhs, and/or rhs. However,
     * the result element values are undefined if the result elements overlap
     * either the lhs or rhs elements.
     *
     * @param result The float array that holds the result.
     * @param lhs The float array that holds the left-hand-side matrix.
     * @param rhs The float array that holds the right-hand-side matrix.
     *
     */
    void lsqGLMultiplyMM(GLfloat* result, const GLfloat* lhs, const GLfloat* rhs);

    /**
     * Multiplies a 4 element vector by a 4x4 matrix and stores the result in a
     * 4-element column vector. In matrix notation: result = lhs x rhs
     * <p>
     * The same float array may be passed for resultVec, lhsMat, and/or rhsVec.
     * However, the resultVec element values are undefined if the resultVec
     * elements overlap either the lhsMat or rhsVec elements.
     *
     * @param resultVec The float array that holds the result vector.
     * @param lhsMat The float array that holds the left-hand-side matrix.
     * @param rhsVec The float array that holds the right-hand-side vector.
     */
    void lsqGLMultiplyMV(GLfloat* resultVec, const GLfloat* lhsMat,  const GLfloat* rhsVec);
    
    /**
     * Transposes a 4 x 4 matrix.
     * <p>
     * mTrans and m must not overlap.
     *
     * @param result the array that holds the output transposed matrix
     * @param m the input array
     */
    void lsqGLTransposeM(GLfloat* result, const GLfloat* m);
    
    /**
     * Inverts a 4 x 4 matrix.
     * <p>
     * mInv and m must not overlap.
     *
     * @param result the array that holds the output inverted matrix
     * @param m the input array
     * @return true if the matrix could be inverted, false if it could not.
     */
    int lsqGLInvertM(GLfloat* result, const GLfloat* m);
    
    /**
     * Computes an orthographic projection matrix.
     *
     * @param result returns the result
     * @param left
     * @param right
     * @param bottom
     * @param top
     * @param near
     * @param far
     */
    void lsqGLOrthoM(GLfloat* result, float left, float right, float bottom, float top, float near, float far);
    
    /**
     * Defines a projection matrix in terms of six clip planes.
     *
     * @param result the float array that holds the output perspective matrix
     * @param left
     * @param right
     * @param bottom
     * @param top
     * @param near
     * @param far
     */
    void lsqGLFrustumM(GLfloat* result,  float left, float right, float bottom, float top, float near, float far);
    
    /**
     * Defines a projection matrix in terms of a field of view angle, an
     * aspect ratio, and z clip planes.
     *
     * @param result the float array that holds the perspective matrix
     * @param fovy field of view in y direction, in degrees
     * @param aspect width to height aspect ratio of the viewport
     * @param zNear
     * @param zFar
     */
    void lsqGLPerspectiveM(GLfloat* result, float fovy, float aspect, float zNear, float zFar);
    
    /**
     * Computes the length of a vector.
     *
     * @param x x coordinate of a vector
     * @param y y coordinate of a vector
     * @param z z coordinate of a vector
     * @return the length of a vector
     */
    float lsqGLLength(float x, float y, float z);
    
    /**
     * Sets matrix m to the identity matrix.
     *
     * @param sm returns the result
     */
    void lsqGLSetIdentityM(GLfloat* result);
    
    /**
     * Scales matrix m by x, y, and z, putting the result in sm.
     * <p>
     * m and sm must not overlap.
     *
     * @param result returns the result
     * @param m source matrix
     * @param x scale factor x
     * @param y scale factor y
     * @param z scale factor z
     */
    void lsqGLScaleWithM(GLfloat* result, const GLfloat* m, float x, float y, float z);
    
    /**
     * Scales matrix m in place by sx, sy, and sz.
     *
     * @param m matrix to scale
     * @param x scale factor x
     * @param y scale factor y
     * @param z scale factor z
     */
    void lsqGLScaleM(GLfloat* result, float x, float y, float z);
    
    /**
     * Translates matrix m by x, y, and z, putting the result in tm.
     * <p>
     * m and tm must not overlap.
     *
     * @param result returns the result
     * @param m source matrix
     * @param x translation factor x
     * @param y translation factor y
     * @param z translation factor z
     */
    void lsqGLTranslateWithM(GLfloat* result, const GLfloat* m, float x, float y, float z);
    
    /**
     * Translates matrix m by x, y, and z in place.
     *
     * @param result matrix
     * @param x translation factor x
     * @param y translation factor y
     * @param z translation factor z
     */
    void lsqGLTranslateM(GLfloat* result, float x, float y, float z);
    
    /**
     * Creates a matrix for rotation by angle a (in degrees)
     * around the axis (x, y, z).
     * <p>
     * An optimized path will be used for rotation about a major axis
     * (e.g. x=1.0f y=0.0f z=0.0f).
     *
     * @param result returns the result
     * @param a angle to rotate in degrees
     * @param x X axis component
     * @param y Y axis component
     * @param z Z axis component
     */
    void lsqGLSetRotateM(GLfloat* result, float a, float x, float y, float z);
    
    /**
     * Rotates matrix m by angle a (in degrees) around the axis (x, y, z).
     * <p>
     * m and rm must not overlap.
     *
     * @param result returns the result
     * @param m source matrix
     * @param a angle to rotate in degrees
     * @param x X axis component
     * @param y Y axis component
     * @param z Z axis component
     */
    void lsqGLRotateWithM(GLfloat* result, const GLfloat* m, float a, float x, float y, float z);
    
    /**
     * Rotates matrix m in place by angle a (in degrees)
     * around the axis (x, y, z).
     *
     * @param m source matrix
     * @param a angle to rotate in degrees
     * @param x X axis component
     * @param y Y axis component
     * @param z Z axis component
     */
    void lsqGLRotateM(GLfloat* result, float a, float x, float y, float z);
    
    /**
     * Converts Euler angles to a rotation matrix.
     *
     * @param rm returns the result
     * @param x angle of rotation, in degrees
     * @param y angle of rotation, in degrees
     * @param z angle of rotation, in degrees
     */
    void lsqGLSetRotateEulerM(GLfloat* result, float x, float y, float z);
    
    /**
     * Defines a viewing transformation in terms of an eye point, a center of
     * view, and an up vector.
     *
     * @param result returns the result
     * @param eyeX eye point X
     * @param eyeY eye point Y
     * @param eyeZ eye point Z
     * @param centerX center of view X
     * @param centerY center of view Y
     * @param centerZ center of view Z
     * @param upX up vector X
     * @param upY up vector Y
     * @param upZ up vector Z
     */
    void lsqGLSetLookAtM(GLfloat* result,
                         float eyeX, float eyeY, float eyeZ,
                         float centerX, float centerY, float centerZ,
                         float upX, float upY, float upZ);
#ifdef __cplusplus
}
#endif

#endif /* TuSDKTSMatrix_h */
