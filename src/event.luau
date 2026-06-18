--!strict
--!nolint LocalShadow

--[[
Simple system allowing for creation of simple events.
]]

local types = require("./types")

type DevConnection<T...> = types.Connection<T...> & {
	_callback: (T...) -> (),
}
type DevEvent<T...> = types.Event<T...> & {
    _connections: {[number]: DevConnection<T...>}
}

local events = {}

local function createConnection(callback: (...any) -> (), OnDisconnect: () -> ())
	return {
		Disconnect = function(self)
			if self.connected == false then
				return
			end
			self.connected = false
			OnDisconnect()
		end,
		_callback = callback,
		connected = true,
	}
end

function events.createEvent<T...>(): types.Event<T...>
	local lastConnectionId = 0
	return {
	    _connections = {},
		Connect = function(self, callback): types.Connection<T...>
		    local self = self:: DevEvent<T...>

			lastConnectionId += 1
			local id = lastConnectionId
			local connection = createConnection(callback, function()
				self._connections[id] = nil
			end)

			self._connections[id] = connection

			return connection
		end,
		Fire = function(self, ...)
		    local self = self:: DevEvent<T...>
			for _, connection in pairs(self._connections) do
				connection._callback(...)
			end
		end,
		Destroy = function(self)
            for key, _ in pairs(self) do
                self[key] = nil
            end

            table.freeze(self)
		end,
	}
end

return events
