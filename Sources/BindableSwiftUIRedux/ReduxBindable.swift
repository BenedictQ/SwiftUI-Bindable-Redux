#if os(iOS)
import Combine

/// ReduxBindable is a property wrapper that should be added to properties on ReduxState objects which
/// are used for two way binding.
///
/// ReduxBindable acts as a middle man between the view and the store. It ensures the application follows the Redux pattern
/// by only performing state updates by dispatching actions, while embracing SwiftUI and enabling the View to act as though it is performing
/// conventional databinding.
/// 
/// Unfortunately, the store has to be injected into ReduxBindable instances after calling `init` so that it can be used as a property
/// wrapper. This should be done in the `initialize` function of a class conforming to ReduxState. The `ReduxBindable `wrapper
/// can be accessed by using the `_` prefix (e.g. for a property called `text`, use `_text`).
///
/// Use `wrappedValue` in SwiftUI views (i.e. access as you would a normal property). Setting this value will then cause an action to be dispatched.
///
/// Edit `projectedValue` in reducers (i.e. use $ prefix on property). Setting this value will cause the stored value to change.
@available(iOS 13.0, *)
@propertyWrapper
public struct ReduxBindable<Store: ReduxStore, State, Action: BindingUpdateAction> where Action.State == State {
    private var state: State
    public var store: Store?

    public var wrappedValue: State {
        get {
            return state
        }
        set {
            let action = Action.init(state: newValue)
            store?.dispatch(action)
        }
    }

    public init(wrappedValue: State) {
        state = wrappedValue
    }

    public var projectedValue: State {
        get {
            return state
        }
        mutating set {
            state = newValue
        }
    }
}
#endif
