# BindableSwiftUIRedux

This is a Redux framework for SwiftUI. It only provides protocols to conform to, and a property wrapper for use with databinding. The aim of this framework is to provide a Redux implementation for SwiftUI that doesn't require any boilerplate in your Views, and makes the most of the SwiftUI features EnvironmentObject and databinding.

For example, to pass a `ReduxStore` called `BaseStore` into a view called `ContentView`

```
let contentView = ContentView().environmentObject(BaseStore().initialize())
```

The ReduxBindable property wrapper is provided to enable you to store state which is used in two way binding in the Redux store. ReduxBindable ensures that state updates are only performed by actions as a middle man between the view and the state. The View has no knowledge of this and can bind to the property using standard syntax.

See my [example project](insert-url-here) to see how this works.

Note that this is an experimental project and is not suitable for use in production. I've not investigated the performance implications of using using a central environment object to store state. However, I suspect that it will mean every view has its body recomputed on every store update, even if it doesn't affect it. This is because SwiftUI is informed of a change to an ObservedObject, not which part of the ObservedObject changed, and therefore re-renders any view which is watching the ObservedObject. I believe will only re-render changes which have actually changed however, so I'm not sure whether this matters that much.
