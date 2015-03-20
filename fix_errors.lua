require 'ext'
local codefn = 'source/binding_GLUT.cpp'
local cfn = [[c:/Users/Tim/Documents/chris/Projects/wii/wii-sdl-luajit/source/binding_GLUT.cpp]]
local ccode = io.readfile(codefn):split('\n')
function apply()
	ls = io.readfile('err.txt'):split('\n')
	lines=ls:filter(
		function(l) return l:sub(1,#cfn) == cfn and (l:find('undefined reference') or l:find('was not declared'))
	end):map(
		function(l) return assert(tonumber((l:sub(#cfn+1):match(':(%d-):'))))
	end)
	lines:sort()
	for _,n in ipairs(lines) do ccode[n] = '//'..ccode[n] ccode[n-14+109] = '//'..ccode[n-14+109] end
	io.writefile(codefn, ccode:concat('\n'))
	_'make 2> err.txt'
end
apply()
