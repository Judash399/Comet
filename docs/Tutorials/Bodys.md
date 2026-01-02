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
You could also use the `Comet.Parent()` method to parent a single child, but its recomended to only use `Comet.add()` as its more powerful.

!!! abstract
    The reason you are able to Parent a body to the `Universe` is because it is also is a `Body` object, meaning pretty much all methods that work on bodys will work on the `Universe`.


## Destruction
Whenever your done with a `Body` you can use the `Destroy()` function attached to *Comet* to destroy it.
```lua
Comet.Destroy(body)
```
This will destroy the `Body` and all of its decendents.