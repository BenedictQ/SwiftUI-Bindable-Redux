# BindableSwiftUIRedux

## Embracing SwiftUI while using Redux
This is a Redux framework for SwiftUI which embraces SwiftUI's data design. Views can use two way data binding alongside redux state by applying the `@ReduxBindable` property wrapper instead of `@Published`. In addition, injecting the store using `EnvironmentObject` is used as a means to publish changes to state. When the state is updated by an action, the store will publish an `objectWillChange` notification. SwiftUI will update any views which declare a wrapped `@EnvironmentObject` property when the object it wraps sends out that notification. Using `EnvironmentObject` has the double benefit of allowing the store to be injected at any level of the view hierarchy without passing it down through constructors.

## Lightweight and versatile
The libarary only provides protocols to conform to, and the `@ReduxBindable` property wrapper for use with databinding. This makes it very versatile by just providing a framework for you to create your own State systems.

## EnvironmentObject Redux stores
The library uses `EnvironmentObject` to inject the store. Stores must be initialized before being injected. For example, to pass a ReduxStore called BaseStore into a view called ContentView.
`let contentView = ContentView().environmentObject(BaseStore().initialize())`

## Two way databinding synthesised with Redux actions
The library provides the `@ReduxBindable` property wrapper to enable you to store state which is used in two way binding in the Redux store. `ReduxBindable` ensures that state updates are only performed by actions by acting as a middle man between the view and the state. The View has no knowledge of this and can bind to the property using standard SwiftUI syntax. Unfortunately in order to make `ReduxBindable` a property wrapper which dispatches actions to the store, State implementations require some boilerplate in their initialize function to inject the store into these properties.

## Example project
See my [example project](https://github.com/BenedictQ/SignUpBindableRedux) to see how to use this library works.

## Caveat
Note that this is an experimental project and is not suitable for use in production. I've not investigated the performance implications of using using a central `EnvironmentObject` to store state. However, I suspect that it will mean every view that uses the store has its body recomputed on every store update, even if it's not affected. This is because SwiftUI is informed of a change to an `ObservedObject`, not which part of the `ObservedObject` changed, and therefore re-renders any view which is watching the `ObservedObject`. This is an internal behaviour of SwiftUI, so this framework doesn't have the same optimisation around state injection that React-Redux does. I believe SwiftUI will only re-render views which have actually changed however, so I'm not sure whether this behaviour will have a significant performance impact. In addition, it's unlikely that the impact will be greater than using `ObservableObject` in the MVVM pattern, as this suffers from the same issue.
