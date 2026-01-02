# SpecialKeys

`SpecialKeys` allow you to declaratively configure a `Body` at creation time by adding new data. They are especially helpful when creating custom engine features such as Tags.

!!!tip "How do they work?"
    `SpecialKeys` work by using a table as a unique key in the body creation table. This naturally means that there cannot be `SpecialKey` duplicates because you cannot have a key equal 2 values.


*Comet* By default includes 2 default special keys.

## Name
You can use the `Name` special key to give a name identifier to an object:
```lua
local player = Universe:Body {
    [Comet.Name] = "Player"
}
```

## Children
You can use the `Children` special key to parent a list of `Bodies` to the body being created.
```lua
local player = Universe:Body {
    [Comet.Children] = {
        Universe:Body {}
    }
}
```

## Defining your own SpecialKeys
The real power of special keys comes when you define your own. You can define one like this:
```lua
local TestKey = {
    Type = "SpecialKey",
    Stage = "PreComponents",
    Name = "TestKey",
    Method = function(body, value)
        print(value)
    end,
}
```
The `Stage` field defines what Stage the Key will run at, there are 3 stages:

* `PreComponents` - Runs before any components are created. Use for structural setup.
* `InitComponents` - Runs after all components exist and their `Init()` methods have run.
* `PostComponents` - Runs after the body is fully constructed and ready for use.

To learn more about defining special keys, check out [the tag project](Projects/Tags.md).