local ffi = require 'ffi'
local gl = require 'ffi.gl'
local class = require 'ext.class'

local GLShader = class()
function GLShader:init(code)
	self.id = gl.glCreateShader(self.type)
	local len = ffi.new('int[1]')
	len[0] = #code
	local strs = ffi.new('const char*[1]')
	strs[0] = code
	gl.glShaderSource(self.id, 1, strs, len)
	gl.glCompileShader(self.id)
	
	local status = ffi.new('int[1]')
	gl.glGetShaderiv(self.id, gl.GL_COMPILE_STATUS, status)
	if status[0] == gl.GL_FALSE then
		local length = ffi.new('int[1]')
		gl.glGetShaderiv(self.id, gl.GL_INFO_LOG_LENGTH, length)
		local log = ffi.new('char[?]',length[0]+1)
		local result = ffi.new('size_t[1]')
		gl.glGetShaderInfoLog(self.id, length[0], result, log);
		print('log: '..ffi.string(log))
		print('code:\n'..code)
		error("compile failed")
	end 
end

return GLShader
