--!strict

type Entity = number

type Component<T> = {
	id: string,
	data: T
}

local Comet = {}

Comet.Events = {
	EntityCreated = {}:: {(Entity) -> ()}
}

Comet._Components = {}:: {
	[string]: {[Entity]: any}
}

local lastEntityId = 0
function Comet.Entity(Components: {[number]: Component<any>}): Entity
	lastEntityId += 1

	local entity = lastEntityId

	for _, component in pairs(Components) do
		local componentList = Comet._Components[component.id]
		componentList[entity] = component.data
	end

	for _, callback in Comet.Events.EntityCreated do
		callback(entity)
	end

	return entity
end

function Comet.CreateComponent<T>(id: string)
	local data: {[Entity]: T} = {}

	Comet._Components[id] = data

	return data, function(x: T): Component<T>
		return {
			id = id,
			data = x
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
local ChildrenList, ChildrenCallback = Comet.CreateComponent<<{Entity}>>("Children")
Comet.Children = ChildrenCallback

--Hierarchy Systems
table.insert(Comet.Events.EntityCreated, function(entity)
	print(entity)
end)

table.freeze(Comet)
return Comet
