#if os(iOS)
///A protocol to which a RootReducer implementation must conform.
///
/// Each store should have an associated RootReducer which conforms to this protocol.
/// Sub-reducers can be created and need not conform to this protocoil, as long as they
/// are combined together inside a ReduxRootReducer.
@available(iOS 13.0, *)
public protocol ReduxRootReducer {
    associatedtype Store: ReduxStore
    static func reduce<Action: BindingUpdateAction>(_ action: Action, store: Store)
    static func reduce(_ action: ReduxAction, store: Store)
}
#endif
