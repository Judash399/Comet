# Universe
```lua
export type Universe = Body | {
    _Bodys: {Body},
    update: (self: Universe, dt: number) -> (),
    Body: (self: Universe, props: {any}) -> (Body)
}
```
The root object in the that all [Bodys](Body.md) decend from.

## _Bodys: {[Body](Body.md)}
A weak table of all [Bodys](Body.md) part of this universe.

!!! warning "Don't use this!"
    This is used to find all bodys for the `update()` function, and is not intended for external use!

## update: (self: [Universe](), dt: number) -> ()
Function thats ran by the user to call the update on all bodys with the given DeltaTime value.

## Body: (self: [Universe](), props: {any}) -> ([Body](Body.md))
Constructor function that creates [Body](Body.md) objects using a list of props.
Props can contain [Components](../Types/Component.md) inside the number keys, and [SpecialKeys](../Types/SpecialKey.md) set to a certain value.