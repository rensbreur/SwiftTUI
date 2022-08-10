import Foundation

@resultBuilder
public struct ViewBuilder {
    public static func buildBlock() -> EmptyItem { EmptyItem() }

    public static func buildBlock<Content: View>(_ content: Content) -> Content { content }

    public static func buildIf<V: View>(_ content: V)  -> V  { content }

    public static func buildEither<TrueContent: View, FalseContent: View>(first: TrueContent) -> _ConditionalView<TrueContent, FalseContent> {
        _ConditionalView(content: .a(first))
    }

    public static func buildEither<TrueContent: View, FalseContent: View>(second: FalseContent) -> _ConditionalView<TrueContent, FalseContent> {
        _ConditionalView(content: .b(second))
    }

    public static func buildBlock<C0: View, C1: View>(_ c0: C0, _ c1: C1) -> TupleView2<C0, C1> {
        TupleView2(content: (c0, c1))
    }

    public static func buildBlock<C0: View, C1: View, C2: View>(_ c0: C0, _ c1: C1, _ c2: C2) -> TupleView3<C0, C1, C2> {
        TupleView3(content: (c0, c1, c2))
    }
}
