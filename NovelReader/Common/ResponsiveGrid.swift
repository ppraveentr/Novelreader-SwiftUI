// Create a reusable grid/list component for grid/list switching based on size class.
import SwiftUI

struct ResponsiveGrid<Content: View>: View {
    let width: CGFloat
    let shrinkedView: Bool
    let isLoading: Bool
    @ViewBuilder let content: () -> Content

    private let grid = GridItem(.flexible(), spacing: 16)

    var body: some View {
        let columnCount = (width < 600.0 || shrinkedView) ? 1 : 2
        LazyVGrid(columns: Array(repeating: grid, count: columnCount), spacing: 16) {
            content()
        }
        .padding(.horizontal)
        SpinnerView(isShowing: isLoading)
    }
}
