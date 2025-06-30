import SwiftUI

struct PaywallView: View {
    @EnvironmentObject var appState: AppState
    @State private var animateFeatures = false
    @State private var selectedPlan = 0 // 0 = weekly, 1 = yearly
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Premium gradient background
                LinearGradient(
                    colors: [
                        Color.purple,
                        Color.pink,
                        Color.orange.opacity(0.8),
                        Color.black
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 32) {
                        // Header
                        HStack {
                            Button(action: {
                                withAnimation(.spring()) {
                                    appState.currentScreen = .onboarding
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 4) {
                                Text("SparkAI")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Text("Premium")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.yellow)
                            }
                            
                            Spacer()
                            
                            Color.clear.frame(width: 44, height: 44)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // Hero Section
                        VStack(spacing: 24) {
                            ZStack {
                                Circle()
                                    .fill(.white.opacity(0.2))
                                    .frame(width: 120, height: 120)
                                    .blur(radius: 20)
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 50, weight: .medium))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.yellow, .orange],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            }
                            
                            VStack(spacing: 12) {
                                Text("Unlock Unlimited")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundColor(.white)
                                
                                Text("Date Adventures")
                                    .font(.system(size: 32, weight: .black, design: .rounded))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.yellow, .orange],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                
                                Text("Join 47,000+ couples creating unforgettable memories together")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Features Grid
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            PremiumFeatureCard(
                                icon: "infinity",
                                title: "Unlimited Ideas",
                                description: "Never run out of date inspiration",
                                accent: .blue
                            )
                            
                            PremiumFeatureCard(
                                icon: "wand.and.rays",
                                title: "AI Curation",
                                description: "Personalized for your interests",
                                accent: .purple
                            )
                            
                            PremiumFeatureCard(
                                icon: "location.fill",
                                title: "Local Spots",
                                description: "Discover hidden gems nearby",
                                accent: .green
                            )
                            
                            PremiumFeatureCard(
                                icon: "heart.circle.fill",
                                title: "Couple Sync",
                                description: "Match both your preferences",
                                accent: .pink
                            )
                        }
                        .padding(.horizontal, 20)
                        .opacity(animateFeatures ? 1.0 : 0.0)
                        .animation(.spring(response: 0.8, dampingFraction: 0.8).delay(0.3), value: animateFeatures)
                        
                        // Pricing Plans
                        VStack(spacing: 16) {
                            Text("Choose Your Plan")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                            
                            VStack(spacing: 12) {
                                // Yearly Plan (Recommended)
                                PricingCard(
                                    title: "Yearly",
                                    price: "$49",
                                    period: "/year",
                                    savings: "Save 75%",
                                    perMonth: "$4.08/month",
                                    isSelected: selectedPlan == 1,
                                    isRecommended: true
                                ) {
                                    selectedPlan = 1
                                }
                                
                                // Weekly Plan
                                PricingCard(
                                    title: "Weekly",
                                    price: "$6.99",
                                    period: "/week",
                                    savings: nil,
                                    perMonth: nil,
                                    isSelected: selectedPlan == 0,
                                    isRecommended: false
                                ) {
                                    selectedPlan = 0
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // CTA Section
                        VStack(spacing: 20) {
                            Button(action: {
                                withAnimation(.spring()) {
                                    // Simulate subscription success
                                    appState.currentScreen = .dateIdeas
                                }
                            }) {
                                HStack(spacing: 12) {
                                    Image(systemName: "crown.fill")
                                        .font(.system(size: 20, weight: .bold))
                                    
                                    Text("Start Premium Free Trial")
                                        .font(.system(size: 18, weight: .bold))
                                    
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(.white)
                                .cornerRadius(28)
                                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            
                            // Trust indicators
                            VStack(spacing: 8) {
                                HStack(spacing: 16) {
                                    TrustBadge(icon: "checkmark.shield.fill", text: "7-day free trial")
                                    TrustBadge(icon: "arrow.clockwise", text: "Cancel anytime")
                                }
                                
                                HStack(spacing: 4) {
                                    ForEach(0..<5) { _ in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 12))
                                            .foregroundColor(.yellow)
                                    }
                                    
                                    Text("4.9 • 2,847 reviews")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            
                            // Skip option
                            Button(action: {
                                withAnimation(.spring()) {
                                    appState.currentScreen = .dateIdeas
                                }
                            }) {
                                Text("Continue with Free Version")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.7))
                                    .underline()
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, max(geometry.safeAreaInsets.bottom, 20))
                    }
                }
            }
        }
        .onAppear {
            withAnimation {
                animateFeatures = true
            }
        }
    }
}

struct PremiumFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let accent: Color
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.2))
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(accent)
            }
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.white.opacity(0.2), lineWidth: 1)
                )
        )
    }
}

struct PricingCard: View {
    let title: String
    let price: String
    let period: String
    let savings: String?
    let perMonth: String?
    let isSelected: Bool
    let isRecommended: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        if isRecommended {
                            Text("BEST VALUE")
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.black)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(.yellow)
                                .cornerRadius(4)
                        }
                    }
                    
                    HStack(alignment: .bottom, spacing: 2) {
                        Text(price)
                            .font(.system(size: 24, weight: .black))
                            .foregroundColor(.white)
                        
                        Text(period)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    if let perMonth = perMonth {
                        Text(perMonth)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    if let savings = savings {
                        Text(savings)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    Circle()
                        .fill(isSelected ? .white : .clear)
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        )
                        .overlay(
                            Circle()
                                .fill(.black)
                                .frame(width: 8, height: 8)
                                .opacity(isSelected ? 1 : 0)
                        )
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? .white.opacity(0.15) : .white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(isSelected ? .white : .white.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TrustBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.green)
            
            Text(text)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.white.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    PaywallView()
        .environmentObject(AppState())
} 