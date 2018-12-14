//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_RENDERER_HXX__
#define __EASYAR_RENDERER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Renderer
{
protected:
    easyar_Renderer * cdata_ ;
    void init_cdata(easyar_Renderer * cdata);
    virtual Renderer & operator=(const Renderer & data) { return *this; } //deleted
public:
    Renderer(easyar_Renderer * cdata);
    virtual ~Renderer();

    Renderer(const Renderer & data);
    const easyar_Renderer * get_cdata() const;
    easyar_Renderer * get_cdata();

    Renderer();
    void chooseAPI(RendererAPI api);
    void setDevice(void * device);
    bool render(Drawable * frame, Vec4I viewport);
    bool renderToTexture(Drawable * frame, void * texture);
    bool renderErrorMessage(Vec4I viewport);
    bool renderErrorMessageToTexture(void * texture);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_RENDERER_HXX__
#define __IMPLEMENTATION_EASYAR_RENDERER_HXX__

#include "easyar/renderer.h"
#include "easyar/drawable.hxx"
#include "easyar/vector.hxx"

namespace easyar {

inline Renderer::Renderer(easyar_Renderer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Renderer::~Renderer()
{
    if (cdata_) {
        easyar_Renderer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Renderer::Renderer(const Renderer & data)
    :
    cdata_(NULL)
{
    easyar_Renderer * cdata = NULL;
    easyar_Renderer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Renderer * Renderer::get_cdata() const
{
    return cdata_;
}
inline easyar_Renderer * Renderer::get_cdata()
{
    return cdata_;
}
inline void Renderer::init_cdata(easyar_Renderer * cdata)
{
    cdata_ = cdata;
}
inline Renderer::Renderer()
    :
    cdata_(NULL)
{
    easyar_Renderer * _return_value_ = NULL;
    easyar_Renderer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void Renderer::chooseAPI(RendererAPI arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Renderer_chooseAPI(cdata_, static_cast<easyar_RendererAPI>(arg0));
}
inline void Renderer::setDevice(void * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_Renderer_setDevice(cdata_, arg0);
}
inline bool Renderer::render(Drawable * arg0, Vec4I arg1)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_render(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), arg1.get_cdata());
    return _return_value_;
}
inline bool Renderer::renderToTexture(Drawable * arg0, void * arg1)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_renderToTexture(cdata_, (arg0 == NULL ? NULL : arg0->get_cdata()), arg1);
    return _return_value_;
}
inline bool Renderer::renderErrorMessage(Vec4I arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_renderErrorMessage(cdata_, arg0.get_cdata());
    return _return_value_;
}
inline bool Renderer::renderErrorMessageToTexture(void * arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_Renderer_renderErrorMessageToTexture(cdata_, arg0);
    return _return_value_;
}

}

#endif
