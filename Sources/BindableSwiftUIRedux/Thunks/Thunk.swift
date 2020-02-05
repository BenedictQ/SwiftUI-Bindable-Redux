/// Simple object which is used to wrap a thunk action in the `ReduxAction` type so that it can be dispatched to the store.
///
/// Apply the `ThunkMiddleware` to the store to enable handling these thunk actions.
public struct Thunk<Store: ReduxStore>: ReduxAction {
    public typealias ThunkAction = (@escaping Dispatch, () -> Store.State) -> Void
    public var action: ThunkAction
    public init(action: @escaping ThunkAction) {
        self.action = action
    }
}
