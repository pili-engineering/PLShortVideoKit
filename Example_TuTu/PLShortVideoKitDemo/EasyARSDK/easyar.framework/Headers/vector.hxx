//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_VECTOR_HXX__
#define __EASYAR_VECTOR_HXX__

#include "easyar/types.hxx"

namespace easyar {

/// <summary>
/// record
/// </summary>
struct Vec4F
{
    float data[4];

    Vec4F();
    Vec4F(float data_0, float data_1, float data_2, float data_3);
    easyar_Vec4F get_cdata();
};

/// <summary>
/// record
/// </summary>
struct Vec3F
{
    float data[3];

    Vec3F();
    Vec3F(float data_0, float data_1, float data_2);
    easyar_Vec3F get_cdata();
};

/// <summary>
/// record
/// </summary>
struct Vec2F
{
    float data[2];

    Vec2F();
    Vec2F(float data_0, float data_1);
    easyar_Vec2F get_cdata();
};

/// <summary>
/// record
/// </summary>
struct Vec4I
{
    int data[4];

    Vec4I();
    Vec4I(int data_0, int data_1, int data_2, int data_3);
    easyar_Vec4I get_cdata();
};

/// <summary>
/// record
/// </summary>
struct Vec2I
{
    int data[2];

    Vec2I();
    Vec2I(int data_0, int data_1);
    easyar_Vec2I get_cdata();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_VECTOR_HXX__
#define __IMPLEMENTATION_EASYAR_VECTOR_HXX__

namespace easyar {

inline Vec4F::Vec4F()
{
}
inline Vec4F::Vec4F(float data_0, float data_1, float data_2, float data_3)
{
    this->data[0] = data_0;
    this->data[1] = data_1;
    this->data[2] = data_2;
    this->data[3] = data_3;
}
inline easyar_Vec4F Vec4F::get_cdata()
{
    easyar_Vec4F _return_value_ = {data[0], data[1], data[2], data[3]};
    return _return_value_;
}
inline Vec3F::Vec3F()
{
}
inline Vec3F::Vec3F(float data_0, float data_1, float data_2)
{
    this->data[0] = data_0;
    this->data[1] = data_1;
    this->data[2] = data_2;
}
inline easyar_Vec3F Vec3F::get_cdata()
{
    easyar_Vec3F _return_value_ = {data[0], data[1], data[2]};
    return _return_value_;
}
inline Vec2F::Vec2F()
{
}
inline Vec2F::Vec2F(float data_0, float data_1)
{
    this->data[0] = data_0;
    this->data[1] = data_1;
}
inline easyar_Vec2F Vec2F::get_cdata()
{
    easyar_Vec2F _return_value_ = {data[0], data[1]};
    return _return_value_;
}
inline Vec4I::Vec4I()
{
}
inline Vec4I::Vec4I(int data_0, int data_1, int data_2, int data_3)
{
    this->data[0] = data_0;
    this->data[1] = data_1;
    this->data[2] = data_2;
    this->data[3] = data_3;
}
inline easyar_Vec4I Vec4I::get_cdata()
{
    easyar_Vec4I _return_value_ = {data[0], data[1], data[2], data[3]};
    return _return_value_;
}
inline Vec2I::Vec2I()
{
}
inline Vec2I::Vec2I(int data_0, int data_1)
{
    this->data[0] = data_0;
    this->data[1] = data_1;
}
inline easyar_Vec2I Vec2I::get_cdata()
{
    easyar_Vec2I _return_value_ = {data[0], data[1]};
    return _return_value_;
}
}

#endif
