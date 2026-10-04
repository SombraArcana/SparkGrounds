--!strict
-- PreviewPool003 (SPEC-003): object pool genérico, sem `game`, sem UI.
-- Factory injetada cria o objeto; o pool só controla reuso. Zero alloc quente após o pico.

local PreviewPool003 = {}
PreviewPool003.__index = PreviewPool003

function PreviewPool003.new(createFn: () -> any): any
	return setmetatable({
		_createFn = createFn,
		_free = {},
		_active = {},
		_created = 0,
	}, PreviewPool003)
end

function PreviewPool003:acquire(): any
	local free: { any } = self._free
	local active: { any } = self._active
	local obj: any
	if #free > 0 then
		obj = free[#free]
		free[#free] = nil
	else
		obj = self._createFn()
		self._created += 1
	end
	table.insert(active, obj)
	return obj
end

function PreviewPool003:release(obj: any)
	local active: { any } = self._active
	for i = #active, 1, -1 do
		if active[i] == obj then
			table.remove(active, i)
			table.insert(self._free, obj)
			return
		end
	end
end

function PreviewPool003:releaseAll()
	local active: { any } = self._active
	local free: { any } = self._free
	for i = #active, 1, -1 do
		table.insert(free, active[i])
		active[i] = nil
	end
end

function PreviewPool003:activeCount(): number
	return #self._active
end

function PreviewPool003:totalCount(): number
	return #self._free + #self._active
end

return PreviewPool003
