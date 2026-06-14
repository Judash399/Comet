--!strict

local Comet = require(game.ReplicatedStorage.Comet)

--Refrences
local Entity = Comet.Entity
local Children = Comet.Children

local testEntity = Entity {
	Children {
		Entity {}
	}
}

print(Comet)
