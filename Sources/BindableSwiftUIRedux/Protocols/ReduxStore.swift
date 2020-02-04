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
    public typealias StoreCreator = (Reducer.Type, State?) -> Self
    public typealias StoreEnhancer = (@escaping StoreCreator) -> StoreCreator
    public typealias Middleware = (@escaping Dispatch, @escaping () -> State) -> DispatchWrapper

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

    public static func createStore(reducer: Reducer.Type,
                            preloadedState: State?,
                            enhancer: StoreEnhancer) -> Self {
        return enhancer(createStore)(reducer, preloadedState)
    }

    public static func createStore(reducer: Reducer.Type,
                                   preloadedState: State?) -> Self {
        return Self.init(state: preloadedState)
    }

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
#endif

