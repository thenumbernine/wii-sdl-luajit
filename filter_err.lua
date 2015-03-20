require 'ext'
local ls = table()
for l in io.lines() do
	local ref = l:match("undefined reference to `(.-)'")
	if ref then ls[ref] = true end
end
ls = ls:keys()
ls:sort()
print(ls:concat('\n'))
