import SwiftUI

struct SplashView: View {
    @State private var animate = false
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.accentColor.opacity(0.85), Color(.systemBackground)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        .overlay(
            VStack(spacing: 28) {
                Image(systemName: "book.circle.fill")
                    .resizable()
                    .frame(width: 110, height: 110)
                    .foregroundStyle(.white, Color.accentColor)
                    .shadow(radius: 12, y: 8)
                    .opacity(animate ? 1 : 0.4)
                    .scaleEffect(animate ? 1.0 : 0.8)
                Text("NovelReader")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 2)
                    .opacity(animate ? 1 : 0.1)
                Text("Your gateway to stories")
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    .opacity(animate ? 1 : 0.1)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding(.top, 16)
            }
            .padding()
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    animate = true
                }
            }
        )
    }
}

#Preview {
    SplashView()
}
