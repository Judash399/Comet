--!strict

local cometError = require("@self/error")
local core = require("@self/core")
local events = require("@self/event")
local types = require("@self/types")

type Entity = types.Entity
type ComponentData<T> = types.ComponentData<T>

local Comet = {}

Comet.Lifecycle = {
	EntityCreated = events.createEvent<<(types.Entity)>>(),
	EntityDestroying = events.createEvent<<(types.Entity)>>(),
}

function Comet.Entity(Components: { [number]: ComponentData<any> }): Entity
	local entity = core.CreateEntity()

	for _, component in pairs(Components) do
		core.AddComponent(component.id, entity, component.data)
	end

	Comet.Lifecycle.EntityCreated:Fire(entity)

	return entity
end

function Comet.System(id: string, callback: types.System): () -> ()
	core.CreateSystem(id, callback)

	return function()
		core.DestroySystem(id)
	end
end

function Comet.Run(deltaTime: number)
	for id, callback in core.Systems do
		--Have to cast callback because type solver stuff.
		local success, result = pcall(callback :: (number) -> nil, deltaTime)

		if success == false then
			cometError(`An error occured when running system '{id}' callback! Error: {result}`)
		end
	end
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
	Comet.Lifecycle.EntityDestroying:Fire(entity)
	core.DestroyEntity(entity)
end

Comet.Event = events.createEvent

table.freeze(Comet)
return Comet
