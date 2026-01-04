# Body
```lua
export type Body = {
    Type: "Body",
    Name: string?,
    Parent: Body?,
    _Children: {Body},
    _Universe: Universe,
    Components: {Component}?,
}
```
An Object made up of [Components](../Types/Component.md) that makes up the hierarchy data structure.

## Type: "Body"
Identifier used for *Comet* to recognize the Body.

## Name: string?
Optional name used to uniquely identify the body in errors. Defined through the Name special key.

## Parent: [Body]()?
Refrence to the body this object is parented to. 

!!! warning "DO NOT TOUCH THIS!"
    Do not directly read or set this value as it will cause errors! Use the `Parent()` and `GetParent()` method attached to *Comet* itself.

    <h2>Future versions of *Comet* may make this value private!</h2>

## _Children: {[Body]()}
Refrence to the bodys parented to this body.

!!! warning "DO NOT TOUCH THIS!"
    Do not directly read or set this value as it will cause errors! Use the `Parent()` and `GetChildren()` methods attached to *Comet* itself.

## _Universe: [Universe](Universe.md)
A refrence to this Bodys universe.
!!! warning "DO NOT TOUCH THIS!"
    Do not read or set this value EVER! This is purely for internal use.

## Components: {[Component](../Types/Component.md)}?
A list of all the components added to the body.

!!! tip "Probably dont touch this"
    While its safe to use this value. Its recomended to use the `GetComponent()` and `GetComponents()` methods attached to *Comet* itself to increase code clarity.

    <h2>Future versions of *Comet* may make this value private!</h2>