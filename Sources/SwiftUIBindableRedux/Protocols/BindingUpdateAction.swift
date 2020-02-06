/// A protocol which binding redux actions must conform.
///
/// This protocol is for use with properties wrapped by the `BindingActionDispatcher` property wrapper.
/// These properties will have an associated action of this type that will be dispatched to an instance of `ReduxStore`
/// when the value changes. This action carries only the value of the property, and will be received by a `RootReducer`
/// which will update the correct property on the state.
public protocol BindingUpdateAction: ReduxAction {
    associatedtype State
    init(state: State)
    var state: State { get }
}
