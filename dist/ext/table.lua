table.__index = table

function table.new(...)
	local t = setmetatable({}, table)
	for _,o in ipairs{...} do
		for k,v in pairs(o) do
			t[k] = v
		end
	end
	return t
end

setmetatable(table, {
	__call = function(t, ...)
		return table.new(...)
	end
})

-- something to consider:
-- mapvalue() returns a new table
-- but append() modifies the current table
-- for consistency shouldn't append() create a new one as well?
function table:append(...)
	for _,u in ipairs{...} do
		for _,v in ipairs(u) do
			table.insert(self, v)
		end
	end
	return self
end

function table:removeKeys(...)
	for _,v in ipairs{...} do
		self[v] = nil
	end
end

-- cb(value[, key]) returns newvalue[, newkey]
-- nil newkey means use the old key
function table:map(cb)
	local t = table.new()
	for k,v in pairs(self) do
		local nv, nk = cb(v,k,t)
		if not nk then nk = k end
		t[nk] = nv
	end
	return t
end


-- this excludes keys that don't pass the callback function
-- if the key is an ineteger then it is table.remove'd
-- (which might be a bit too flexible for my tastes)
function table:filter(f)
	local t = table.new()
	if type(f) == 'function' then 
		for k,v in pairs(self) do
			if f(v,k) then
				if type(k) == 'string' then
					t[k] = v
				else
					t:insert(v)
				end
			end
		end
	else
		-- I kind of want to do arrays ... but should we be indexing the keys or values?
		-- or separate functions for each?
		error('table.filter second arg must be a function')
	end
	return t
end

function table:keys()
	local t = table()
	for k,_ in pairs(self) do
		t:insert(k)
	end
	return t
end

-- should we have separate finds for pairs and ipairs?
function table:find(value, eq)
	if eq then
		for k,v in pairs(self) do
			if eq(v, value) then return k, v end
		end
	else
		for k,v in pairs(self) do
			if v == value then return k, v end
		end
	end
end

-- should insertUnique only operate on the pairs() ?
-- 	especially when insert() itself is an ipairs() operation
function table:insertUnique(value, eq)
	if not table.find(self, value, eq) then table.insert(self, value) end
end

function table:removeObject(...)
	local removedKeys = table()
	local len = #self
	local k = table.find(self, ...)
	while k ~= nil do
		if type(k) == 'number' and tonumber(k) <= len then
			table.remove(self, k)
		else
			self[k] = nil
		end
		removedKeys:insert(k)
		k = table.find(self, ...)
	end
	return unpack(removedKeys)
end

-- I need to think of a better name for this... kvpairs() ?
function table:kvmerge()
	local t = table.new()
	for k,v in pairs(self) do
		table.insert(t, {k,v})
	end
	return t
end

-- TODO - math instead of table?
function table:sup()
	local best
	for _,v in pairs(self) do
		if best == nil or v > best then best = v end
	end
	return best
end

-- TODO - math instead of table?
function table:inf()
	local best
	for _,v in pairs(self) do
		if best == nil or v < best then best = v end
	end
	return best
end

