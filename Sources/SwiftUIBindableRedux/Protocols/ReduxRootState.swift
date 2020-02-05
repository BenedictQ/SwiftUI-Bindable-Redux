/// A protocol for the root state implementation to conform to.
///
/// The ReduxStore protocol has an associated type of `ReduxRootState`. Any subsidiary state slices of a `ReduxRootState` should conform to `ReduxState`.
///
/// The state will be initialized with the store, allowing custom binding and publishers to dispatch actions.
/// The default implementation of initialize does nothing as it will be entirely implementation dependent, and
/// not requiring initialization is the simplest, and quite likely, case.
public protocol ReduxRootState: ReduxState {
    /// Function which returns a deep copy of the reference type object which conforms to this protocol.
    ///
    /// `ReduxRootReducer` will need to be a pure function, and therefore needs to be able to deepcopy
    /// the root state type of the `ReduxStore`. This function provides that functionality. Its return should be
    /// a new object pointed at a new memory address. However, its internals should keep their old values and
    /// references.
    ///
    /// In particular, any properties wrapped with the `ReduxBindable` property wrapper should copy the
    /// instance of `ReduxBindable` using the `_` notation, and not set the wrapped or projected value.
    /// This ensures SwiftUI keeps the correct reference in data binding.
    func deepcopy() -> Self
}
