//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_DRAWABLE_HXX__
#define __EASYAR_DRAWABLE_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Drawable
{
protected:
    easyar_Drawable * cdata_ ;
    void init_cdata(easyar_Drawable * cdata);
    virtual Drawable & operator=(const Drawable & data) { return *this; } //deleted
public:
    Drawable(easyar_Drawable * cdata);
    virtual ~Drawable();

    Drawable(const Drawable & data);
    const easyar_Drawable * get_cdata() const;
    easyar_Drawable * get_cdata();

};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_DRAWABLE_HXX__
#define __IMPLEMENTATION_EASYAR_DRAWABLE_HXX__

#include "easyar/drawable.h"

namespace easyar {

inline Drawable::Drawable(easyar_Drawable * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Drawable::~Drawable()
{
    if (cdata_) {
        easyar_Drawable__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Drawable::Drawable(const Drawable & data)
    :
    cdata_(NULL)
{
    easyar_Drawable * cdata = NULL;
    easyar_Drawable__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Drawable * Drawable::get_cdata() const
{
    return cdata_;
}
inline easyar_Drawable * Drawable::get_cdata()
{
    return cdata_;
}
inline void Drawable::init_cdata(easyar_Drawable * cdata)
{
    cdata_ = cdata;
}

}

#endif
