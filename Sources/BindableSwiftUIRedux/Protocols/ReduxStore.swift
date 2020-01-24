#if os(iOS)
import Combine
import SwiftUI

/// A protocol to which Redux stores must conform.
///
/// The store should be initialized by calling
/// `initialize` as well as `init` before being injected into a view. It was written with
/// the expectation that this would be done using an `EnvironmentObject`.
///
/// The implementation
/// of a ReduxStore should provide `objectWillChange` and `subscribers` as stored properties
/// not computed properties.
@available(iOS 13.0, *)
public protocol ReduxStore: ObservableObject {
    associatedtype State: ReduxState
    associatedtype Reducer: ReduxRootReducer
    var state: State { get set }
    var objectWillChange: ObservableObjectPublisher { get set }
}

extension ReduxStore where Reducer.State == State, State.Store == Self {
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
