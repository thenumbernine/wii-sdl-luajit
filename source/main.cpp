#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>
#include <math.h>
#include <gccore.h>

#include <ogc/video.h>
#include <wiiuse/wpad.h>

#include <fat.h>
#include <string.h>
#include <dirent.h>

#include "lua_util.h"

#include <SDL/SDL.h>	//for SDL_main
//				LIBC


int binding_printf(lua_State *L) {
#if 0	//no va_list on devkitpro ...
	int i, n;
	va_list argp;
	char fmt[256];		// has a size limit ...
	va_start(argp, fmt);
	n = lua_gettop(L);
	for (i = 1; i <= n; i++) {
		va_arg(argp, char*);
	}
	va_end(argp);
	printf(fmt);
#else
	//I would handle lua call variable args case ... but the values would still need to be converted...
	printf(lua_tostring(L,1));
#endif
	return 0;
}

BINDFUNC(void*, memalign, size_t, size_t)
BINDFUNC(void*, memset, void*, int, size_t)


void init_binding_SDL(lua_State *L);
void init_binding_SDL_mixer(lua_State *L);
void init_binding_SDL_image(lua_State *L);
void init_binding_GL(lua_State *L);
void init_binding_GLU(lua_State *L);
void init_binding_GLUT(lua_State *L);

template<> GXRModeObj* luaGetValue<GXRModeObj*>(lua_State *L, int i) { return cdataToPtr<GXRModeObj*>(L, i); }
template<> void luaPushValue<GXRModeObj*>(lua_State *L, GXRModeObj* const& returnValue) {  FFI_CAST("GXRModeObj*", (GXRModeObj*)returnValue); }

template<> GXFifoObj* luaGetValue<GXFifoObj*>(lua_State *L, int i) { return cdataToPtr<GXFifoObj*>(L, i); }
template<> void luaPushValue<GXFifoObj*>(lua_State *L, GXFifoObj* const& returnValue) { FFI_CAST("GXFifoObj*", (GXFifoObj*)returnValue);  }

template<> GXColor luaGetValue<GXColor>(lua_State *L, int i) { 
	return *((const GXColor *)lua_topointer(L,i));
}
template<> void luaPushValue<GXColor>(lua_State *L, GXColor const& returnValue) {
	lua_getglobal(L, "require");	//require
	lua_pushstring(L, "ffi");		//require 'ffi'
	luaSafeCall(L, 1, 1);			//ffi
	lua_getfield(L, -1, "new");		//ffi ffi.cast
	lua_pushstring(L, "GXColor");	//ffi ffi.cast "GXColor"
	luaSafeCall(L, 1, 1);			//ffi obj
	lua_pushnumber(L, (lua_Number)returnValue.r);
	lua_setfield(L, -2, "r");
	lua_pushnumber(L, (lua_Number)returnValue.g);
	lua_setfield(L, -2, "g");
	lua_pushnumber(L, (lua_Number)returnValue.b);
	lua_setfield(L, -2, "b");
	lua_pushnumber(L, (lua_Number)returnValue.a);
	lua_setfield(L, -2, "a");
	lua_remove(L, lua_gettop(L)-1);	//obj
}

//ogc/system.h
BINDFUNC(void*, SYS_AllocateFramebuffer, GXRModeObj*);	//void* SYS_AllocateFramebuffer(GXRModeObj *rmode);

//ogc/video.h
BINDFUNC(void, VIDEO_Init)	//void VIDEO_Init()
BINDFUNC(GXRModeObj*, VIDEO_GetPreferredMode, GXRModeObj*);	//GXRModeObj *VIDEO_GetPreferredMode(GXRModeObj*)
BINDFUNC(void, VIDEO_Configure, GXRModeObj*)	//void VIDEO_Configure(GXRModeObj *rmode);

#if 1
BINDFUNC(void, VIDEO_SetNextFramebuffer, void*)	//void VIDEO_SetNextFramebuffer(void *fb);
#else	//debugging
template<typename T> struct wrapper_VIDEO_SetNextFramebuffer {
	lua_State *L;
	void (*f)(void*);
	wrapper_VIDEO_SetNextFramebuffer(void (*_f)(void*)) : f(_f) {}
	int operator()(PARAM_FOR_EACH(void*)) {
		printf("shouldn't be here\n");
		//luaPushValue<void>(L, f(INVOKE_FOR_EACH(void*)));
		return 1;
	}
};
template<> struct wrapper_VIDEO_SetNextFramebuffer<void> {
	lua_State *L;
	void (*f)(void*);
	wrapper_VIDEO_SetNextFramebuffer(void (*_f)(void*)) : f(_f) {}
	int operator()(PARAM_FOR_EACH(void*)) {
		printf("binding invoke xfb: %p\n", INVOKE_FOR_EACH(void*));
		//f(INVOKE_FOR_EACH(void*));
		return 0;
	}
};
static int binding_VIDEO_SetNextFramebuffer(lua_State *L) {
	int n = lua_gettop(L);
	if (n != 1) luaL_error(L, "expected 1 but found %d arguments", n);
	
	void *xfb = *(void**)const_cast<void*>(lua_topointer(L, 1));
	printf("binding xfb: %p\n", xfb);

	wrapper_VIDEO_SetNextFramebuffer<void> wrapper(VIDEO_SetNextFramebuffer);
	wrapper.L = L;
	return wrapper.operator()(MAP_FOR_EACH(luaGetValue, void*));
}
#endif

BINDFUNC(void, VIDEO_SetBlack, bool)	//void VIDEO_SetBlack(bool black);
BINDFUNC(void, VIDEO_Flush)
BINDFUNC(void, VIDEO_WaitVSync)

//ogc/consol.h
BINDFUNC(void, CON_Init, void*, int, int, int, int, int)	//void CON_Init(void *framebuffer,int xstart,int ystart,int xres,int yres,int stride);

//ogc/gx.h
BINDFUNC(GXFifoObj *, GX_Init, void*, u32)
BINDFUNC(void, GX_SetCopyClear, GXColor, u32)
BINDFUNC(void, GX_SetViewport, f32, f32, f32, f32, f32, f32)
BINDFUNC(f32, GX_GetYScaleFactor, u16, u16)
BINDFUNC(u32, GX_SetDispCopyYScale, f32)
BINDFUNC(void, GX_SetScissor, u32, u32, u32, u32)
BINDFUNC(void, GX_SetPixelFmt, u8, u8)

//wiiuse/wpad.h
BINDFUNC(s32, WPAD_Init)	//s32 WPAD_Init()
BINDFUNC(s32, WPAD_ScanPads)	//s32 WPAD_ScanPads()
BINDFUNC(u32, WPAD_ButtonsDown, int)	//u32 WPAD_ButtonsDown(int chan)


void initLuaBindings(lua_State *L) {
	int top = lua_gettop(L);
	
	lua_getglobal(L, "require");	//require
	lua_pushstring(L, "ffi");	//require "ffi"
	luaSafeCall(L, 1, 1);	//ffi
	
	int ffi = lua_gettop(L);

	//libc

	
	BEGIN_PACKAGE(C)
		BINDNAME(printf)
		BINDNAME(memalign)
		BINDNAME(memset)
	END_PACKAGE()

	init_binding_GL(L);
	init_binding_GLU(L);
	init_binding_GLUT(L);
	init_binding_SDL(L);
	//init_binding_SDL_mixer(L);
	init_binding_SDL_image(L);
	
	//devkitPro
	
	
	//gctypes.h
	FFI_CDEF(
"		typedef uint8_t u8;\n"
"		typedef uint16_t u16;\n"
"		typedef uint32_t u32;\n"
"		typedef uint64_t u64;\n"
"		typedef int8_t s8;\n"
"		typedef int16_t s16;\n"
"		typedef int32_t s32;\n"
"		typedef int64_t s64;\n"
"		typedef volatile u8 vu8;\n"
"		typedef volatile u16 vu16;\n"
"		typedef volatile u32 vu32;\
		typedef volatile u64 vu64;\n"
"		typedef volatile s8 vs8;\n"
"		typedef volatile s16 vs16;\n"
"		typedef volatile s32 vs32;\n"
"		typedef volatile s64 vs64;\n"
"		typedef s16 sfp16;\n"
"		typedef s32 sfp32;\n"
"		typedef u16 ufp16;\n"
"		typedef u32 ufp32;\n"
"		typedef float f32;\n"
"		typedef double f64;\n"
"		typedef volatile float vf32;\n"
"		typedef volatile double vf64;\n"
	);	

	//ogc/gx_struct.h
	FFI_CDEF(
"		typedef struct _gx_rmodeobj {\n"
"			u32 viTVMode;\n"
"			u16 fbWidth;\n"
"			u16 efbHeight;\n"
"			u16 xfbHeight;\n"
"			u16 viXOrigin;\n"
"			u16 viYOrigin;\n"
"			u16 viWidth;\n"
"			u16 viHeight;\n"
"			u32  xfbMode;\n"
"			u8  field_rendering;\n"
"			u8  aa;\n"
"			u8  sample_pattern[12][2];\n"
"			u8  vfilter[7];\n"
"		} GXRModeObj;\n"
	);
	
	//ogc/system.h
	FFI_CDEF(
"		enum {\n"
"			SYS_BASE_CACHED = 0x80000000,\n"
"			SYS_BASE_UNCACHED = 0xC0000000,\n"
"		};"
	);
	BEGIN_PACKAGE(ogc.system)
		BINDNAME(SYS_AllocateFramebuffer)
	END_PACKAGE()

	//ogc/video_types.h
	FFI_CDEF(
"		enum {\n"
"			VI_NON_INTERLACE = 1,\n"
"			VI_DISPLAY_PIX_SZ = 2,\n"
"		};\n"
	);
	
	//ogc/video.h
	BEGIN_PACKAGE(ogc.video)
		BINDNAME(VIDEO_Init)
		BINDNAME(VIDEO_GetPreferredMode)
		BINDNAME(VIDEO_Configure)
		BINDNAME(VIDEO_SetNextFramebuffer)
		BINDNAME(VIDEO_SetBlack)
		BINDNAME(VIDEO_Flush)
		BINDNAME(VIDEO_WaitVSync)
	END_PACKAGE()
	
	BEGIN_PACKAGE(ogc.consol)
		BINDNAME(CON_Init)
	END_PACKAGE()
	
	//gx.h
	FFI_CDEF(
"		enum {\n"
"			GX_FALSE = 0,\n"
"			GX_TRUE = 1,\n"
"			GX_DISABLE = 0,\n"
"			GX_ENABLE = 1,\n"
"			GX_FIFO_OBJSIZE = 128,\n"
"			GX_PF_RGB8_Z24				=	0,\n"
"			GX_PF_RGBA6_Z24				=	1,\n"
"			GX_PF_RGB565_Z16			=	2,\n"
"			GX_PF_Z24					=	3,\n"
"			GX_PF_Y8					=	4,\n"
"			GX_PF_U8					=	5,\n"
"			GX_PF_V8					=	6,\n"
"			GX_PF_YUV420				=	7,\n"
"			GX_ZC_LINEAR				=	0,\n"
"			GX_ZC_NEAR					=	1,\n"
"			GX_ZC_MID					=	2,\n"
"			GX_ZC_FAR					=	3,\n"
"		};	\n"
"		typedef struct _gx_color {\n"
"			u8 r;\n"
"			u8 g;\n"
"			u8 b;\n"
"			u8 a;\n"
"		} GXColor;\n"
"		typedef struct {\n"
"			u8 pad[GX_FIFO_OBJSIZE];\n"
"		} GXFifoObj;\n"
	);
	BEGIN_PACKAGE(ogc.gx)
		BINDNAME(GX_Init)
		BINDNAME(GX_SetCopyClear)
		BINDNAME(GX_SetViewport)
		BINDNAME(GX_GetYScaleFactor)
		BINDNAME(GX_SetDispCopyYScale)
		BINDNAME(GX_SetScissor)
		BINDNAME(GX_SetPixelFmt)
	END_PACKAGE()
	
	//wiiuse/wpad.h
	FFI_CDEF(
"		enum {\n"
"			WPAD_BUTTON_2 = 0x0001,\n"
"			WPAD_BUTTON_1 = 0x0002,\n"
"			WPAD_BUTTON_B = 0x0004,\n"
"			WPAD_BUTTON_A = 0x0008,\n"
"			WPAD_BUTTON_MINUS = 0x0010,\n"
"			WPAD_BUTTON_HOME = 0x0080,\n"
"			WPAD_BUTTON_LEFT = 0x0100,\n"
"			WPAD_BUTTON_RIGHT = 0x0200,\n"
"			WPAD_BUTTON_DOWN = 0x0400,\n"
"			WPAD_BUTTON_UP = 0x0800,\n"
"			WPAD_BUTTON_PLUS = 0x1000,\n"
"\n"
"			WPAD_NUNCHUK_BUTTON_Z = 0x0001 << 16,\n"
"			WPAD_NUNCHUK_BUTTON_C = 0x0002 << 16,\n"
"		};\n"
	);
	BEGIN_PACKAGE(wiiuse.wpad)
		BINDNAME(WPAD_Init)
		BINDNAME(WPAD_ScanPads)
		BINDNAME(WPAD_ButtonsDown)
	END_PACKAGE()
	
	lua_pop(L,1);
	
	if (top != lua_gettop(L)) { printf("old top %d new top %d\n", top, lua_gettop(L)); }
}

int main(int argc, char** argv){
	// main function. Always starts first
 
	printf("\x1b[2;0H");

	{
#if 0
		void *xfbK0 = NULL;
		void *xfb = NULL;
		GXRModeObj *rmode = NULL;		
		VIDEO_Init();
		WPAD_Init();
		rmode = VIDEO_GetPreferredMode(NULL);
		xfbK0 = SYS_AllocateFramebuffer(rmode);
		xfb = MEM_K0_TO_K1(xfbK0);
		CON_Init(xfb,20,20,rmode->fbWidth,rmode->xfbHeight,rmode->fbWidth*VI_DISPLAY_PIX_SZ);
		VIDEO_Configure(rmode);
		VIDEO_SetNextFramebuffer(xfb);
		VIDEO_SetBlack(FALSE);
		VIDEO_Flush();
		VIDEO_WaitVSync();
		if(rmode->viTVMode&VI_NON_INTERLACE) VIDEO_WaitVSync();
		printf("\x1b[2;0H");
#endif
	}
	//init filesystem
	if (!fatInitDefault()) {
		fprintf(stderr, "fatInitDefault failure: terminating\n");
		return 0;
	}
	
	//chdir to binary location
	{
		char wd[512];
		int i = strlen(argv[0]);
		for (; argv[0][i] != '/' && i > 0; i--);
		memcpy(wd, argv[0], i);
		wd[i] = 0;
		chdir(wd);
	}
	
	//run "init.lua" in cwd
	{
		int error;
		lua_State *L = luaL_newstate();
		luaL_openlibs(L);
	
		initLuaBindings(L);
		
		error = luaL_loadfile(L, "init.lua");
		if (error) {
			fprintf(stderr, "%s", lua_tostring(L, -1));
		} else {
			luaSafeCall(L, 0, 0);
		}

		lua_close(L);
	}
	
	fatUnmount(NULL);
 
    return 0;
}


