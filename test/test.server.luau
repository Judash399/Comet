--!strict

--Services
local RunService = game:GetService("RunService")

local Comet = require(game.ReplicatedStorage.Comet)

--Components
local TestComponent = require(script.Parent.Components.TestComponent)

local Universe = Comet.Universe()

Comet.add(Universe, {
    Universe:Body {
        Name = "Player",
        TestComponent(),
    }
})

print(Universe)

RunService.Heartbeat:Connect(function(dt)
    Universe:update(dt)
end)