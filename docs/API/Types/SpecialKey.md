# SpecialKey
```lua
export type SpecialKey = {
    Type: "SpecialKey",
    Stage: "PreComponents" | "InitComponents" | "PostComponents",
    Name: string?,
    Method: (Body, any) -> (),
}
```
!!! note
    I am aware the syntax highlighting is broken, I am not aware how to fix it.

A object passed as a key when creating a [Body](../Objects/Body.md) used to add extra data.

## Type: "SpecialKey"
An Identifier used for Comet to recognise that you passed a SpecialKey.

## Stage: "PreComponents" | "InitComponents" | "PostComponents"
What stage of object creation the body uses.

### "PreComponents"
Before a component init function is ran

### "InitComponents"
After a components init function is ran and before the start function.

### "PostComponents"
After Components init and start function have been run.

## Name: string?
An identifier used in things like errors.

## Method: ([Body](../Objects/Body.md), any) -> ()
The function that is ran by the body. The body is the body object created, the any is the value the special key was set too.