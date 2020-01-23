#if os(iOS)
///A protocol to which a RootReducer implementation must conform.
///
/// Each store should have an associated RootReducer which conforms to this protocol.
/// Sub-reducers can be created and need not conform to this protocoil, as long as they
/// are combined together inside a ReduxRootReducer.
///
/// A new object should be returned in each reduce action - the state that is passed in should
/// should not be mutated.
@available(iOS 13.0, *)
public protocol ReduxRootReducer {
    associatedtype State: ReduxRootState
    static func reduce<Action: BindingUpdateAction>(_ action: Action, state: State) -> State
    static func reduce(_ action: ReduxAction, state: State) -> State
}
#endif
