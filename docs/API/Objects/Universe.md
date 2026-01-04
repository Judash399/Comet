# Universe
```lua
export type Universe = Body | {
    _Bodys: {Body},
    update: (self: Universe, dt: number) -> (),
    Body: (self: Universe, props: {any}) -> (Body)
}
```