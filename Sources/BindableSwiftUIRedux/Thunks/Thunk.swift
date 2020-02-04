public struct Thunk<Store: ReduxStore>: ReduxAction {
    public typealias ThunkAction = (@escaping Dispatch, () -> Store.State) -> Void
    public var action: ThunkAction
    public init(action: @escaping ThunkAction) {
        self.action = action
    }
}
