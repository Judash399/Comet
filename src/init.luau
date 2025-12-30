local Comet = {}

--A object part of a Universe.
export type Body = {
    Type: "Body",
    Name: string,
    Parent: Body?, --Not required to be parented.
    Children: {Body},
    Tags: {string},
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
    

    self.Tags = {}

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
        Tag: {string} | string?,
        [number]: any?,
    }): Body

        local body = {}

        body.Name = props.Name
        body._UniqueID = generateID()
        body._Universe = self
        table.insert(self._Bodys, body)
        
        if props.Tag then
            if type(props.Tag) == "string" then
                body.Tags = {props.Tag}
            else
                body.Tags = props.Tag
            end
        else
            body.Tags = {}
        end

        body.Children = {}

        for _, child in body.Children do
            Comet.Parent(child, body)
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

--Parents a body or list of bodys to the given body.
function Comet.add(body: Body, ToAdd: {Body} | Body)
    if ToAdd.Type == "Body" then
        table.insert(body.Children, ToAdd)
        ToAdd.Parent = body
    end

    for _, child in pairs(ToAdd) do
        Comet.Parent(body, child)
    end
end

function Comet.Parent(body: Body, newParent: Body)
    local pastParent = body.Parent
    if pastParent ~= nil then
       table.remove(pastParent.Children, table.find(pastParent.Children, body)) 
    end

    body.Parent = newParent
    if newParent ~= nil then
       table.insert(newParent.Children, body) 
    end
end

--Parents a body and its children to nil and emptys the table, allowing it to garbage collect when all strong refrences are lost.
function Comet.Destroy(body: Body)
    local toDestroy = Comet.Descendants(body)
    table.insert(toDestroy, body)

    for _, child in ipairs(toDestroy) do
       Comet.Parent(child, nil)

        for key, _ in pairs(child) do
            child[key] = nil
        end

        table.freeze(child)
    end
end

--Adds the given tags to the body.
function Comet.Tag(body: Body, ...: {string} | string)
    local tags = {}

    for _, tag in pairs({...}) do
        if type(tag) == "string" then
            table.insert(tags, tag)
        elseif type(tag) == "table" then
            for _, innerTag in pairs(tag) do
                table.insert(tags, innerTag)
            end
        end
    end

    for _, tag in ipairs(tags) do
        if not Comet.HasTag(body, tag) then
            table.insert(body.Tags, tag)
        end
    end
end

--Removes the given tags from the body if they exist.
function Comet.RemoveTag(body: Body, ...: {string} | string)
    local toRemove = {}

    for _, tag in pairs({...}) do
        if type(tag) == "string" then
            table.insert(toRemove, tag)
        elseif type(tag) == "table" then
            for _, innerTag in pairs(tag) do
                table.insert(toRemove, innerTag)
            end
        end
    end

    for _, tag in ipairs(toRemove) do
        local key = table.find(body.Tags, tag)
        if type(key) == "number" then
            table.remove(body.Tags, key)
        end
    end
end

--Returns the list of tags a body has.
function Comet.GetTags(body: Body): {string}
    return body.Tags
end

--Returns a boolean determining if a body has the given tag or not.
function Comet.HasTag(body: Body, tag: string): boolean
    local tags = Comet.GetTags(body)

    return table.find(tags, tag) ~= nil
end

--Returns a list of bodys that have the passed tag in the given universe.
function Comet.GetTagged(Universe: Universe, tag: string): (Body)
    local tagged = {}

    for _, body in pairs(Universe._Bodys) do
        if Comet.HasTag(body, tag) then
            table.insert(tagged, body)
        end
    end

    return tagged
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

    for _, child in ipairs(body.Children) do
        table.insert(queue, child)
    end

    while #queue > 0 do
        local current = table.remove(queue, 1)
        table.insert(descendants, current)

        for _, child in ipairs(current.Children) do
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

table.freeze(Comet)
return Comet