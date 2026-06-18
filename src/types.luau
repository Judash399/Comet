export type Entity = number

export type Component<T> = { [Entity]: T }

export type ComponentData<T> = {
	id: string,
	data: T,
}

export type System = (deltaTime: number) -> ()

export type Event<T...> = {
	Connect: (Event<T...>, (T...) -> ()) -> Connection<T...>,
	Fire: (Event<T...>, T...) -> (),
	Destroy: (Event<T...>) -> (),
}

export type Connection<T...> = {
	connected: boolean,
	Disconnect: (Connection<T...>) -> (),
}

return {}
