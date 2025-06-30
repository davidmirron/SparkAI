import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentSlide = 0
    @State private var animateGradient = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic gradient background (Instagram-inspired)
                LinearGradient(
                    colors: animateGradient ? 
                        [Color.purple, Color.pink, Color.orange] :
                        [Color.pink, Color.purple, Color.blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
                
                // Content
                VStack(spacing: 0) {
                    Spacer()
                    
                    // Hero Section
                    VStack(spacing: 32) {
                        // App Logo & Branding
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                    .blur(radius: 20)
                                
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 60, weight: .medium))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.white, .pink.opacity(0.8)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .scaleEffect(1.0 + sin(Date().timeIntervalSince1970 * 2) * 0.05)
                            }
                            
                            VStack(spacing: 8) {
                                Text("SparkAI")
                                    .font(.system(size: 42, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Your Date Night Companion")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                        
                        // Value Proposition (Tinder-style)
                        VStack(spacing: 24) {
                            FeatureRow(
                                icon: "camera.fill",
                                title: "Snap Together",
                                description: "Take a quick selfie or skip the photo"
                            )
                            
                            FeatureRow(
                                icon: "sparkles",
                                title: "Get Ideas",
                                description: "AI generates personalized date experiences"
                            )
                            
                            FeatureRow(
                                icon: "heart.fill",
                                title: "Create Memories",
                                description: "From free adventures to romantic evenings"
                            )
                        }
                        .padding(.horizontal, 40)
                    }
                    
                    Spacer()
                    
                    // Social Proof (Subtle)
                    VStack(spacing: 16) {
                        HStack(spacing: 12) {
                            ForEach(0..<5) { _ in
                                Circle()
                                    .fill(.white.opacity(0.8))
                                    .frame(width: 32, height: 32)
                                    .overlay(
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 14))
                                            .foregroundColor(.pink)
                                    )
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("47K+ couples")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("found their spark")
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 40)
                        
                        // Star Rating
                        HStack(spacing: 4) {
                            ForEach(0..<5) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.yellow)
                            }
                            
                            Text("4.9 • App Store")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    
                    Spacer()
                    
                    // CTA Section (Bumble-style)
                    VStack(spacing: 20) {
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                appState.currentScreen = .camera
                            }
                        }) {
                            HStack {
                                Image(systemName: "camera.fill")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                Text("Start Creating Memories")
                                    .font(.system(size: 18, weight: .bold))
                                
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(.white)
                            .cornerRadius(28)
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        .scaleEffect(1.0)
                        .buttonStyle(ScaleButtonStyle())
                        
                        // Secondary CTA
                        Button(action: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                appState.currentScreen = .paywall
                            }
                        }) {
                            Text("View Premium Features")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .underline()
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 40))
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
} 