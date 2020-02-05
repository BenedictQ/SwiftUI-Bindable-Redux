#if os(iOS)
import Combine

/// A protocol for state slices to conform to.
///
/// The root state type, which matches the associated `state` property type of the ReduxStore, must be of type `ReduxState`.
/// In addition, any subsidiary state slices inside this root state should conform to this protocol.
///
/// The state will be initialized with the store, allowing custom binding and publishers to dispatch actions.
/// The default implementation of initialize does nothing as it will be entirely implementation dependent, and
/// not requiring initialization is the simplest, and quite likely, case.
///
/// State must be class bound at this stage to integrate with SwiftUI state management.
@available(iOS 13.0, *)
public protocol ReduxState: AnyObject {
    associatedtype Store: ReduxStore
    func initialize(store: Store)
}

extension ReduxState {
    public func initialize(store: Store) { }
}
#endif
