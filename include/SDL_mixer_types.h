typedef uint8_t Uint8;
typedef uint16_t Uint16;
typedef uint32_t Uint32;
typedef int8_t Sint8;
typedef int16_t Sint16;
typedef int32_t Sint32;


// SDL_audio.h


typedef Uint16 SDL_AudioFormat;

enum {
	SDL_AUDIO_MASK_BITSIZE       = (0xFF),
	SDL_AUDIO_MASK_DATATYPE      = (1<<8),
	SDL_AUDIO_MASK_ENDIAN        = (1<<12),
	SDL_AUDIO_MASK_SIGNED        = (1<<15),
/*
#define SDL_AUDIO_BITSIZE(x)         (x & SDL_AUDIO_MASK_BITSIZE)
#define SDL_AUDIO_ISFLOAT(x)         (x & SDL_AUDIO_MASK_DATATYPE)
#define SDL_AUDIO_ISBIGENDIAN(x)     (x & SDL_AUDIO_MASK_ENDIAN)
#define SDL_AUDIO_ISSIGNED(x)        (x & SDL_AUDIO_MASK_SIGNED)
#define SDL_AUDIO_ISINT(x)           (!SDL_AUDIO_ISFLOAT(x))
#define SDL_AUDIO_ISLITTLEENDIAN(x)  (!SDL_AUDIO_ISBIGENDIAN(x))
#define SDL_AUDIO_ISUNSIGNED(x)      (!SDL_AUDIO_ISSIGNED(x))
*/
	AUDIO_U8	= 0x0008,  /**< Unsigned 8-bit samples */
	AUDIO_S8	= 0x8008,  /**< Signed 8-bit samples */
	AUDIO_U16LSB	= 0x0010,  /**< Unsigned 16-bit samples */
	AUDIO_S16LSB	= 0x8010,  /**< Signed 16-bit samples */
	AUDIO_U16MSB	= 0x1010,  /**< As above, but big-endian byte order */
	AUDIO_S16MSB	= 0x9010,  /**< As above, but big-endian byte order */
	AUDIO_U16	= 0x0010,	//AUDIO_U16LSB
	AUDIO_S16	= 0x8010,	//AUDIO_S16LSB
	AUDIO_S32LSB	= 0x8020,  /**< 32-bit integer samples */
	AUDIO_S32MSB	= 0x9020,  /**< As above, but big-endian byte order */
	AUDIO_S32	= 0x8020,	//AUDIO_S32LSB
	AUDIO_F32LSB	= 0x8120,  /**< 32-bit floating point samples */
	AUDIO_F32MSB	= 0x9120,  /**< As above, but big-endian byte order */
	AUDIO_F32	= 0x8120,	//AUDIO_F32LSB
/*
#if SDL_BYTEORDER == SDL_LIL_ENDIAN
#define AUDIO_U16SYS	AUDIO_U16LSB
#define AUDIO_S16SYS	AUDIO_S16LSB
#define AUDIO_S32SYS	AUDIO_S32LSB
#define AUDIO_F32SYS	AUDIO_F32LSB
#else
#define AUDIO_U16SYS	AUDIO_U16MSB
#define AUDIO_S16SYS	AUDIO_S16MSB
#define AUDIO_S32SYS	AUDIO_S32MSB
#define AUDIO_F32SYS	AUDIO_F32MSB
#endif
*/
	SDL_AUDIO_ALLOW_FREQUENCY_CHANGE    = 0x00000001,
	SDL_AUDIO_ALLOW_FORMAT_CHANGE       = 0x00000002,
	SDL_AUDIO_ALLOW_CHANNELS_CHANGE     = 0x00000004,	
};
enum {
	SDL_AUDIO_ALLOW_ANY_CHANGE          = (SDL_AUDIO_ALLOW_FREQUENCY_CHANGE|SDL_AUDIO_ALLOW_FORMAT_CHANGE|SDL_AUDIO_ALLOW_CHANNELS_CHANGE)
};

typedef void (* SDL_AudioCallback) (void *userdata, Uint8 * stream, int len);

typedef struct 
{
    int freq;                   /**< DSP frequency -- samples per second */
    SDL_AudioFormat format;     /**< Audio data format */
    Uint8 channels;             /**< Number of channels: 1 mono, 2 stereo */
    Uint8 silence;              /**< Audio buffer silence value (calculated) */
    Uint16 samples;             /**< Audio buffer size in samples (power of 2) */
    Uint16 padding;             /**< Necessary for some compile environments */
    Uint32 size;                /**< Audio buffer size in bytes (calculated) */
    SDL_AudioCallback callback;
    void *userdata;
} SDL_AudioSpec;

typedef void (* SDL_AudioFilter) (struct SDL_AudioCVT * cvt, SDL_AudioFormat format);

typedef struct
{
    int needed;                 /**< Set to 1 if conversion possible */
    SDL_AudioFormat src_format; /**< Source audio format */
    SDL_AudioFormat dst_format; /**< Target audio format */
    double rate_incr;           /**< Rate conversion increment */
    Uint8 *buf;                 /**< Buffer to hold entire audio data */
    int len;                    /**< Length of original audio buffer */
    int len_cvt;                /**< Length of converted audio buffer */
    int len_mult;               /**< buffer must be len*len_mult big */
    double len_ratio;           /**< Given len, final size is len*len_ratio */
    SDL_AudioFilter filters[10];        /**< Filter list */
    int filter_index;           /**< Current audio conversion function */
} SDL_AudioCVT;


enum {
	SDL_MIX_MAXVOLUME = 128,
};

// SDL_mixer.h

enum {
	SDL_MIXER_MAJOR_VERSION	= 1,
	SDL_MIXER_MINOR_VERSION	= 2,
	SDL_MIXER_PATCHLEVEL    = 11,
	MIX_CHANNELS = 8,
	MIX_DEFAULT_FREQUENCY = 22050,
//	MIX_DEFAULT_FORMAT = ,
	MIX_DEFAULT_CHANNELS = 2,
	MIX_MAX_VOLUME = 128,
	MIX_CHANNEL_POST = -2,
};

typedef enum {
    MIX_INIT_FLAC = 0x00000001,
    MIX_INIT_MOD  = 0x00000002,
    MIX_INIT_MP3  = 0x00000004,
    MIX_INIT_OGG  = 0x00000008
} MIX_InitFlags;

typedef struct Mix_Chunk {
	int allocated;
	Uint8 *abuf;
	Uint32 alen;
	Uint8 volume;
} Mix_Chunk;

typedef enum {
	MIX_NO_FADING,
	MIX_FADING_OUT,
	MIX_FADING_IN
} Mix_Fading;

typedef enum {
	MUS_NONE,
	MUS_CMD,
	MUS_WAV,
	MUS_MOD,
	MUS_MID,
	MUS_OGG,
	MUS_MP3,
	MUS_MP3_MAD,
	MUS_FLAC,
	MUS_MODPLUG
} Mix_MusicType;

typedef struct _Mix_Music Mix_Music;

typedef Uint32 SDL_AudioDeviceID;
typedef void (*Mix_EffectFunc_t)(int chan, void *stream, int len, void *udata);
typedef void (*Mix_EffectDone_t)(int chan, void *udata);
