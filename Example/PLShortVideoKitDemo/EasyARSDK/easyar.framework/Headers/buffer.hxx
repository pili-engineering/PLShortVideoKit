//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_BUFFER_HXX__
#define __EASYAR_BUFFER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class Buffer
{
protected:
    easyar_Buffer * cdata_ ;
    void init_cdata(easyar_Buffer * cdata);
    virtual Buffer & operator=(const Buffer & data) { return *this; } //deleted
public:
    Buffer(easyar_Buffer * cdata);
    virtual ~Buffer();

    Buffer(const Buffer & data);
    const easyar_Buffer * get_cdata() const;
    easyar_Buffer * get_cdata();

    void * data();
    int size();
};

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_BUFFER_HXX__
#define __IMPLEMENTATION_EASYAR_BUFFER_HXX__

#include "easyar/buffer.h"

namespace easyar {

inline Buffer::Buffer(easyar_Buffer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline Buffer::~Buffer()
{
    if (cdata_) {
        easyar_Buffer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline Buffer::Buffer(const Buffer & data)
    :
    cdata_(NULL)
{
    easyar_Buffer * cdata = NULL;
    easyar_Buffer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_Buffer * Buffer::get_cdata() const
{
    return cdata_;
}
inline easyar_Buffer * Buffer::get_cdata()
{
    return cdata_;
}
inline void Buffer::init_cdata(easyar_Buffer * cdata)
{
    cdata_ = cdata;
}
inline void * Buffer::data()
{
    if (cdata_ == NULL) {
        return NULL;
    }
    void * _return_value_ = easyar_Buffer_data(cdata_);
    return _return_value_;
}
inline int Buffer::size()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_Buffer_size(cdata_);
    return _return_value_;
}

}

#endif
