@available(iOS 13.0, *)
public typealias Dispatch = (ReduxAction) -> Void

public typealias DispatchWrapper = ((@escaping Dispatch) -> Dispatch)

/// Container for the `compose` function.
enum Composer {
    /// Composes multiple functions into a single function using the functional programming principle.
    static func compose(_ dispatches: [DispatchWrapper]) -> DispatchWrapper {
        let initial: DispatchWrapper = { dispatch in return dispatch }
        return dispatches.reduce(initial) { (a: @escaping DispatchWrapper, b: @escaping DispatchWrapper) in
            return { (dispatch: @escaping Dispatch) in
                return a(b(dispatch))
            }
        }
    }
}
