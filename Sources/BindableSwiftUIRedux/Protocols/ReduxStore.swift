#if os(iOS)
import Combine
import SwiftUI

/// A protocol to which Redux stores must conform.
///
/// The store should be initialized by calling
/// `initialize` as well as `init` before being injected into a view. It was written with
/// the expectation that this would be done using an `EnvironmentObject`.
///
/// Note that ObservableObject currently doesn't provide an `objectWillChange` publisher,
/// so implementations of this will need to instantiate their own in a stored property.
@available(iOS 13.0, *)
public protocol ReduxStore: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher, Reducer.State == State, State.Store == Self {
    associatedtype State: ReduxState
    associatedtype Reducer: ReduxRootReducer
    var state: State { get set }
}

extension ReduxStore {
    public func initialize() -> Self {
        state.initialize(store: self)
        return self
    }

    public func dispatch<Action: BindingUpdateAction>(_ action: Action) {
       state = Reducer.reduce(action, state: state)
        // Inform SwiftUI that state has changed
       objectWillChange.send()
    }

    public func dispatch(_ action: ReduxAction) {
        state = Reducer.reduce(action, state: state)
        // Inform SwiftUI that state has changed
        objectWillChange.send()
    }
}
#endif
