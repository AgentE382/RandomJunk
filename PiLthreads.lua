-- threads: `List` from PiL 11.4
-- threads.dispatch: `dispatcher()` from PiL 9.4
threads = {
	first = 0, last = -1,
	add = function(list, value)
		local last = list.last + 1
		list.last = last
		list[last] = value
	end,
	getNext = function(list)
		local first = list.first
		if first > list.last then error("list is empty") end
		local value = list[first]
		list[first] = nil        -- to allow garbage collection
		list.first = first + 1
		return value
	end,
	isEmpty = function(list)
		return list.first > list.last
	end,
	dispatch = function(self)
		while not self:isEmpty() do
			local thread = self:getNext()
			local status, res = coroutine.resume(thread)
			if not res then    -- thread finished its task?
				self:add(thread)
			end
		end
	end
}
