//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_VECTOR_HPP__
#define __EASYAR_VECTOR_HPP__

#include "easyar/types.hpp"

namespace easyar {

/// <summary>
/// record
/// </summary>
struct Vec4F
{
    std::array<float, 4> data;
};

/// <summary>
/// record
/// </summary>
struct Vec3F
{
    std::array<float, 3> data;
};

/// <summary>
/// record
/// </summary>
struct Vec2F
{
    std::array<float, 2> data;
};

/// <summary>
/// record
/// </summary>
struct Vec4I
{
    std::array<int, 4> data;
};

/// <summary>
/// record
/// </summary>
struct Vec2I
{
    std::array<int, 2> data;
};

}

#endif
