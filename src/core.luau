--!strict
local types = require("./types")
local events = require("./events")

--[[
The core of Comet's ECS system. Stores central tables related to Entitys, Components, and Systems.
]]

local core = {}

core.Events = {
    EntityCreated = events.createEvent<<(types.Entity)>>(),
}

core.Components = {}

local lastEntityId = 0
function core.CreateEntity()
	lastEntityId += 1
	local entity = lastEntityId

	core.Events.EntityCreated:Fire(entity)

	return entity
end

return core
