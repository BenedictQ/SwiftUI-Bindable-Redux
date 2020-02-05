
/// Protocol for custom middleware implementations to conform to
///
/// These can be added to the store using the `applyMiddleware` function inside the `createStore` function.
public protocol Middleware {
    associatedtype Store: ReduxStore
    static var middleware: Store.Middleware { get }
}
