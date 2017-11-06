//=============================================================================================================================
//
// EasyAR 2.2.0
// Copyright (c) 2015-2017 VisionStar Information Technology (Shanghai) Co., Ltd. All Rights Reserved.
// EasyAR is the registered trademark or trademark of VisionStar Information Technology (Shanghai) Co., Ltd in China
// and other countries for the augmented reality technology developed by VisionStar Information Technology (Shanghai) Co., Ltd.
//
//=============================================================================================================================

#ifndef __EASYAR_PLAYER_HXX__
#define __EASYAR_PLAYER_HXX__

#include "easyar/types.hxx"

namespace easyar {

class VideoPlayer
{
protected:
    easyar_VideoPlayer * cdata_ ;
    void init_cdata(easyar_VideoPlayer * cdata);
    virtual VideoPlayer & operator=(const VideoPlayer & data) { return *this; } //deleted
public:
    VideoPlayer(easyar_VideoPlayer * cdata);
    virtual ~VideoPlayer();

    VideoPlayer(const VideoPlayer & data);
    const easyar_VideoPlayer * get_cdata() const;
    easyar_VideoPlayer * get_cdata();

    VideoPlayer();
    void setVideoType(VideoType videoType);
    void setRenderTexture(void * texture);
    void open(String * path, StorageType storageType, FunctorOfVoidFromVideoStatus callback);
    void close();
    bool play();
    bool stop();
    bool pause();
    bool isRenderTextureAvailable();
    void updateFrame();
    int duration();
    int currentPosition();
    bool seek(int position);
    Vec2I size();
    float volume();
    bool setVolume(float volume);
};

#ifndef __EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
#define __EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
struct FunctorOfVoidFromVideoStatus
{
    void * _state;
    void (* func)(void * _state, VideoStatus);
    void (* destroy)(void * _state);
    FunctorOfVoidFromVideoStatus(void * _state, void (* func)(void * _state, VideoStatus), void (* destroy)(void * _state));
};

static void FunctorOfVoidFromVideoStatus_func(void * _state, easyar_VideoStatus);
static void FunctorOfVoidFromVideoStatus_destroy(void * _state);
static inline easyar_FunctorOfVoidFromVideoStatus FunctorOfVoidFromVideoStatus_to_c(FunctorOfVoidFromVideoStatus f);
#endif

}

#endif

#ifndef __IMPLEMENTATION_EASYAR_PLAYER_HXX__
#define __IMPLEMENTATION_EASYAR_PLAYER_HXX__

#include "easyar/player.h"
#include "easyar/vector.hxx"

namespace easyar {

inline VideoPlayer::VideoPlayer(easyar_VideoPlayer * cdata)
    :
    cdata_(NULL)
{
    init_cdata(cdata);
}
inline VideoPlayer::~VideoPlayer()
{
    if (cdata_) {
        easyar_VideoPlayer__dtor(cdata_);
        cdata_ = NULL;
    }
}

inline VideoPlayer::VideoPlayer(const VideoPlayer & data)
    :
    cdata_(NULL)
{
    easyar_VideoPlayer * cdata = NULL;
    easyar_VideoPlayer__retain(data.cdata_, &cdata);
    init_cdata(cdata);
}
inline const easyar_VideoPlayer * VideoPlayer::get_cdata() const
{
    return cdata_;
}
inline easyar_VideoPlayer * VideoPlayer::get_cdata()
{
    return cdata_;
}
inline void VideoPlayer::init_cdata(easyar_VideoPlayer * cdata)
{
    cdata_ = cdata;
}
inline VideoPlayer::VideoPlayer()
    :
    cdata_(NULL)
{
    easyar_VideoPlayer * _return_value_ = NULL;
    easyar_VideoPlayer__ctor(&_return_value_);
    init_cdata(_return_value_);
}
inline void VideoPlayer::setVideoType(VideoType arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_VideoPlayer_setVideoType(cdata_, static_cast<easyar_VideoType>(arg0));
}
inline void VideoPlayer::setRenderTexture(void * arg0)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_VideoPlayer_setRenderTexture(cdata_, arg0);
}
inline void VideoPlayer::open(String * arg0, StorageType arg1, FunctorOfVoidFromVideoStatus arg2)
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_VideoPlayer_open(cdata_, arg0->get_cdata(), static_cast<easyar_StorageType>(arg1), FunctorOfVoidFromVideoStatus_to_c(arg2));
}
inline void VideoPlayer::close()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_VideoPlayer_close(cdata_);
}
inline bool VideoPlayer::play()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_VideoPlayer_play(cdata_);
    return _return_value_;
}
inline bool VideoPlayer::stop()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_VideoPlayer_stop(cdata_);
    return _return_value_;
}
inline bool VideoPlayer::pause()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_VideoPlayer_pause(cdata_);
    return _return_value_;
}
inline bool VideoPlayer::isRenderTextureAvailable()
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_VideoPlayer_isRenderTextureAvailable(cdata_);
    return _return_value_;
}
inline void VideoPlayer::updateFrame()
{
    if (cdata_ == NULL) {
        return;
    }
    easyar_VideoPlayer_updateFrame(cdata_);
}
inline int VideoPlayer::duration()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_VideoPlayer_duration(cdata_);
    return _return_value_;
}
inline int VideoPlayer::currentPosition()
{
    if (cdata_ == NULL) {
        return int();
    }
    int _return_value_ = easyar_VideoPlayer_currentPosition(cdata_);
    return _return_value_;
}
inline bool VideoPlayer::seek(int arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_VideoPlayer_seek(cdata_, arg0);
    return _return_value_;
}
inline Vec2I VideoPlayer::size()
{
    if (cdata_ == NULL) {
        return Vec2I();
    }
    easyar_Vec2I _return_value_ = easyar_VideoPlayer_size(cdata_);
    return Vec2I(_return_value_.data[0], _return_value_.data[1]);
}
inline float VideoPlayer::volume()
{
    if (cdata_ == NULL) {
        return float();
    }
    float _return_value_ = easyar_VideoPlayer_volume(cdata_);
    return _return_value_;
}
inline bool VideoPlayer::setVolume(float arg0)
{
    if (cdata_ == NULL) {
        return bool();
    }
    bool _return_value_ = easyar_VideoPlayer_setVolume(cdata_, arg0);
    return _return_value_;
}

#ifndef __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
#define __IMPLEMENTATION_EASYAR_FUNCTOROFVOIDFROMVIDEOSTATUS__
inline FunctorOfVoidFromVideoStatus::FunctorOfVoidFromVideoStatus(void * _state, void (* func)(void * _state, VideoStatus), void (* destroy)(void * _state))
{
    this->_state = _state;
    this->func = func;
    this->destroy = destroy;
}
static void FunctorOfVoidFromVideoStatus_func(void * _state, easyar_VideoStatus arg0)
{
    VideoStatus cpparg0 = static_cast<VideoStatus>(arg0);
    FunctorOfVoidFromVideoStatus * f = reinterpret_cast<FunctorOfVoidFromVideoStatus *>(_state);
    f->func(f->_state, cpparg0);
}
static void FunctorOfVoidFromVideoStatus_destroy(void * _state)
{
    FunctorOfVoidFromVideoStatus * f = reinterpret_cast<FunctorOfVoidFromVideoStatus *>(_state);
    if (f->destroy) {
        f->destroy(f->_state);
    }
    delete f;
}
static inline easyar_FunctorOfVoidFromVideoStatus FunctorOfVoidFromVideoStatus_to_c(FunctorOfVoidFromVideoStatus f)
{
    easyar_FunctorOfVoidFromVideoStatus _return_value_ = {NULL, NULL, NULL};
    if ((f.func == NULL) && (f.destroy == NULL)) { return _return_value_; }
    _return_value_._state = new FunctorOfVoidFromVideoStatus(f._state, f.func, f.destroy);
    _return_value_.func = FunctorOfVoidFromVideoStatus_func;
    _return_value_.destroy = FunctorOfVoidFromVideoStatus_destroy;
    return _return_value_;
}
#endif

}

#endif
