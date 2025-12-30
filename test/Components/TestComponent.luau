local Comet = require(game.ReplicatedStorage.Comet)

return function()
    local component = {}

    component.Name = "Test!"

    local Body: Comet.Body

    function component.Init(body)
        Body = body
        error("wow")
    end

    function component.Start()
       print("Hello from this component!")
       print(Body)
    end

    function component.Update(dt)
        print(dt)
    end

    return component
end