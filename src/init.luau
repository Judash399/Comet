local Comet = {}

--A object part of a Universe.
export type Body = {
    Type: "Body",
    Name: string,
    Parent: Body?, --Not required to be parented.
    Children: {Body},
    Components: {Component}?,
}

--A root container for Bodies.
export type Universe = Body | typeof(Comet.Universe())

export type Component = {
    Name: string, --Unique Identifier used for certain helper methods.
    Start: (Body) -> ()?,
    Update: (dt: number) -> ()?,
}

--Calls a function safely.
local function SafeCall(tbl: {}, key: any, ...: any)
    local func = tbl[key]
    if typeof(func) == "function" then
        local success, result = pcall(func, ...)
        
        return success, result
    end

    return true
end

local uniqueID = 0
local function generateID()
    uniqueID += 1
    return tostring(uniqueID)
end

--Creates a new Universe.
function Comet.Universe()
    local self = {}

    self.Name = "Universe"

    self.Children = {}:: {Body}

    self._Bodys = setmetatable({}, {__mode = "v"})

    --Calls update on all Bodys that are part of this universe.
    function self.update(self: Universe, dt: number)
        for _, body in pairs(self._Bodys) do
            body:update(dt)
        end
    end

    function self.Body(self: Universe, props: {
        Name: string?,
        Children: {Body}?,
        [number]: any?,
    }): Body

        local body = {}

        body.Name = props.Name
        body._UniqueID = generateID()
        body._Universe = self
        table.insert(self._Bodys, body)

        body.Children = props.Children or {}

        for _, child in body.Children do
            child.Parent = body
        end

        body.Parent = nil

        local components = {}

        for _, component in ipairs(props) do
            table.insert(components, component)
        end

        body.Components = components

        for _, component in pairs(body.Components) do
            local success, result = SafeCall(component, "Init", body)

            if success == false then
                warn(`Error running Init on body '{body.Name or "UnknownBody"}', component '{component.Name or "UnknownComponent"}' : {result}`)
            end
        end

        for _, component in pairs(body.Components) do
            local success, result = SafeCall(component, "Start")

            if success == false then
                warn(`Error running Start on body '{body.Name or "UnknownBody"}', component '{component.Name or "UnknownComponent"}' : {result}`)
            end
        end

        function body.update(self, dt)
            for _, component in pairs(self.Components) do
                local success, result = SafeCall(component, "Update", dt)

                if success == false then
                    warn(`Error running Update on body '{body.Name or "UnknownBody"}', component '{component.Name or "UnknownComponent"}' : {result}`)
                end
            end
        end

        return body
    end

    return self
end

function Comet.add(body: Body, ToAdd: {Body} | Body)
    if ToAdd.Type == "Body" then
        table.insert(body.Children, ToAdd)
        ToAdd.Parent = body
    end

    for _, child in pairs(ToAdd) do
      table.insert(body.Children, child)
      child.Parent = body
    end
end

table.freeze(Comet)
return Comet