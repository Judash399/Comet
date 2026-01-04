# Components
```lua
export type Component = {
    Name: string,
    Init: (Body) -> ()?,
    Start: () -> ()?,
    Update: (dt: number) -> ()?,
    Destroy: () -> ()?,
}
```
An object passed to a [Body](../Objects/Body.md) to add behavior to them.

## Name: string
A Unique Unique Identifier used for certain helper methods.

## Init: ([Body](../Objects/Body.md)) -> ()?
A function ran which passes the body.

## Start: () -> ()?
A function ran after Init.

## Update: (dt: number) -> ()?
A function ran every frame passing the delta time.

## Destroy: () -> ()?
A function ran before the attached body is destroyed.