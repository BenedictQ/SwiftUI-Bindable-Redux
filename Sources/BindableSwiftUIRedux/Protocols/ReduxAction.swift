#if os(iOS)
/// A protocol which all redux actions should conform to.
///
/// Note that Actions associated with binding changes should instead conform to BindingUpdateAction, and gain conformance to ReduxAction from that.
@available(iOS 13.0, *)
public protocol ReduxAction { }
#endif
