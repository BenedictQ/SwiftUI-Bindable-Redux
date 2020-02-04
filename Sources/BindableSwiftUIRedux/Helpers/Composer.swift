public typealias Dispatch = (ReduxAction) -> ReduxAction
public typealias DispatchWrapper = ((@escaping Dispatch) -> Dispatch)

enum Composer {
    static func compose(_ dispatches: [DispatchWrapper]) -> DispatchWrapper {
        if dispatches.count == 1 {
            return { (dispatch: @escaping Dispatch) in
                return dispatches[0](dispatch)
            }
        }
        let initial: DispatchWrapper = { dispatch in return dispatch }
        return dispatches.reduce(initial) { (a: @escaping DispatchWrapper, b: @escaping DispatchWrapper) in
            return { (dispatch: @escaping Dispatch) in
                return a(b(dispatch))
            }
        }
    }
}
