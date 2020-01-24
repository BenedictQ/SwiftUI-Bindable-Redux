#if os(iOS)
///A protocol to which a RootReducer implementation must conform.
///
/// A ReduxStore should have an associated RootReducer which conforms to this protocol.
/// Sub-reducers can be created and need not conform to this protocol, as long as they
/// are combined together inside a ReduxRootReducer and are pure functions to conform to
/// the Redux contract.
@available(iOS 13.0, *)
public protocol ReduxRootReducer {
    associatedtype State: ReduxState
    /// This should be a pure function to match the Redux contract.
    static func reduce<Action: BindingUpdateAction>(_ action: Action, state: State) -> State
    /// This should be a pure function to match the Redux contract.
    static func reduce(_ action: ReduxAction, state: State) -> State
}
#endif
