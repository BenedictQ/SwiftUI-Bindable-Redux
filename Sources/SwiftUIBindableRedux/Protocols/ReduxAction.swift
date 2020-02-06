/// A protocol which all redux actions should conform to.
///
/// Note that actions associated with binding changes should instead conform to `BindingUpdateAction`, and gain conformance to `ReduxAction` from that.
public protocol ReduxAction { }
