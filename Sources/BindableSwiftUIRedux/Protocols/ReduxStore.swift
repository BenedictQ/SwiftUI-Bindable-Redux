#if os(iOS)
import Combine
import SwiftUI


/// A protocol to which Redux stores must conform.
///
/// The store should be initialized by calling
/// `initialize` as well as `init` before being injected into a view. It was written with
/// the expectation that this would be done using an `EnvironmentObject`.
///
/// Note that ObservableObject currently doesn't provide an `objectWillChange` publisher,
/// so implementations of this will need to instantiate their own in a stored property.
@available(iOS 13.0, *)
public protocol ReduxStore: ObservableObject where ObjectWillChangePublisher == ObservableObjectPublisher, Reducer.State == State, State.Store == Self {
    associatedtype State: ReduxState
    associatedtype Reducer: ReduxRootReducer
    var state: State { get set }
    var storedDispatch: Dispatch { get set }
    init(state: State?)
}

extension ReduxStore {
    typealias StoreCreator = (Reducer, State?) -> Self
    typealias StoreEnhancer = (StoreCreator) -> StoreCreator
    public typealias Dispatch = (ReduxAction) -> ReduxAction
    typealias DispatchWrapper = ((Dispatch) -> Dispatch)
    typealias Middleware = (Dispatch, () -> State) -> DispatchWrapper

    public var defaultDispatch: Dispatch {
        return { (action: ReduxAction) in
            self.reduce(action)
            return action
        }
    }

    @discardableResult public func dispatch(_ action: ReduxAction) -> ReduxAction {
        return storedDispatch(action)
    }

    public func initialize() -> Self {
        state.initialize(store: self)
        return self
    }

    public func reduce(_ action: ReduxAction) {
        // Inform SwiftUI that state has changed
        objectWillChange.send()
        state = Reducer.reduce(action, state: state)
    }

    public func getState() -> State {
        return state
    }

    static func createStore(reducer: Reducer,
                            preloadedState: State?,
                            enhancer: StoreEnhancer) -> Self {
        return enhancer(createStore)(reducer, preloadedState)
    }

    static func createStore(reducer: Reducer,
                            preloadedState: State?) -> Self {
        return Self.init(state: preloadedState)
    }

    static func applyMiddleware(middlewares: [Middleware]) -> StoreEnhancer {
        return { [middlewares] (createStore: @escaping StoreCreator) in
            return { [middlewares] (reducer: Reducer, initialState: State) -> Self in
                let store = createStore(reducer, initialState)
                var newDispatch: Dispatch = store.storedDispatch
                var chain: [(Dispatch) -> Dispatch] = []
                let wrappedDispatch = {(action: ReduxAction) in newDispatch(action)}

                chain = middlewares.map { $0(wrappedDispatch, store.getState) }
                newDispatch = compose(chain)(store.dispatch)

                store.storedDispatch = newDispatch
                return store
            }
        } as! StoreEnhancer
    }

    static func compose(_ dispatches: [DispatchWrapper]) -> DispatchWrapper {
        return dispatches.reduce(dispatches[0]) { (a: @escaping DispatchWrapper, b: @escaping DispatchWrapper) in
            return { (dispatch: Dispatch) in
                return a(b(dispatch))
            }
        }
    }
}
#endif

