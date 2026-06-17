--!strict

--[[
The core of Comet's ECS system. Stores central tables related to Entitys, and Components.
NOTE: It is unsafe to call these methods directly please use the top level functions!
]]
local types = require("./types")

local core = {}

core.Components = {} :: { [string]: types.Component<any> }

local lastEntityId = 0
function core.CreateEntity()
	lastEntityId += 1
	local entity = lastEntityId

	return entity
end

function core.CreateComponent<T>(componentId: string): types.Component<T>
	local componentStorage = {}
	core.Components[componentId] = componentStorage
	return componentStorage
end

function core.AddComponent<T>(componentId: string, entity: types.Entity, data: T)
	local componentStorage = core.Components[componentId]
	if componentStorage == nil then
		error(`[Comet]: Component with ID '{componentId}' is not defined!`)
	end
	componentStorage[entity] = data
end

function core.DestroyEntity(entity: types.Entity)
	for _, componentStorage in pairs(core.Components) do
		componentStorage[entity] = nil
	end
end

return core
