// Create a reusable grid/list component for grid/list switching based on size class.
import SwiftUI

struct ResponsiveGrid<Content: View>: View {
    let width: CGFloat
    let shrinkedView: Bool
    let isLoading: Bool
    @ViewBuilder let content: () -> Content
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let grid = GridItem(.flexible(), spacing: 16)

    var body: some View {
        if horizontalSizeClass == .regular {
            let columnCount = (width < 600 || shrinkedView) ? 1 : 2
            LazyVGrid(columns: Array(repeating: grid, count: columnCount), spacing: 16) {
                content()
            }
            .padding(.horizontal)
        } else {
            content()
        }
        SpinnerView(isShowing: isLoading)
    }
}
