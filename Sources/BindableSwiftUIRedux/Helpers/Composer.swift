public typealias Dispatch = (ReduxAction) -> ReduxAction
public typealias DispatchWrapper = ((@escaping Dispatch) -> Dispatch)

enum Composer {
    static func compose(_ dispatches: [DispatchWrapper]) -> DispatchWrapper {
        if dispatches.count == 1 {
            return { (dispatch: @escaping Dispatch) in
                return dispatches[0](dispatch)
            }
        }
        return dispatches.reduce(dispatches[0]) { (a: @escaping DispatchWrapper, b: @escaping DispatchWrapper) in
            return { (dispatch: @escaping Dispatch) in
                return a(b(dispatch))
            }
        }
    }
}
