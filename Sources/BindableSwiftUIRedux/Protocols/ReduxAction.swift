#if os(iOS)
/// A protocol which redux actions should conform to.
///
/// All actions that don't conform to BindingUpdateAction should conform to ReduxAction.
@available(iOS 13.0, *)
public protocol ReduxAction { }
#endif
