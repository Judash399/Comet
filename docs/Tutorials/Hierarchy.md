# Managing the Hierarchy
*Comet* goes with many functions to help you manage the Body hierarchy. Below are some commonly used ones.

## `add()`
As already discussed, `add()` lets you parent a list of bodys to another body.
```lua
Comet.add(body, {
    body1,
    body2,
    body3
})
```

## `Decendents()`
Allows you to get the decendents of an body.
```lua
local decendents = Comet.Decendents(body)
```

## `Find()`
Allows you to find decendents of an object under a certain name defined by the `Name` special key.
```lua
local fooBodys = Comet.Find(body, "Foo")
```