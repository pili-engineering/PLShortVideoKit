//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_ARSCENE_HXX__
#define __EASYAR_ARSCENE_HXX__

#include "easyar/types.hxx"
#include "easyar/target.hxx"

namespace easyar {

class ARScene : public Target
{
protected:
    easyar_ARScene * cdata_ ;
    void init_cdata(easyar_ARScene * cdata);
    virtual ARScene & operator=(const ARScene & data) { return *this; } //deleted
public:
    ARScene(easyar_ARScene * cdata);
    virtual ~ARScene();

    ARScene(const ARScene & data);
    const easyar_ARScene * get_cdata() const;
    easyar_ARScene * get_cdata();

    ARScene();
    int runtimeID();
    void uid(/* OUT */ String * * Return);
    void name(/* OUT */ String * * Return);
    void meta(/* OUT */ String * * Return);
    void setMeta(String * data);
    static void tryCastFromTarget(Target * v, /* OUT */ ARScene * * Return);
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_ARSCENE_HXX__
#define __IMPLEMENTATION_EASYAR_ARSCENE_HXX__

#include "easyar/arscene.h"
#include "easyar/target.hxx"

namespace easyar {

inline ARScene::ARScene(easyar_ARScene * cdata)
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ARScene::~ARScene()
{
    if (cdata_) {
        easyar_ARScene__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ARScene::ARScene(const ARScene & data)
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    easyar_ARScene * cdata = NULL;
    easyar_ARScene__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ARScene * ARScene::get_cdata() const
{
    return cdata_;
}
inline easyar_ARScene * ARScene::get_cdata()
{
    return cdata_;
}
inline void ARScene::init_cdata(easyar_ARScene * cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * cdata_inner = NULL;
        easyar_castARSceneToTarget(cdata, &cdata_inner);
        Target::init_cdata(cdata_inner);
    }
}
inline ARScene::ARScene()
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    easyar_ARScene * _return_value_ = NULL;
    easyar_ARScene__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline int ARScene::runtimeID()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_ARScene_runtimeID(cdata_);
    return _return_value_;
}
inline void ARScene::uid(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ARScene_uid(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ARScene::name(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ARScene_name(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ARScene::meta(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ARScene_meta(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ARScene::setMeta(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ARScene_setMeta(cdata_, arg0->get_cdata());
}
inline void ARScene::tryCastFromTarget(Target * v, /* OUT */ ARScene * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ARScene * cdata = NULL;
    easyar_tryCastTargetToARScene(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ARScene(cdata);
}

}

#endif
