--!strict

local core = require("@self/core")
local events = require("@self/events")
local types = require("@self/types")

type Entity = types.Entity
type ComponentData<T> = types.ComponentData<T>

local Comet = {}

function Comet.Entity(Components: { [number]: ComponentData<any> }): Entity
	local entity = core.CreateEntity()

	for _, component in pairs(Components) do
		core.AddComponent(component.id, entity, component.data)
	end

	return entity
end

function Comet.CreateComponent<T>(id: string)
	local componentStorage = core.CreateComponent(id)

	return componentStorage, function(x: T): ComponentData<T>
		return {
			id = id,
			data = x,
		}
	end
end

function Comet.Destroy(entity: Entity)
	core.DestroyEntity(entity)
end

Comet.Event = events.createEvent

table.freeze(Comet)
return Comet
