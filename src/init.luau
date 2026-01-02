local Comet = {}

--A object part of a Universe.
export type Body = {
    Type: "Body",
    Name: string,
    Parent: Body?, --Not required to be parented.
    _Children: {Body},
    Components: {Component}?,
}

--A root container for Bodies.
export type Universe = Body | typeof(Comet.Universe())

export type Component = {
    Name: string, --Unique Identifier used for certain helper methods.
    Start: (Body) -> ()?,
    Update: (dt: number) -> ()?,
    Destroy: () -> ()?,
}

export type SpecialKey = {
    Type: "SpecialKey",
    Stage: "PreComponents" | "InitComponents" | "PostComponents",
    Name: string?,
    Method: (Body, any) -> (),
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

--Creates a new Universe.
function Comet.Universe()
    local self = {}

    self._IsUniverse = true

    self.Name = "Universe"

    self._Children = {}:: {Body}

    self._Bodys = setmetatable({}, {__mode = "v"})

    self._Universe = self

    --Calls update on all Bodys that are part of this universe.
    function self.update(self: Universe, dt: number)
        for _, body in pairs(self._Bodys) do
            body:update(dt)
        end
    end

    function self.Body(self: Universe, props: {
        any --I'm not aware of a way to be more explicit then this :(
    }): Body

        local body = {}
        body._Universe = self
        table.insert(self._Bodys, body)
        body._Children = {}
        body.Parent = nil

        local specialKeys = {
            PreComponents = {},
            InitComponents = {},
            PostComponents = {},
        }
        local components = {}

        
        --Compile Key data from props
        for key, value in pairs(props) do
            if type(key) == "number" then
                table.insert(components, value)
            elseif type(key) == "table" and key.Type == "SpecialKey" then
                table.insert(specialKeys[key.Stage], {Key = key, Value = value})
            end
        end

        body.Components = components

        -- Pre Special Keys
        for _, key in ipairs(specialKeys.PreComponents) do
            local success, result = pcall(function()
                key.Key.Method(body, key.Value)
            end)

            if success == false then
                warn(`Error running special key '{key.Key.Name or "UnknownSpecialKey"}' : {result}`)
            end
        end

        --Run Init function on Components
        for _, component in pairs(body.Components) do
            local success, result = SafeCall(component, "Init", body)

            if success == false then
                warn(`Error running Init on body '{body.Name or "UnknownBody"}', component '{component.Name or "UnknownComponent"}' : {result}`)
            end
        end

        -- Init Special Keys
        for _, key in ipairs(specialKeys.InitComponents) do
            local success, result = SafeCall(key.Key, "Method", body, key.Value)

            if success == false then
                warn(`Error running special key '{key.Key.Name or "UnknownSpecialKey"}' : {result}`)
            end
        end

        --Run Start function on Components
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

        --Post Special Keys
        for _, key in ipairs(specialKeys.PostComponents) do
            local success, result = pcall(function()
                key.Key.Method(body, key.Value)
            end)

            if success == false then
                warn(`Error running special key '{key.Key.Name or "UnknownSpecialKey"}' : {result}`)
            end
        end

        return body
    end

    return self
end

--Parents a body or list of bodys to the given body.
function Comet.add(body: Body, ToAdd: {Body} | Body)
    if ToAdd.Type == "Body" then
        table.insert(body._Children, ToAdd)
        ToAdd.Parent = body
    end

    for _, child in pairs(ToAdd) do
        Comet.Parent(body, child)
    end
end

function Comet.Parent(newParent: Body, body: Body)
    if body._IsUniverse == true then
        error(`Cannot reparent the Universe!`)
    end
    if table.find(Comet.Descendants(body), newParent) then
        error(`Circular Parenting detected! '{body.Name or "UnkownBody"}' is a decendent of '{newParent.Name or "UnkownBody"}'. Parenting would cause an indefinite loop!`)
    end
    if body._Universe ~= newParent._Universe then
        error(`Cannot parent '{body.Name or "UnkownBody"}' to  '{newParent.Name or "UnkownBody"}' because it is part of another Universe!`)
    end

    local pastParent = body.Parent
    if pastParent ~= nil then
       table.remove(pastParent._Children, table.find(pastParent._Children, body)) 
    end

    body.Parent = newParent
    if newParent ~= nil then
       table.insert(newParent._Children, body)
    end
end

--Parents a body and its children to nil and emptys the table, allowing it to garbage collect when all strong refrences are lost.
function Comet.Destroy(body: Body)
    local toDestroy = Comet.Descendants(body)
    table.insert(toDestroy, body)

    for _, child in ipairs(toDestroy) do
        --You cannot reparent the Universe, But it can be destroyed.
        if child._Universe ~= true then
           Comet.Parent(nil, child) 
        end

        --Run destroy function on components.
        for _, component in ipairs(child.Components) do
            local success, result = SafeCall(component, "Destroy")

            if success == false then
                warn(`Error running Destroy on body '{body.Name or "UnknownBody"}', component '{component.Name or "UnknownComponent"}' : {result}`)
            end
        end

        local key = table.find(child._Universe._Bodys, child)
        if key ~= nil then
            table.remove(child._Universe._Bodys, key)
        end

        for key, _ in pairs(child) do
            child[key] = nil
        end

        table.freeze(child)
    end
end

--Returns a list of every component a body has.
function Comet.GetComponents(body: Body): {Component}
    return body.Components
end

--Returns a bodys component if it has it.
function Comet.GetComponent(body: Body, componentName: string): Component?
    local components = Comet.GetComponents(body)

    for _, component in pairs(components) do
        if component.Name == componentName then
            return component
        end
    end

    return nil
end

--Returns a list of all bodys decending the given body.
function Comet.Descendants(body: Body): {Body}
    local descendants = {}
    local queue = {}

    for _, child in ipairs(body._Children) do
        table.insert(queue, child)
    end

    while #queue > 0 do
        local current = table.remove(queue, 1)
        table.insert(descendants, current)

        for _, child in ipairs(current._Children) do
            table.insert(queue, child)
        end
    end

    return descendants
end

--Returns a list of all bodys with the given name decending the given body.
function Comet.Find(body: Body, name: string)
    local decendents = Comet.Descendants(body)

    local found = {}

    for _, decendent in ipairs(decendents) do
        if decendent.Name == name then
            table.insert(found, decendent)
        end
    end

    return found
end

--Special Keys

Comet.Name = {
    Type = "SpecialKey",
    Stage = "PreComponents",
    Name = "Name",
    Method = function(body, input: string)
        body.Name = input
    end
}:: SpecialKey

Comet.Children = {
    Type = "SpecialKey",
    Stage = "PreComponents",
    Name = "Children",
    Method = function(body, input: {Body})
        for _, child in ipairs(input) do
            Comet.Parent(body, child)
        end
    end
}:: SpecialKey


table.freeze(Comet)
return Comet