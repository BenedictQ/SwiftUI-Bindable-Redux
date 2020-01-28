#if os(iOS)
import Combine

/// A store will have an associated state property of type ReduxState.
///
/// The state will be initialized with the store, allowing custom binding and publishers to dispatch actions.
/// The default implementation of initialize does nothing as it will be entirely implementation dependent, and
/// not requiring initialization is the simplest, and quite likely, case.
@available(iOS 13.0, *)
public protocol ReduxState {
    associatedtype Store: ReduxStore
    func initialize(store: Store)
}

extension ReduxState {
    public func initialize(store: Store) { }
}
#endif
