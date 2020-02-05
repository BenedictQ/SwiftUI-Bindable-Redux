#if os(iOS)
///A protocol to which a `RootReducer` implementation must conform.
///
/// A `ReduxStore` should have an associated `RootReducer` which conforms to this protocol.
/// Sub-reducers can be created and need not conform to this protocol, as long as they
/// are combined together insidethe `reduce` function of  a `ReduxRootReducer`, and are in themselves pure functions to conform to
/// the Redux contract.
@available(iOS 13.0, *)
public protocol ReduxRootReducer {
    associatedtype State: ReduxRootState
    /// Reduce function to update the state with the given action.
    ///
    /// This should be a pure function to match the Redux contract. The function should not mutate the input state, but instead
    /// return a new state object. This can be achieved using the `deepcopy` function on the `state` object passed into the
    /// `reduce` function.
    static func reduce(_ action: ReduxAction, state: State) -> State
}
#endif
