//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_IMAGETARGET_HXX__
#define __EASYAR_IMAGETARGET_HXX__

#include "easyar/types.hxx"
#include "easyar/target.hxx"

namespace easyar {

class ImageTarget : public Target
{
protected:
    easyar_ImageTarget * cdata_ ;
    void init_cdata(easyar_ImageTarget * cdata);
    virtual ImageTarget & operator=(const ImageTarget & data) { return *this; } //deleted
public:
    ImageTarget(easyar_ImageTarget * cdata);
    virtual ~ImageTarget();

    ImageTarget(const ImageTarget & data);
    const easyar_ImageTarget * get_cdata() const;
    easyar_ImageTarget * get_cdata();

    ImageTarget();
    bool setup(String * path, int storageType, String * name);
    static void setupAll(String * path, int storageType, /* OUT */ ListOfPointerOfImageTarget * * Return);
    Vec2F size();
    bool setSize(Vec2F size);
    void images(/* OUT */ ListOfPointerOfImage * * Return);
    int runtimeID();
    void uid(/* OUT */ String * * Return);
    void name(/* OUT */ String * * Return);
    void meta(/* OUT */ String * * Return);
    void setMeta(String * data);
    static void tryCastFromTarget(Target * v, /* OUT */ ImageTarget * * Return);
};

#ifndef __EASYAR_LISTOFPOINTEROFIMAGETARGET__
#define __EASYAR_LISTOFPOINTEROFIMAGETARGET__
class ListOfPointerOfImageTarget
{
private:
    easyar_ListOfPointerOfImageTarget * cdata_;
    virtual ListOfPointerOfImageTarget & operator=(const ListOfPointerOfImageTarget & data) { return *this; } //deleted
public:
    ListOfPointerOfImageTarget(easyar_ListOfPointerOfImageTarget * cdata);
    virtual ~ListOfPointerOfImageTarget();

    ListOfPointerOfImageTarget(const ListOfPointerOfImageTarget & data);
    const easyar_ListOfPointerOfImageTarget * get_cdata() const;
    easyar_ListOfPointerOfImageTarget * get_cdata();

    ListOfPointerOfImageTarget(easyar_ImageTarget * * begin, easyar_ImageTarget * * end);
    int size() const;
    ImageTarget * at(int index) const;
};
#endif

#ifndef __EASYAR_LISTOFPOINTEROFIMAGE__
#define __EASYAR_LISTOFPOINTEROFIMAGE__
class ListOfPointerOfImage
{
private:
    easyar_ListOfPointerOfImage * cdata_;
    virtual ListOfPointerOfImage & operator=(const ListOfPointerOfImage & data) { return *this; } //deleted
public:
    ListOfPointerOfImage(easyar_ListOfPointerOfImage * cdata);
    virtual ~ListOfPointerOfImage();

    ListOfPointerOfImage(const ListOfPointerOfImage & data);
    const easyar_ListOfPointerOfImage * get_cdata() const;
    easyar_ListOfPointerOfImage * get_cdata();

    ListOfPointerOfImage(easyar_Image * * begin, easyar_Image * * end);
    int size() const;
    Image * at(int index) const;
};
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_IMAGETARGET_HXX__
#define __IMPLEMENTATION_EASYAR_IMAGETARGET_HXX__

#include "easyar/imagetarget.h"
#include "easyar/target.hxx"
#include "easyar/vector.hxx"
#include "easyar/image.hxx"

namespace easyar {

inline ImageTarget::ImageTarget(easyar_ImageTarget * cdata)
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline ImageTarget::~ImageTarget()
{
    if (cdata_) {
        easyar_ImageTarget__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ImageTarget::ImageTarget(const ImageTarget & data)
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    easyar_ImageTarget * cdata = NULL;
    easyar_ImageTarget__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_ImageTarget * ImageTarget::get_cdata() const
{
    return cdata_;
}
inline easyar_ImageTarget * ImageTarget::get_cdata()
{
    return cdata_;
}
inline void ImageTarget::init_cdata(easyar_ImageTarget * cdata)
{
    cdata_ = cdata;
    {
        easyar_Target * cdata_inner = NULL;
        easyar_castImageTargetToTarget(cdata, &cdata_inner);
        Target::init_cdata(cdata_inner);
    }
}
inline ImageTarget::ImageTarget()
    :
    Target(static_cast<easyar_Target *>(NULL)),
    cdata_(NULL)
{
    easyar_ImageTarget * _return_value_ = NULL;
    easyar_ImageTarget__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline bool ImageTarget::setup(String * arg0, int arg1, String * arg2)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ImageTarget_setup(cdata_, arg0->get_cdata(), arg1, arg2->get_cdata());
    return _return_value_;
}
inline void ImageTarget::setupAll(String * arg0, int arg1, /* OUT */ ListOfPointerOfImageTarget * * Return)
{
    easyar_ListOfPointerOfImageTarget * _return_value_ = NULL;
    easyar_ImageTarget_setupAll(arg0->get_cdata(), arg1, &_return_value_);
    *Return = new ListOfPointerOfImageTarget(_return_value_);
}
inline Vec2F ImageTarget::size()
{
    if (cdata_ == NULL) {
        return Vec2F();
    }
    easyar_Vec2F _return_value_ = easyar_ImageTarget_size(cdata_);
    return Vec2F(_return_value_.data[0], _return_value_.data[1]);
}
inline bool ImageTarget::setSize(Vec2F arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_ImageTarget_setSize(cdata_, arg0.get_cdata());
    return _return_value_;
}
inline void ImageTarget::images(/* OUT */ ListOfPointerOfImage * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfImage * _return_value_ = NULL;
    easyar_ImageTarget_images(cdata_, &_return_value_);
    *Return = new ListOfPointerOfImage(_return_value_);
}
inline int ImageTarget::runtimeID()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_ImageTarget_runtimeID(cdata_);
    return _return_value_;
}
inline void ImageTarget::uid(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ImageTarget_uid(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ImageTarget::name(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ImageTarget_name(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ImageTarget::meta(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_ImageTarget_meta(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void ImageTarget::setMeta(String * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_ImageTarget_setMeta(cdata_, arg0->get_cdata());
}
inline void ImageTarget::tryCastFromTarget(Target * v, /* OUT */ ImageTarget * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ImageTarget * cdata = NULL;
    easyar_tryCastTargetToImageTarget(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new ImageTarget(cdata);
}

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGETARGET__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGETARGET__
inline ListOfPointerOfImageTarget::ListOfPointerOfImageTarget(easyar_ListOfPointerOfImageTarget * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfImageTarget::~ListOfPointerOfImageTarget()
{
    if (cdata_) {
        easyar_ListOfPointerOfImageTarget__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfImageTarget::ListOfPointerOfImageTarget(const ListOfPointerOfImageTarget & data)
    : cdata_(static_cast<easyar_ListOfPointerOfImageTarget *>(NULL))
{
    easyar_ListOfPointerOfImageTarget_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfImageTarget * ListOfPointerOfImageTarget::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfImageTarget * ListOfPointerOfImageTarget::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfImageTarget::ListOfPointerOfImageTarget(easyar_ImageTarget * * begin, easyar_ImageTarget * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfImageTarget *>(NULL))
{
    easyar_ListOfPointerOfImageTarget__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfImageTarget::size() const
{
    return easyar_ListOfPointerOfImageTarget_size(cdata_);
}
inline ImageTarget * ListOfPointerOfImageTarget::at(int index) const
{
    easyar_ImageTarget * _return_value_ = easyar_ListOfPointerOfImageTarget_at(cdata_, index);
    easyar_ImageTarget__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new ImageTarget(_return_value_));
}
#endif

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGE__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFIMAGE__
inline ListOfPointerOfImage::ListOfPointerOfImage(easyar_ListOfPointerOfImage * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfImage::~ListOfPointerOfImage()
{
    if (cdata_) {
        easyar_ListOfPointerOfImage__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfImage::ListOfPointerOfImage(const ListOfPointerOfImage & data)
    : cdata_(static_cast<easyar_ListOfPointerOfImage *>(NULL))
{
    easyar_ListOfPointerOfImage_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfImage * ListOfPointerOfImage::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfImage * ListOfPointerOfImage::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfImage::ListOfPointerOfImage(easyar_Image * * begin, easyar_Image * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfImage *>(NULL))
{
    easyar_ListOfPointerOfImage__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfImage::size() const
{
    return easyar_ListOfPointerOfImage_size(cdata_);
}
inline Image * ListOfPointerOfImage::at(int index) const
{
    easyar_Image * _return_value_ = easyar_ListOfPointerOfImage_at(cdata_, index);
    easyar_Image__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new Image(_return_value_));
}
#endif

}

#endif
