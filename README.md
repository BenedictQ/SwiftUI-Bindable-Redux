# SwiftUIBindableRedux

## Embracing SwiftUI while using Redux
This is a Redux framework for SwiftUI which embraces SwiftUI's data design. Views can use two way data binding alongside redux state by applying the `@ReduxBindable` property wrapper instead of `@Published`. In addition, injecting the store using `EnvironmentObject` is used as a means to publish changes to state. When the state is updated by an action, the store will publish an `objectWillChange` notification. SwiftUI will update any views which declare a wrapped `@EnvironmentObject` property when the object it wraps sends out that notification. Using `EnvironmentObject` has the double benefit of allowing the store to be injected at any level of the view hierarchy without passing it down through constructors.

## Lightweight and versatile
The libarary follows the Protocol Oriented Programming design principle by providing protocols to conform to, over classes to subclass. These protocols provide a pattern and functionality for the store, state, actions, reducers and middleware component. The only middleware that comes with the package is an implementation of thunks called `ThunkMiddleware`. There is a `Composer` enum used internally use. The only other object is the `@ReduxBindable` property wrapper class for use with databinding. Including only protocols keeps the framework lightweight, versatile and Swifty.

## EnvironmentObject Redux stores
The library uses `EnvironmentObject` to inject the store. Stores must be initialized before being injected. The `createStore` function is used to create stores. allowing for the injection of state, or store enhancers (such as middleware). For example, to pass a ReduxStore called BaseStore into a view called ContentView.
```
let rootStore = RootStore.createStore(
    reducer: RootReducer.self,
    preloadedState: nil,
    enhancer: RootStore.applyMiddleware(middlewares: [
        LoggingMiddleware.middleware,
        ThunkMiddleware<RootStore>.middleware
    ])
)
.initialize()

let contentView = RootView().environmentObject(rootStore)
```

```
struct Example: View {
    @EnvironmentObject var store: CounterStore

    var body: some View {
        VStack {
            Text("\(store.state.count)")
            HStack {
                Button(action: doSomething) {
                    Text("Do Something")
                }
            }
        }
        .padding()
    }

    func doSomething() {
        let action = DoSomething()
        store.dispatch(action)
    }
}
```

## Two way databinding synthesised with Redux actions
The library provides the `@ReduxBindable` property wrapper to enable you to store state which is used in two way binding in the Redux store. `ReduxBindable` ensures that state updates are only performed by actions by acting as a middle man between the view and the state. The View has no knowledge of this and can bind to the property using standard SwiftUI syntax. Unfortunately in order to make `ReduxBindable` a property wrapper which dispatches actions to the store, State implementations require some boilerplate in their `initialize` function to inject the store into these properties. The `initialize` function is called by a `ReduxStore`'s `initialize`.

```
final class ExampleState: ReduxState {
    // Declare action type in generic of property wrapper
    @ReduxBindable<RootStore, String, UpdateExampleStringAction> var exampleString: String = ""

    func initialize(store: RootStore) {
        _exampleString.store = store
    }
    
    func deepcopy() -> ExampleState {
        let newState = ExampeState()
        newState._exampleString = _exampleString
        return newState
    }
}
```

```
enum ExampleReducer: ReduxRootReducer {
    static func reduce(_ action: ReduxAction, state: ExampleState) -> ExampleState {
        let newState = state.deepcopy()

        switch action {
        // Catch action type in reducer
        case let action as UpdateExampleStringAction:
            // Set projected value of `ReduxBindable` using `$` prefix
            newState.$exampleString = action.state
        default:
            break
        }

        return newState
    }
}
```

```
struct Example: View {
    @EnvironmentObject var store: RootStore
    
    var body: some View {
        // Perform data binding as you would with `@Published` properties
        TextField("Type here", text: $store.state.exampleString)
    }
}
```

## Middleware

The library provides a `Middleware` protocol that can be conformed to to provide a pattern for writing your own middleware. `ThunkMiddleware` ships with the package.

```
enum LoggingMiddleware: Middleware {
    typealias Store = RootStore
    static var middleware: Store.Middleware {
        return { (dispatch: Dispatch, getState: @escaping () -> RootState) in
            return { (next: @escaping Dispatch) in
                return { (action: ReduxAction) in
                    // Really basic logging
                    print("Logging state")
                    print(getState())
                    next(action)
                    print(getState())
                    print("End logging state")
                }
            }
        }
    }
}
```

```
let rootStore = RootStore.createStore(
    reducer: RootReducer.self,
    preloadedState: nil,
    // Use `applyMiddleware` static method on your store to apply middleware
    enhancer: RootStore.applyMiddleware(middlewares: [
        LoggingMiddleware.middleware
    ])
)
.initialize()
```

## Example projects
See the example projects for further examples of how to use the package:

Simple Counter example project to show how the library works - https://github.com/BenedictQ/CounterBindableRedux
Sign-up example project to show examples of multiple state slices and reducers - https://github.com/BenedictQ/SignUpBindableRedux

## Performance impact
I've not fully investigated the performance implications of using using a central `EnvironmentObject` to store state. Any view which declares the `ReduxStore` property wrapped with `@EnvironmentObject` will have its body recomputed on every update. This will happen even if it only uses the store for dispatching actions, or if the slice of state it uses is not updated. This is because SwiftUI watches the `objectWillChange` notification on any `@EnvironmentObject` to invalidate the body, which is sent every time an action is dispatched. However, re-initializing views is cheap, and SwiftUI will only re-render views which have actually changed however, so I don't think this will have a significant performance impact. In addition, it's unlikely that the impact will be much greater than using `ObservableObject` in the MVVM pattern, as this suffers from the same issue. In any case, I expect the benefits of the Redux pattern to outweight the possible cost. 

Introducing a container pattern may help avoid unnecessary calls on presentational `body` components:

```
struct Container: View {
@EnvironmentObject var store: RootStore
    var body: some View {
        // If necessaryState hasn't changed in response to an action, even
        // though another part of the store hasn't, complex `body` of 
        // Presentational view won't be called
        Presentational(necessaryState: store.state.necessaryState)
    }
}
```

I've not tried to use this pattern, so it may or may not work, particularly as state objects will be reference types. However, ensuring that SwiftUI updates are triggered and rendering always happens when state changes will be essential if attempting to introduce this pattern.

## Caveat
I would love for the SwiftUI community to download, use, and contribute to improving this package. However, note that this is an experimental project and has not been tested for use in production.
