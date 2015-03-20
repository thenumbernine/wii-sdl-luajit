--[[
current dilemma:
glut works. it's pretty lightweight.
sdl doesn't, it crashes
but for sdl_image's img_load to work we have
to at least call sdl_init(sdl_init_video)
.. and that'll load a texture, but it is in crap format
the best i could find for converting to rgba was
via convertsurface, which is still crap format.
then there's the tried-and-true displayformatalpha
.but that relies on sdl init'ding the display
...
which is buggy
--]]
local ffi = require 'ffi'
local bit = require 'bit'
local wpad = require 'ffi.wiiuse.wpad'
local gl = require 'ffi.gl'
local glu = require 'ffi.glu'
local glut = require 'ffi.glut'
local GLTex2D = require 'gl.tex2d'
local Image = require 'image'
local sdl = require 'ffi.sdl'
local sdlImage = require 'ffi.sdl_image'

wpad.WPAD_Init()

if sdl.SDL_Init(sdl.SDL_INIT_VIDEO) == -1 then
	error("SDL_Init(SDL_INIT_VIDEO) failed")
end
-- TODO if we need to init SDL for the image loader
--  how about learn it for the display?

--[[
local surf = sdlImage.IMG_Load('test.png')

print('flags',surf.flags)
print('format',surf.format)
print('width',surf.w)
print('height',surf.h)
print('pitch',surf.pitch)
print('pixels',surf.pixels)
print('offset',surf.offset)
print('hwdata',surf.hwdata)
print('locked',surf.locked)
print('map',surf.map)
print('format_version',surf.format_version)
print('refcount',surf.refcount)

local rgbaPixelFormat = ffi.new('SDL_PixelFormat[1]')
rgbaPixelFormat[0].palette = nil
rgbaPixelFormat[0].BitsPerPixel = 32
rgbaPixelFormat[0].BytesPerPixel = 4 
rgbaPixelFormat[0].colorkey = 0
rgbaPixelFormat[0].alpha = 0
if false then	--sdl.SDL_BYTE_ORDER == sdl.SDL_BIG_ENDIAN then
	rgbaPixelFormat[0].Rmask = 0xff000000	rgbaPixelFormat[0].Rshift = 0	rgbaPixelFormat[0].Rloss = 0
	rgbaPixelFormat[0].Gmask = 0x00ff0000	rgbaPixelFormat[0].Gshift = 8	rgbaPixelFormat[0].Gloss = 0
	rgbaPixelFormat[0].Bmask = 0x0000ff00 	rgbaPixelFormat[0].Bshift = 16	rgbaPixelFormat[0].Bloss = 0
	rgbaPixelFormat[0].Amask = 0x000000ff	rgbaPixelFormat[0].Ashift = 24	rgbaPixelFormat[0].Aloss = 0
else
	rgbaPixelFormat[0].Rmask = 0x000000ff	rgbaPixelFormat[0].Rshift = 24	rgbaPixelFormat[0].Rloss = 0
	rgbaPixelFormat[0].Gmask = 0x0000ff00	rgbaPixelFormat[0].Gshift = 16	rgbaPixelFormat[0].Gloss = 0
	rgbaPixelFormat[0].Bmask = 0x00ff0000 	rgbaPixelFormat[0].Bshift = 8	rgbaPixelFormat[0].Bloss = 0
	rgbaPixelFormat[0].Amask = 0xff000000	rgbaPixelFormat[0].Ashift = 0	rgbaPixelFormat[0].Aloss = 0
end

print('converting...')
surf = sdl.SDL_ConvertSurface(surf, rgbaPixelFormat, sdl.SDL_SWSURFACE)

print('flags',surf.flags)
print('format',surf.format)
print('width',surf.w)
print('height',surf.h)
print('pitch',surf.pitch)
print('pixels',surf.pixels)
print('offset',surf.offset)
print('hwdata',surf.hwdata)
print('locked',surf.locked)
print('map',surf.map)
print('format_version',surf.format_version)
print('refcount',surf.refcount)

do return end
--]]

-- [[ glut. works.
glut.glutInit(nil,nil)
glut.glutInitDisplayMode(0)
glut.glutCreateWindow('bleh')
--]]
--[[ sdl.  needed to get SDL_DisplayFormatAlpha working -- hopefully to fix image loading.  not working yet.
local width = 640
local height = 480
sdl.SDL_GL_SetAttribute(sdl.SDL_GL_DOUBLEBUFFER, 1)
if sdl.SDL_SetVideoMode(width, height, 16, bit.bor(sdl.SDL_OPENGL, sdl.SDL_FULLSCREEN)) == nil then 
	error("Couldn't set video mode: "..sdl.SDL_GetError())
end
gl.glViewport(0, 0, width, height)
--]]


--[[
this is glutMainLoop() :
displayfunc(); while (1) idlefunc();
not exactly quality, but easy to bypass 
considering ffi doesn't cope well (perf or otherwise)
with function pointer
--]]

-- [[ via GLUT (uses fbWidth,efbHeight)
local width = glut.glutGet(glut.GLUT_SCREEN_WIDTH)
local height = glut.glutGet(glut.GLUT_SCREEN_HEIGHT)
--]]
--[[ via GL (uses viWidth, viHeight)
local viewport = ffi.new('GLint[4]')
gl.glGetIntegerv(gl.GL_VIEWPORT, viewport)
local width, height = viewport[2], viewport[3]
--]]

--[[ 3D gl
--]]
--[[ 3D glu
gl.glMatrixMode(gl.GL_PROJECTION)
gl.glLoadIdentity()
glu.gluPerspective(45, width/height, .1, 100)
gl.glMatrixMode(gl.GL_MODELVIEW)
gl.glLoadIdentity()
gl.glTranslatef(0,0,-6)
--]]
-- [[ 2D
gl.glMatrixMode(gl.GL_PROJECTION)
gl.glLoadIdentity()
gl.glOrtho(-2, 2, -2, 2, -2, 2)
gl.glMatrixMode(gl.GL_MODELVIEW)
gl.glLoadIdentity()
--]]

--[[  
local tex = GLTex2D('test.png')
tex:bind()
tex:enable()
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)
gl.glTexEnvf(gl.GL_TEXTURE_ENV, gl.GL_TEXTURE_ENV_MODE, gl.GL_DECAL)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAX_LEVEL, 0)
--]]
-- [[
local img = Image('test.png')
local tex = GLTex2D{
	internalFormat = gl.GL_RGBA,
	format = gl.GL_RGBA,
	type = gl.GL_UNSIGNED_BYTE,
	image = img,
}
tex:bind()
tex:enable()
gl.glTexEnvf(gl.GL_TEXTURE_ENV, gl.GL_TEXTURE_ENV_MODE, gl.GL_MODULATE)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAX_LEVEL, 0)
--]]
--[[ works 
local w, h = 12, 24
local img = Image(w,h,4)
for v=0,h-1 do
	for u=0,w-1 do
		img(u,v,u/(w-1),v/(h-1),.5)
	end
end
local tex = GLTex2D{
	internalFormat = gl.GL_RGBA,
	width = w,
	height = h,
	format = gl.GL_RGBA,
	type = gl.GL_UNSIGNED_BYTE,
	image = img,	--data = ffi.cast('char*', img.surface.pixels),
}
tex:bind()
tex:enable()
--gl.glTexEnvf(gl.GL_TEXTURE_ENV, gl.GL_TEXTURE_ENV_MODE, gl.GL_MODULATE)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAX_LEVEL, 0)
--]]
--[[ works 
local w, h = 16, 16
local data = ffi.new('char[?]', w*h*4)
for v=0,h-1 do
	for u=0,w-1 do
		data[0+4*(u+w*(v))] = math.floor(255*u/(w-1))
		data[1+4*(u+w*(v))] = math.floor(255*v/(w-1))
		data[2+4*(u+w*(v))] = 127
		data[3+4*(u+w*(v))] = 255
	end
end
local tex = GLTex2D{
	internalFormat = gl.GL_RGBA,
	width = w,
	height = h,
	format = gl.GL_RGBA,
	type = gl.GL_UNSIGNED_BYTE,
	data = data,
}
tex:bind()
tex:enable()
--gl.glTexEnvf(gl.GL_TEXTURE_ENV, gl.GL_TEXTURE_ENV_MODE, gl.GL_MODULATE)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAX_LEVEL, 0)
--]]
--[[ works
local w, h, c = 16, 16, 3
local data = ffi.new('char[?]', w*h*c)
for i=0,w*h*c-1 do
	data[i] = math.random(0,255)
end
local tex = ffi.new('GLuint[1]')
gl.glTexEnvf(gl.GL_TEXTURE_ENV, gl.GL_TEXTURE_ENV_MODE, gl.GL_MODULATE)
gl.glGenTextures(1, tex)
gl.glBindTexture(gl.GL_TEXTURE_2D, tex[0])
gl.glTexImage2D(gl.GL_TEXTURE_2D, 0, gl.GL_RGB, w, h, 0, gl.GL_RGB, gl.GL_UNSIGNED_BYTE, data)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MIN_FILTER, gl.GL_NEAREST)
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAG_FILTER, gl.GL_NEAREST)

-- VERY IMPORTANT.  in the old day you just had to set the min filter to nearest.
-- but for wii you have to set them all to have max level to 0
gl.glTexParameteri(gl.GL_TEXTURE_2D, gl.GL_TEXTURE_MAX_LEVEL, 0)

gl.glEnable(gl.GL_TEXTURE_2D)
--]]

gl.glClearColor(0,0,0,0)
local t = os.time()
local done
local eventPtr = ffi.new('SDL_Event[1]')
while os.time() < t + 60 do
	if done then break end
	wpad.WPAD_ScanPads()
	local pressed = wpad.WPAD_ButtonsDown(0)
	if bit.band(pressed, wpad.WPAD_BUTTON_HOME) ~= 0 then
		break
	end

	-- [[ working with glut + sdl_init(video) 
	while sdl.SDL_PollEvent(eventPtr) > 0 do
		if eventPtr[0].type == sdl.SDL_QUIT then
			done = true
		end
	end
	--]]

	gl.glClear(gl.GL_COLOR_BUFFER_BIT)

	gl.glRotatef(1, 0, 1, 0)
	
	gl.glBegin(gl.GL_QUADS)
	gl.glTexCoord2f(0,0)
	gl.glVertex3f(-1,-1,0)
	gl.glTexCoord2f(1,0)
	gl.glVertex3f(1,-1,0)
	gl.glTexCoord2f(1,1)
	gl.glVertex3f(1,1,0)
	gl.glTexCoord2f(0,1)
	gl.glVertex3f(-1,1,0)
	gl.glEnd()

	-- [[ glut
	glut.glutSwapBuffers()
	--]]
	--[[ sdl ... crashes.  call to check gl flag (I don't have set) and then call video->GL_SwapBuffers() (which i see no ogc implementation of)
	sdl.SDL_GL_SwapBuffers()
	--]]
end

sdl.SDL_Quit()
