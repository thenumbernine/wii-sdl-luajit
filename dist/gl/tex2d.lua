local ffi = require 'ffi'
local gl = require 'ffi.gl'
local class = require 'ext.class'
local GLTex = require 'gl.tex'


local GLTex2D = class(GLTex)

GLTex2D.target = gl.GL_TEXTURE_2D

function GLTex2D:create(args)
	self.width = args.width
	self.height = args.height
	gl.glTexImage2D(
		args.target or self.target,
		args.level or 0,
		args.internalFormat,
		args.width,
		args.height,
		args.border or 0,
		args.format,
		args.type,
		args.data)
end

local bit = require 'bit'

local function rupowoftwo(x)
	local u = 1
	x = x - 1
	while x > 0 do
		x = bit.rshift(x,1)
		u = bit.lshift(u,1)
	end
	return u
end

function GLTex2D:load(args)
	local image = args.image
	if not image then
		local filename = tostring(args.filename)
		if not filename then
			error('GLTex2D:load expected image or filename')
		end
		local Image = require 'image'
		image = Image(filename)
	end
	assert(image)
	local w,h = image:size() 
	local data = image:data()

	local nw,nh = rupowoftwo(w), rupowoftwo(h)
	if w ~= nw or h ~= nh then
		local ndata = ffi.cast('char*',ffi.new('char[?]', nw*nh*4))
		for ny=0,nh-1 do
			for nx=0,nw-1 do
				local x = math.floor(nx*(w-1)/(nw-1))
				local y = math.floor(ny*(h-1)/(nh-1))
				for c=0,3 do
					ndata[c+4*(nx+nw*ny)] = data[c+4*(x+w*y)]
				end
			end
		end
		data = ndata
		w,h = nw,nh
	end

	args.width, args.height = w, h
	args.internalFormat = gl.GL_RGBA
	args.format = gl.GL_RGBA
	args.type = gl.GL_UNSIGNED_BYTE
	args.data = data 
end

return GLTex2D
