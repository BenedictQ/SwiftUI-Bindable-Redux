import Combine


/// A protocol to which Redux stores must conform.
///
/// The store should be initialized by calling
/// `initialize` as well as `init` before being injected into a view. It was written with
/// the expectation that this would be done using an `EnvironmentObject`.
///
/// Note that `ObservableObject` currently doesn't provide an `objectWillChange` publisher,
/// so implementations of this will need to instantiate their own in a stored property.
///
/// ReduxStores should be created using the static `createStore` function, and not the initializer.
/// Store enhancers can optionally be passed into the `createStore` function. The most likely
/// store enhancer will be the `applyMiddleware` function, which takes in an array of `Middleware`.
/// You can write your own middleware by conforming to the `Middleware` protocol.
public protocol ReduxStore: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher, Reducer.State == State, State.Store == Self {
    associatedtype State: ReduxRootState
    associatedtype Reducer: ReduxRootReducer
    var state: State { get set }
    /// The storedDispatch property for adding custom middleware.
    ///
    /// This property should always have an initial value of `defaultDispatch`. It is an unfortunate
    /// consequence of using Swift protocols that disqualifies defining this on the ReduxStore extension.
    ///
    /// This property should never be accessed directly. Instead, use `applyMiddleware` to add
    /// middleware to the store, and the `dispatch` function to dispatch actions to the store.
    var storedDispatch: Dispatch { get set }
    /// The initializer for a ReduxStore.
    ///
    /// An instance of ReduxStore should never be initialized using the `init` directly. Instead, use `createStore`
    init(state: State?)
}

extension ReduxStore {
    public typealias StoreCreator = (Reducer.Type, State?) -> Self
    public typealias StoreEnhancer = (@escaping StoreCreator) -> StoreCreator
    public typealias Middleware = (@escaping Dispatch, @escaping () -> State) -> DispatchWrapper

    public var defaultDispatch: Dispatch {
        return { (action: ReduxAction) in
            self.reduce(action)
        }
    }

    public func dispatch(_ action: ReduxAction) {
        return storedDispatch(action)
    }

    public func initialize() -> Self {
        state.initialize(store: self)
        return self
    }

    func reduce(_ action: ReduxAction) {
        // Inform SwiftUI that state has changed
        objectWillChange.send()
        state = Reducer.reduce(action, state: state)
    }

    func getState() -> State {
        return state
    }

    /// An overload of `createStore` that allows store enhancers to be added.
    ///
    /// Custom store enhancers could be created which match the `StoreEnhancer` type.
    /// The most common store creator used will be the `applyMiddleware` function.
    public static func createStore(reducer: Reducer.Type,
                            preloadedState: State?,
                            enhancer: StoreEnhancer) -> Self {
        return enhancer(createStore)(reducer, preloadedState)
    }

    /// Creates an instance of the store.
    public static func createStore(reducer: Reducer.Type,
                                   preloadedState: State?) -> Self {
        return Self.init(state: preloadedState)
    }

    /// Helper function to apply an array of middlewares to the store.
    ///
    /// This function should be passed as a store enhancer into `createStore`.
    public static func applyMiddleware(middlewares: [Middleware]) -> StoreEnhancer {
        return { (createStore: @escaping StoreCreator) in
            return { (reducer: Reducer.Type, initialState: State?) -> Self in
                let store = createStore(reducer, initialState)
                var newDispatch: Dispatch = store.storedDispatch
                let wrappedDispatch = {(action: ReduxAction) in
                    newDispatch(action)
                }

                let chain = middlewares.map {
                    $0(wrappedDispatch, store.getState)
                }
                newDispatch = Composer.compose(chain)(store.storedDispatch)

                store.storedDispatch = newDispatch
                return store
            }
        }
    }
}
