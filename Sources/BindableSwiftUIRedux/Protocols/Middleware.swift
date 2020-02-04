public protocol Middleware {
    associatedtype Store: ReduxStore
    static var middleware: Store.Middleware { get }
}
