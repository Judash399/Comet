# Bodys
Bodys are the object that a Universe itself is made of. Bodys is a data object that is made up of components. You can create new bodys by calling the `Body()` method on a Universe. This function takes a table like so:
```lua
local body = Universe:Body({})
```
Technacly though, in Luau if your passing a single string, or table into a function you don't need the parantheses meaning that these mean the same thing:
```lua
--This
local body = Universe:Body({})
--Is the same as
local body = Universe:Body {}
```
This is the recomended way to create Bodys in *Comet* and you will see it throughout the rest of the tutorials.

## Parents
Parenting allows you to control how an object behaves with other objects. By default, a body will not be parented to anything, this is why *Comet* goes with an `add()` method, which takes an input of the `parent` and the `child`.
```lua
--You can parent a body to the universe
Comet.add(Universe, {
    Universe:Body {}
})

--Or other bodys
Comet.add(otherBody, {
    Universe:Body {}
})
```
!!! info
    The reason you are able to Parent a body to the `Universe` is because it is also is a `Body` object, meaning pretty much all methods that work on bodys will work on the `Universe`.

## Names
You can give a Body a custom name through the `Name` key. For example if your creating a player, you can run this code:
```lua
local player = Universe:Body {
    Name = "Player",
}
```
## Tag
You can apply tags to an object through the tag key. It takes either a string or list of strings. For our player example you can do this
```lua
local player = Universe:Body {
    Name = "Player",
    Tag = {
        "Entity",
        "Object",
    }
}
```
To learn more about tags see the tagging tutorial.

## Children
When defining a `Body`, you can pass a list of children through the Children key. This will then automaticly parent all the children to the `Body`.
```lua
local player = Universe:Body {
    Name = "Player",
    Children = {
        Universe:Body {}
    }
}
```