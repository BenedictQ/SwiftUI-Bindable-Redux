# BindableSwiftUIRedux

## Embracing SwiftUI while using Redux
This is a Redux framework for SwiftUI which embraces SwiftUI's data design. Views can use two way data binding alongside redux state by the `@ReduxBindable` property wrapper instead of `@Published`. In addition, `EnvironmentObject` is used as a means to subscribe to the store, as SwiftUI will update any views which declare a wrapped `@EnvironmentObject` property when the object changes.

## Lightweight and versatile
The libarary only provides protocols to conform to, and the `@ReduxBindable` property wrapper for use with databinding. This makes it very versatile. The aim of this framework is to provide a Redux implementation for SwiftUI that doesn't require any boilerplate in your Views. Unfortunately in order to make `ReduxBindable` a property wrapper, and also because Combine doesn't currently support nested `ObservableObjects`, State implementations require some boilerplate in their initialize function. Hopefully this will be lessened in future versions of Swift, SwiftUI and Combine, and in the meantime isn't too bad.

## EnvironmentObject Redux stores
The library uses environment object to inject the store. For example, to pass a `ReduxStore` called `BaseStore` into a view called `ContentView`

```
let contentView = ContentView().environmentObject(BaseStore().initialize())
```

## Two way databinding synthesised with Redux actions
The library provides the `@ReduxBindable` property wrapper to enable you to store state which is used in two way binding in the Redux store. `ReduxBindable` ensures that state updates are only performed by actions by acting as a middle man between the view and the state. The View has no knowledge of this and can bind to the property using standard SwiftUI syntax.

## Example project
See my [example project](insert-url-here) to see how to use this library works.

## Caveat
Note that this is an experimental project and is not suitable for use in production. I've not investigated the performance implications of using using a central environment object to store state. However, I suspect that it will mean every view that uses the store has its body recomputed on every store update, even if it's not affected. This is because SwiftUI is informed of a change to an ObservedObject, not which part of the ObservedObject changed, and therefore re-renders any view which is watching the ObservedObject. I believe will only re-render changes which have actually changed however, so I'm not sure whether this will have a significant performance impact. In addition, it's unlikely that the impact will be greater than using `ObservableObject` in the MVVM pattern, as this suffers from the same issue. I've not experimented with injecting multiple stores as different environment objects, but this may be a way to optimise performance if necessary.
