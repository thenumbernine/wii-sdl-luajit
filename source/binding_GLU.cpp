#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <malloc.h>
#include <math.h>
#include <gccore.h>
#include <string.h>

#include <GL/glu.h>

#include "lua_util.h"

template<> GLUnurbs* luaGetValue<GLUnurbs*>(lua_State *L, int i) { return cdataToPtr<GLUnurbs*>(L, i); }
template<> void luaPushValue<GLUnurbs*>(lua_State *L, GLUnurbs* const& returnValue) {  FFI_CAST("GLUnurbs*", (GLUnurbs*)returnValue); }

template<> GLUquadric* luaGetValue<GLUquadric*>(lua_State *L, int i) { return cdataToPtr<GLUquadric*>(L, i); }
template<> void luaPushValue<GLUquadric*>(lua_State *L, GLUquadric* const& returnValue) {  FFI_CAST("GLUquadric*", (GLUquadric*)returnValue); }

template<> GLUtesselator* luaGetValue<GLUtesselator*>(lua_State *L, int i) { return cdataToPtr<GLUtesselator*>(L, i); }
template<> void luaPushValue<GLUtesselator*>(lua_State *L, GLUtesselator* const& returnValue) {  FFI_CAST("GLUtesselator*", (GLUtesselator*)returnValue); }

//BINDFUNC(void, gluBeginCurve , GLUnurbs*)
BINDFUNC(void, gluBeginPolygon , GLUtesselator*)
//BINDFUNC(void, gluBeginSurface , GLUnurbs*)
//BINDFUNC(void, gluBeginTrim , GLUnurbs*)
BINDFUNC(GLint, gluBuild1DMipmapLevels , GLenum, GLint, GLsizei, GLenum, GLenum, GLint, GLint, GLint, const void *)
BINDFUNC(GLint, gluBuild1DMipmaps , GLenum, GLint, GLsizei, GLenum, GLenum, const void *)
BINDFUNC(GLint, gluBuild2DMipmapLevels , GLenum, GLint, GLsizei, GLsizei, GLenum, GLenum, GLint, GLint, GLint, const void *)
BINDFUNC(GLint, gluBuild2DMipmaps , GLenum, GLint, GLsizei, GLsizei, GLenum, GLenum, const void *)
//BINDFUNC(GLint, gluBuild3DMipmapLevels , GLenum, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, GLint, GLint, GLint, const void *)
//BINDFUNC(GLint, gluBuild3DMipmaps , GLenum, GLint, GLsizei, GLsizei, GLsizei, GLenum, GLenum, const void *)
BINDFUNC(GLboolean, gluCheckExtension , const GLubyte *, const GLubyte *)
BINDFUNC(void, gluCylinder , GLUquadric*, GLdouble, GLdouble, GLdouble, GLint, GLint)
//BINDFUNC(void, gluDeleteNurbsRenderer , GLUnurbs*)
BINDFUNC(void, gluDeleteQuadric , GLUquadric*)
BINDFUNC(void, gluDeleteTess , GLUtesselator*)
BINDFUNC(void, gluDisk , GLUquadric*, GLdouble, GLdouble, GLint, GLint)
//BINDFUNC(void, gluEndCurve , GLUnurbs*)
BINDFUNC(void, gluEndPolygon , GLUtesselator*)
//BINDFUNC(void, gluEndSurface , GLUnurbs*)
//BINDFUNC(void, gluEndTrim , GLUnurbs*)
BINDFUNC(const GLubyte *, gluErrorString , GLenum)
//BINDFUNC(void, gluGetNurbsProperty , GLUnurbs*, GLenum, GLfloat*)
BINDFUNC(const GLubyte *, gluGetString , GLenum)
BINDFUNC(void, gluGetTessProperty , GLUtesselator*, GLenum, GLdouble*)
//BINDFUNC(void, gluLoadSamplingMatrices , GLUnurbs*, const GLfloat *, const GLfloat *, const GLint *)
BINDFUNC(void, gluLookAt , GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble, GLdouble)
//BINDFUNC(GLUnurbs*, gluNewNurbsRenderer)
BINDFUNC(GLUquadric*, gluNewQuadric)
BINDFUNC(GLUtesselator*, gluNewTess)
BINDFUNC(void, gluNextContour , GLUtesselator*, GLenum)
//BINDFUNC(void, gluNurbsCallback , GLUnurbs*, GLenum, _GLUfuncptr)
//BINDFUNC(void, gluNurbsCallbackData , GLUnurbs*, GLvoid*)
//BINDFUNC(void, gluNurbsCallbackDataEXT , GLUnurbs*, GLvoid*)
//BINDFUNC(void, gluNurbsCurve , GLUnurbs*, GLint, GLfloat *, GLint, GLfloat *, GLint, GLenum)
//BINDFUNC(void, gluNurbsProperty , GLUnurbs*, GLenum, GLfloat)
//BINDFUNC(void, gluNurbsSurface , GLUnurbs*, GLint, GLfloat*, GLint, GLfloat*, GLint, GLint, GLfloat*, GLint, GLint, GLenum)
BINDFUNC(void, gluOrtho2D , GLdouble, GLdouble, GLdouble, GLdouble)
BINDFUNC(void, gluPartialDisk , GLUquadric*, GLdouble, GLdouble, GLint, GLint, GLdouble, GLdouble)
BINDFUNC(void, gluPerspective, GLdouble, GLdouble, GLdouble, GLdouble);
BINDFUNC(void, gluPickMatrix , GLdouble, GLdouble, GLdouble, GLdouble, GLint *)
BINDFUNC(GLint, gluProject , GLdouble, GLdouble, GLdouble, const GLdouble *, const GLdouble *, const GLint *, GLdouble*, GLdouble*, GLdouble*)
//BINDFUNC(void, gluPwlCurve , GLUnurbs*, GLint, GLfloat*, GLint, GLenum)
//BINDFUNC(void, gluQuadricCallback , GLUquadric*, GLenum, _GLUfuncptr)
BINDFUNC(void, gluQuadricDrawStyle , GLUquadric*, GLenum)
BINDFUNC(void, gluQuadricNormals , GLUquadric*, GLenum)
BINDFUNC(void, gluQuadricOrientation , GLUquadric*, GLenum)
BINDFUNC(void, gluQuadricTexture , GLUquadric*, GLboolean)
BINDFUNC(GLint, gluScaleImage , GLenum, GLsizei, GLsizei, GLenum, const void *, GLsizei, GLsizei, GLenum, GLvoid*)
BINDFUNC(void, gluSphere , GLUquadric*, GLdouble, GLint, GLint)
BINDFUNC(void, gluTessBeginContour , GLUtesselator*)
BINDFUNC(void, gluTessBeginPolygon , GLUtesselator*, GLvoid*)
//BINDFUNC(void, gluTessCallback , GLUtesselator*, GLenum, _GLUfuncptr)
BINDFUNC(void, gluTessEndContour , GLUtesselator*)
BINDFUNC(void, gluTessEndPolygon , GLUtesselator*)
BINDFUNC(void, gluTessNormal , GLUtesselator*, GLdouble, GLdouble, GLdouble)
BINDFUNC(void, gluTessProperty , GLUtesselator*, GLenum, GLdouble)
BINDFUNC(void, gluTessVertex , GLUtesselator*, GLdouble *, GLvoid*)
BINDFUNC(GLint, gluUnProject , GLdouble, GLdouble, GLdouble, const GLdouble *, const GLdouble *, const GLint *, GLdouble*, GLdouble*, GLdouble*)
BINDFUNC(GLint, gluUnProject4 , GLdouble, GLdouble, GLdouble, GLdouble, const GLdouble *, const GLdouble *, const GLint *, GLdouble, GLdouble, GLdouble*, GLdouble*, GLdouble*, GLdouble*)

void init_binding_GLU(lua_State *L) {
	int ffi = lua_gettop(L);

	FFI_CDEF_FILE("include/GLU_types.h");
	BEGIN_PACKAGE(glu)

//BINDNAME(gluBeginCurve)
BINDNAME(gluBeginPolygon)
//BINDNAME(gluBeginSurface)
//BINDNAME(gluBeginTrim)
BINDNAME(gluBuild1DMipmapLevels)
BINDNAME(gluBuild1DMipmaps)
BINDNAME(gluBuild2DMipmapLevels)
BINDNAME(gluBuild2DMipmaps)
//BINDNAME(gluBuild3DMipmapLevels)
//BINDNAME(gluBuild3DMipmaps)
BINDNAME(gluCheckExtension)
BINDNAME(gluCylinder)
//BINDNAME(gluDeleteNurbsRenderer)
BINDNAME(gluDeleteQuadric)
BINDNAME(gluDeleteTess)
BINDNAME(gluDisk)
//BINDNAME(gluEndCurve)
BINDNAME(gluEndPolygon)
//BINDNAME(gluEndSurface)
//BINDNAME(gluEndTrim)
BINDNAME(gluErrorString)
//BINDNAME(gluGetNurbsProperty)
BINDNAME(gluGetString)
BINDNAME(gluGetTessProperty)
//BINDNAME(gluLoadSamplingMatrices)
BINDNAME(gluLookAt)
//BINDNAME(gluNewNurbsRenderer)
BINDNAME(gluNewQuadric)
BINDNAME(gluNewTess)
BINDNAME(gluNextContour)
//BINDNAME(gluNurbsCallback)
//BINDNAME(gluNurbsCallbackData)
//BINDNAME(gluNurbsCallbackDataEXT)
//BINDNAME(gluNurbsCurve)
//BINDNAME(gluNurbsProperty)
//BINDNAME(gluNurbsSurface)
BINDNAME(gluOrtho2D)
BINDNAME(gluPartialDisk)
BINDNAME(gluPerspective)
BINDNAME(gluPickMatrix)
BINDNAME(gluProject)
//BINDNAME(gluPwlCurve)
//BINDNAME(gluQuadricCallback)
BINDNAME(gluQuadricDrawStyle)
BINDNAME(gluQuadricNormals)
BINDNAME(gluQuadricOrientation)
BINDNAME(gluQuadricTexture)
BINDNAME(gluScaleImage)
BINDNAME(gluSphere)
BINDNAME(gluTessBeginContour)
BINDNAME(gluTessBeginPolygon)
//BINDNAME(gluTessCallback)
BINDNAME(gluTessEndContour)
BINDNAME(gluTessEndPolygon)
BINDNAME(gluTessNormal)
BINDNAME(gluTessProperty)
BINDNAME(gluTessVertex)
BINDNAME(gluUnProject)
BINDNAME(gluUnProject4)

	END_PACKAGE()
}

