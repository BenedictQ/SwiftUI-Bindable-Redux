#if os(iOS)
import Combine

/// A store will have an associated state property of type ReduxState.
///
/// The state can be
/// initialized with the store, allowing custom binding and publishers to dispatch actions.
///
/// Note that because Combine doesn't automatically support nested ObservableObjects, if properties are
/// not wrapped by `Published` then you will have to manually subscribe to the property's
/// publisher can call `objectWillChange.send()` in the subscribtion to trigger UI updates.
@available(iOS 13.0, *)
public protocol ReduxState: ObservableObject {
    associatedtype Store: ReduxStore
    init()
    func initialize(store: Store)
}

extension ReduxState {
    public func initialize(store: Store) { }
}
#endif
