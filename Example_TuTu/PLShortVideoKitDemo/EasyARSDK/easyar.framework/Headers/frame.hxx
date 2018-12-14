//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_FRAME_HXX__
#define __EASYAR_FRAME_HXX__

#include "easyar/types.hxx"
#include "easyar/drawable.hxx"

namespace easyar {

class Frame : public Drawable
{
protected:
    easyar_Frame * cdata_ ;
    void init_cdata(easyar_Frame * cdata);
    virtual Frame & operator=(const Frame & data) { return *this; } //deleted
public:
    Frame(easyar_Frame * cdata);
    virtual ~Frame();

    Frame(const Frame & data);
    const easyar_Frame * get_cdata() const;
    easyar_Frame * get_cdata();

    Frame();
    Vec2I size();
    double timestamp();
    int index();
    void images(/* OUT */ ListOfPointerOfImage * * Return);
    void targetInstances(/* OUT */ ListOfPointerOfTargetInstance * * Return);
    void text(/* OUT */ String * * Return);
    static void tryCastFromDrawable(Drawable * v, /* OUT */ Frame * * Return);
};

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

#ifndef __EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
#define __EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
class ListOfPointerOfTargetInstance
{
private:
    easyar_ListOfPointerOfTargetInstance * cdata_;
    virtual ListOfPointerOfTargetInstance & operator=(const ListOfPointerOfTargetInstance & data) { return *this; } //deleted
public:
    ListOfPointerOfTargetInstance(easyar_ListOfPointerOfTargetInstance * cdata);
    virtual ~ListOfPointerOfTargetInstance();

    ListOfPointerOfTargetInstance(const ListOfPointerOfTargetInstance & data);
    const easyar_ListOfPointerOfTargetInstance * get_cdata() const;
    easyar_ListOfPointerOfTargetInstance * get_cdata();

    ListOfPointerOfTargetInstance(easyar_TargetInstance * * begin, easyar_TargetInstance * * end);
    int size() const;
    TargetInstance * at(int index) const;
};
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_FRAME_HXX__
#define __IMPLEMENTATION_EASYAR_FRAME_HXX__

#include "easyar/frame.h"
#include "easyar/drawable.hxx"
#include "easyar/vector.hxx"
#include "easyar/image.hxx"
#include "easyar/target.hxx"

namespace easyar {

inline Frame::Frame(easyar_Frame * cdata)
    :
    Drawable(static_cast<easyar_Drawable *>(NULL)),
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Frame::~Frame()
{
    if (cdata_) {
        easyar_Frame__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Frame::Frame(const Frame & data)
    :
    Drawable(static_cast<easyar_Drawable *>(NULL)),
    cdata_(NULL)
{
    easyar_Frame * cdata = NULL;
    easyar_Frame__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Frame * Frame::get_cdata() const
{
    return cdata_;
}
inline easyar_Frame * Frame::get_cdata()
{
    return cdata_;
}
inline void Frame::init_cdata(easyar_Frame * cdata)
{
    cdata_ = cdata;
    {
        easyar_Drawable * cdata_inner = NULL;
        easyar_castFrameToDrawable(cdata, &cdata_inner);
        Drawable::init_cdata(cdata_inner);
    }
}
inline Frame::Frame()
    :
    Drawable(static_cast<easyar_Drawable *>(NULL)),
    cdata_(NULL)
{
    easyar_Frame * _return_value_ = NULL;
    easyar_Frame__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline Vec2I Frame::size()
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_Frame_size(cdata_);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline double Frame::timestamp()
{
    if (cdata_ == NULL) {
        return double();
    }
    double _return_value_ = easyar_Frame_timestamp(cdata_);
    return _return_value_;
}
inline int Frame::index()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Frame_index(cdata_);
    return _return_value_;
}
inline void Frame::images(/* OUT */ ListOfPointerOfImage * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfImage * _return_value_ = NULL;
    easyar_Frame_images(cdata_, &_return_value_);
    *Return = new ListOfPointerOfImage(_return_value_);
}
inline void Frame::targetInstances(/* OUT */ ListOfPointerOfTargetInstance * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_ListOfPointerOfTargetInstance * _return_value_ = NULL;
    easyar_Frame_targetInstances(cdata_, &_return_value_);
    *Return = new ListOfPointerOfTargetInstance(_return_value_);
}
inline void Frame::text(/* OUT */ String * * Return)
{
    if (cdata_ == NULL) {
        *Return = NULL;
        return;
    }
    easyar_String * _return_value_ = NULL;
    easyar_Frame_text(cdata_, &_return_value_);
    *Return = (_return_value_) == NULL ? NULL : new String(_return_value_);
}
inline void Frame::tryCastFromDrawable(Drawable * v, /* OUT */ Frame * * Return)
{
    if (v == NULL) {
        *Return = NULL;
        return;
    }
    easyar_Frame * cdata = NULL;
    easyar_tryCastDrawableToFrame(v->get_cdata(), &cdata);
    if (cdata == NULL) {
        *Return = NULL;
        return;
    }
    *Return = new Frame(cdata);
}

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

#ifndef __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
#define __IMPLEMENTATION_EASYAR_LISTOFPOINTEROFTARGETINSTANCE__
inline ListOfPointerOfTargetInstance::ListOfPointerOfTargetInstance(easyar_ListOfPointerOfTargetInstance * cdata)
    : cdata_(cdata)
{
}
inline ListOfPointerOfTargetInstance::~ListOfPointerOfTargetInstance()
{
    if (cdata_) {
        easyar_ListOfPointerOfTargetInstance__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline ListOfPointerOfTargetInstance::ListOfPointerOfTargetInstance(const ListOfPointerOfTargetInstance & data)
    : cdata_(static_cast<easyar_ListOfPointerOfTargetInstance *>(NULL))
{
    easyar_ListOfPointerOfTargetInstance_copy(data.cdata_, &cdata_);
}
inline const easyar_ListOfPointerOfTargetInstance * ListOfPointerOfTargetInstance::get_cdata() const
{
    return cdata_;
}
inline easyar_ListOfPointerOfTargetInstance * ListOfPointerOfTargetInstance::get_cdata()
{
    return cdata_;
}

inline ListOfPointerOfTargetInstance::ListOfPointerOfTargetInstance(easyar_TargetInstance * * begin, easyar_TargetInstance * * end)
    : cdata_(static_cast<easyar_ListOfPointerOfTargetInstance *>(NULL))
{
    easyar_ListOfPointerOfTargetInstance__ctor(begin, end, &cdata_);
}
inline int ListOfPointerOfTargetInstance::size() const
{
    return easyar_ListOfPointerOfTargetInstance_size(cdata_);
}
inline TargetInstance * ListOfPointerOfTargetInstance::at(int index) const
{
    easyar_TargetInstance * _return_value_ = easyar_ListOfPointerOfTargetInstance_at(cdata_, index);
    easyar_TargetInstance__retain(_return_value_, &_return_value_);
    return (_return_value_ == NULL ? NULL : new TargetInstance(_return_value_));
}
#endif

}

#endif
