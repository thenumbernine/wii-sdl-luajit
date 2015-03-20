#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>
#include <math.h>
#include <gccore.h>
#include <string.h>

#include <SDL/SDL.h>
#include <SDL/SDL_image.h>

#include "lua_util.h"

BINDFUNC(const SDL_version *, IMG_Linked_Version)
BINDFUNC(SDL_Surface * , IMG_LoadTyped_RW, SDL_RWops *, int , char *)
BINDFUNC(SDL_Surface * , IMG_Load, const char *)
BINDFUNC(SDL_Surface * , IMG_Load_RW, SDL_RWops *, int )
BINDFUNC(int , IMG_InvertAlpha, int )
BINDFUNC(int , IMG_isICO, SDL_RWops *)
BINDFUNC(int , IMG_isCUR, SDL_RWops *)
BINDFUNC(int , IMG_isBMP, SDL_RWops *)
BINDFUNC(int , IMG_isGIF, SDL_RWops *)
BINDFUNC(int , IMG_isJPG, SDL_RWops *)
BINDFUNC(int , IMG_isLBM, SDL_RWops *)
BINDFUNC(int , IMG_isPCX, SDL_RWops *)
BINDFUNC(int , IMG_isPNG, SDL_RWops *)
BINDFUNC(int , IMG_isPNM, SDL_RWops *)
BINDFUNC(int , IMG_isTIF, SDL_RWops *)
BINDFUNC(int , IMG_isXCF, SDL_RWops *)
BINDFUNC(int , IMG_isXPM, SDL_RWops *)
BINDFUNC(int , IMG_isXV, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadICO_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadCUR_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadBMP_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadGIF_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadJPG_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadLBM_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadPCX_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadPNG_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadPNM_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadTGA_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadTIF_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadXCF_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadXPM_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_LoadXV_RW, SDL_RWops *)
BINDFUNC(SDL_Surface * , IMG_ReadXPMFromArray, char **)

void init_binding_SDL_image(lua_State *L) {
	int ffi = lua_gettop(L);

	FFI_CDEF_FILE("include/SDL_image_types.h");
	BEGIN_PACKAGE(sdl_image)

BINDNAME(IMG_Linked_Version)
BINDNAME(IMG_LoadTyped_RW)
BINDNAME(IMG_Load)
BINDNAME(IMG_Load_RW)
BINDNAME(IMG_InvertAlpha)
BINDNAME(IMG_isICO)
BINDNAME(IMG_isCUR)
BINDNAME(IMG_isBMP)
BINDNAME(IMG_isGIF)
BINDNAME(IMG_isJPG)
BINDNAME(IMG_isLBM)
BINDNAME(IMG_isPCX)
BINDNAME(IMG_isPNG)
BINDNAME(IMG_isPNM)
BINDNAME(IMG_isTIF)
BINDNAME(IMG_isXCF)
BINDNAME(IMG_isXPM)
BINDNAME(IMG_isXV)
BINDNAME(IMG_LoadICO_RW)
BINDNAME(IMG_LoadCUR_RW)
BINDNAME(IMG_LoadBMP_RW)
BINDNAME(IMG_LoadGIF_RW)
BINDNAME(IMG_LoadJPG_RW)
BINDNAME(IMG_LoadLBM_RW)
BINDNAME(IMG_LoadPCX_RW)
BINDNAME(IMG_LoadPNG_RW)
BINDNAME(IMG_LoadPNM_RW)
BINDNAME(IMG_LoadTGA_RW)
BINDNAME(IMG_LoadTIF_RW)
BINDNAME(IMG_LoadXCF_RW)
BINDNAME(IMG_LoadXPM_RW)
BINDNAME(IMG_LoadXV_RW)
BINDNAME(IMG_ReadXPMFromArray)

	END_PACKAGE()

}

