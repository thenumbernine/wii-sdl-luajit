local defaultSerializeForType = {
	number = tostring,
	boolean = tostring,
	['nil'] = tostring,
	string = function(v) return ('%q'):format(v) end,
}

function toLua(x, tabchar, newlinechar, serializeForType)
	if not tabchar then tabchar = '\t' end
	if not newlinechar then newlinechar = '\n' end
	local function toLuaKey(k)
		if type(k) == 'string' and k:match('^[_,a-z,A-Z][_,a-z,A-Z,0-9]*$') then
			return k
		else
			return '['..toLuaRecurse(k)..']'
		end
	end
	local touchedTables = {}
	function toLuaRecurse(x, tab)
		if not tab then tab = '' end
		local newtab = tab .. tabchar
		local xtype = type(x)
		if xtype == 'table' then
			-- TODO override for specific metatables?  as I'm doing for types?
			
			if touchedTables[x] then
				return '[recursive reference]'	-- TODO allow recursive serialization by declaring locals before their reference?
			else
				touchedTables[x] = true
				
				-- prelim see if we can write it as an indexed table
				local numx = table.maxn(x)
				local intNilKeys, intNonNilKeys = 0, 0				
				for i=1,numx do
					if x[i] == nil then
						intNilKeys = intNilKeys + 1
					else
						intNonNilKeys = intNonNilKeys + 1
					end
				end

				local s = table()
				
				-- add integer keys without keys explicitly. nil-padded so long as there are 2x values than nils
				local addedIntKeys = {}
				if intNonNilKeys >= intNilKeys * 2 then	-- some metric
					for k=1,numx do
						s:insert(toLuaRecurse(x[k], newtab))
						addedIntKeys[k] = true
					end
				end

				-- sort key/value pairs added here by key
				local mixed = table()
				for k,v in pairs(x) do
					if not addedIntKeys[k] then
						mixed:insert{toLuaKey(k), toLuaRecurse(v, newtab)}
					end
				end
				mixed:sort(function(a,b) return a[1] < b[1] end)	-- sort by keys
				mixed = mixed:map(function(kv) return table.concat(kv, '=') end)
				s:append(mixed)

				local rs = '{'..newlinechar
				if #s > 0 then rs = rs .. newtab ..s:concat(','..newlinechar..newtab) .. newlinechar end
				rs = rs .. tab.. '}'
				return rs
			end
		else
			local serializeFunction
			if serializeForType then
				serializeFunction = serializeForType[xtype]
			end
			if not serializeFunction then
				serializeFunction = defaultSerializeForType[xtype]
			end
			if serializeFunction then
				return serializeFunction(x)
			else
				return '['..type(x)..':'..tostring(x)..']'
			end
		end
	end
	return toLuaRecurse(x)
end
