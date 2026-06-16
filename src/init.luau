--!strict

local core = require("@self/core")
local events = require("@self/events")
local types = require("@self/types")

type Entity = types.Entity
type Component<T> = types.Component<T>

local Comet = {}

Comet._Components = {} :: {
	[string]: { [Entity]: any },
}

function Comet.Entity(Components: { [number]: Component<any> }): Entity
	local entity = core.CreateEntity()

	for _, component in pairs(Components) do
		local componentList = Comet._Components[component.id]
		componentList[entity] = component.data
	end

	return entity
end

function Comet.CreateComponent<T>(id: string)
	local data: { [Entity]: T } = {}

	Comet._Components[id] = data

	return data, function(x: T): Component<T>
		return {
			id = id,
			data = x,
		}
	end
end

function Comet.DestroyEntity(entity: Entity)
	for _, componentList in pairs(Comet._Components) do
		componentList[entity] = nil
	end
end

--Hierarchy Components

Comet.Parent = Comet.CreateComponent("Parent")
local ChildrenList, ChildrenCallback = Comet.CreateComponent<<{ Entity }>>("Children")
Comet.Children = ChildrenCallback

--Hierarchy Systems
core.Events.EntityCreated:Connect(function(entity: number)
    print(entity)
end)

table.freeze(Comet)
return Comet
