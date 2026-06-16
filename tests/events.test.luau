local test = require("@std/test")
local events = require("../src/events")

test.case("EventCreation", function(asserts)
    local event = events.createEvent<<(number)>>()

    if event == nil then
        error("createEvent() didn't return anything!")
    end
end)

test.case("EventFire", function(asserts)
    local event = events.createEvent()

    local fired = false
    event:Connect(function()
        fired = true
    end)

    event:Fire()

    if fired == false then
        error("Event didn't fire connections!")
    end
end)

test.case("EventArgs", function(asserts)
    local event = events.createEvent<<(number)>>()

    local passedNumber = 5
    event:Connect(function(num)
        asserts.eq(passedNumber, num)
    end)

    event:Fire(passedNumber)
end)

test.case("EventDisconnect", function(asserts)
    local event = events.createEvent()

    local disconnected = false
    local connection = event:Connect(function(num)
        if disconnected then
            error("Disconnected Connection didn't stop callback!")
        end
    end)

    event:Fire()
    disconnected = true
    connection:Disconnect()
    event:Fire()
end)
