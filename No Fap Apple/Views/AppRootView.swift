import SwiftUI

struct AppRootView: View {
    @State private var showSplash = true
    @State private var showColorDebug = false
    @State private var showAuraDebug = false
    @State private var debugTapCount = 0
    @EnvironmentObject var shortcutHandler: ShortcutHandler
    
    var body: some View {
        ZStack {
            if showAuraDebug {
                AuraBallDebugView()
                    .transition(.move(edge: .bottom))
            } else if showColorDebug {
                ColorDebugView()
                    .transition(.move(edge: .bottom))
            } else if showSplash {
                SplashView()
                    .transition(.opacity)
            } else {
                MainAppFlowView()
                    .environmentObject(shortcutHandler)
                    .transition(.opacity)
            }
        }
        .onAppear {
            // Show splash for 3 seconds, then transition to main app
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showSplash = false
                }
            }
        }
        .onTapGesture(count: 5) {
            // 5 quick taps to show color debug
            withAnimation(.spring()) {
                showColorDebug.toggle()
                showAuraDebug = false
            }
        }
        .onTapGesture(count: 3) {
            // 3 quick taps to show aura debug
            withAnimation(.spring()) {
                showAuraDebug.toggle()
                showColorDebug = false
            }
        }
        .overlay(
            // Debug info overlay
            VStack {
                if showColorDebug || showAuraDebug {
                    HStack {
                        Spacer()
                        Button("Close Debug") {
                            withAnimation(.spring()) {
                                showColorDebug = false
                                showAuraDebug = false
                            }
                        }
                        .padding()
                        .background(Theme.errorRed)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding(.top, 50)
                }
                Spacer()
            }
        )
    }
}

#Preview {
    AppRootView()
        .environmentObject(ShortcutHandler.shared)
} 