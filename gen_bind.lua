require 'ext'
local d = io.readfile(arg[1])
local ls = d:trim():split('\n')
ls = ls:map(function(l)
	local ret, name, params = l:match('(.*)%s+(%S*)%((.*)%);')
	name = name:trim()
	params = params:trim():split(','):map(function(param,i,t)
		return param:trim():match('^(.-)%w+$'), #t+1
	end):filter(function(l,i)
		if l == '' then
			assert(i == 1)
			return false
		end
		return true
	end)
	local parts = table{ret,name}:append(params)
	return parts
end)

print(ls:map(function(l)
	return 'BINDFUNC('..l:concat(', ')..')'
end):concat('\n'))

print()
print(ls:map(function(l)
	return 'BINDNAME('..l[2]..')'
end):concat('\n'))
