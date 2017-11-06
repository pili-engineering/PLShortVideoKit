//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_MATRIX_HPP__
#define __EASYAR_MATRIX_HPP__

#include "easyar/types.hpp"

namespace easyar {

/// <summary>
/// record
/// </summary>
struct Matrix34F
{
    std::array<float, 12> data;
};

/// <summary>
/// record
/// </summary>
struct Matrix44F
{
    std::array<float, 16> data;
};

}

#endif
