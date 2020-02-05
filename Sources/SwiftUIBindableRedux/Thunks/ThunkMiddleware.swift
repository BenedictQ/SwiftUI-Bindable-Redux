/// Container for the thunk middleware functionality.
///
/// The `middleware` property can be passed into `applyMiddleware` to allow the dispatch of `Thunk` objects
/// as actions.
public enum ThunkMiddleware<Store: ReduxStore>: Middleware {
    public static var middleware: Store.Middleware {
        return { (dispatch: @escaping Dispatch, getState: @escaping () -> Store.State) in
            return { (next: @escaping Dispatch) in
                return { (action: ReduxAction) in
                    if let thunk = action as? Thunk<Store> {
                        return thunk.action(dispatch, getState)
                    }

                    return next(action)
                }
            }
        }
    }
}
