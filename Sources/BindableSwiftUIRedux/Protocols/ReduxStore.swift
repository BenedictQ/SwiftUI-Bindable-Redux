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
    associatedtype State: ReduxRootState
    associatedtype Reducer: ReduxRootReducer
    var state: State { get set }
    var objectWillChange: ObservableObjectPublisher { get set }
    var subscribers: Set<AnyCancellable> { get set }
}

extension ReduxStore where Reducer.Store == Self, State.Store == Self {
    public func initialize() -> Self {
        state.initialize(store: self)

        // Currently Combine doesn't support nested ObservableObjects
        subscribers.insert(
            self.state.objectWillChange
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    self.objectWillChange.send()
        })

        return self
    }

    public func dispatch<Action: BindingUpdateAction>(_ action: Action) {
        Reducer.reduce(action, store: self)
    }

    public func dispatch(_ action: ReduxAction) {
        Reducer.reduce(action, store: self)
    }
}
#endif
