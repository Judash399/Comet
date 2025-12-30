<img src="assets/FullLogo.svg" width="500">

A lightweight, Luau native component based game engine.

## Documentation Comming Soon! (Hopefully)
The documentation isnt added, yet. but here is the basic premise.

You require the module and create a `Universe`. then you add Bodys into that universe which have collections of Components which you define.

*Comet* does not have **any** predefined Components. and will likely never.

A basic script would look like:
```luau

local Comet = require(game.ReplicatedStorage.Comet)

--Components
local Movement = require(script.Parent.Components.Movement)

local Universe = Comet.Universe()

Comet.add(Universe, {
    Universe:Body {
        Name = "Object",
        Tag = {"Test"},
        Movement {
            WalkSpeed = 16
        },
    }
})
```


Components are just tables/functions which look like this:
```luau
local Comet = require(game.ReplicatedStorage.Comet)

return function(props: {
    WalkSpeed = 16
})
    local component = {}

    component.Name = "Movement"

    local Body: Comet.Body

    function component.Init(body)

    end

    function component.Start()

    end

    function component.Update(dt)
        
    end

    return component
end
```

Update has to be called manually through: `Universe:update(deltaTime)`. This is to allow *Comet* to work outside of roblox.
