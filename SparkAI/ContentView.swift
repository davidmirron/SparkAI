//
//  ContentView.swift
//  SparkAI
//
//  Created by David Miron on 26.06.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            switch appState.currentScreen {
            case .onboarding:
                OnboardingView()
            case .dateIdeas:
                DateIdeasView()
            case .paywall:
                PaywallView()
            }
        }
        .environmentObject(appState)
    }
}

// MARK: - App State Management
class AppState: ObservableObject {
    @Published var currentScreen: AppScreen = .onboarding
    @Published var capturedImage: UIImage?
    @Published var dateIdeas: [DateIdea] = []
    
    init() {
        // Load initial date ideas
        dateIdeas = SparkAIService.shared.sampleDateIdeas
    }
}

enum AppScreen {
    case onboarding
    case dateIdeas
    case paywall
}

// MARK: - Data Models
struct DateIdea: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let cost: String
    let duration: String
    let viralPotential: Int
    let categories: [DateCategory]
    let season: Season
    let location: LocationType
    let tags: [String]
}

enum DateCategory: String, CaseIterable {
    case budgetFriendly = "Budget Friendly"
    case under30Min = "Under 30 Min"
    case foodFocused = "Food Focused"
    case diyAndCrafts = "DIY & Crafts"
    case active = "Active & Out"
    case cozy = "Cozy Indoors"
    case romantic = "Romantic"
    case adventure = "Adventure"
    case artsAndCulture = "Arts & Culture"
    case seasonal = "Seasonal Special"
    case recentlyAdded = "Recently Added"
    
    var color: Color {
        switch self {
        case .budgetFriendly: return .green
        case .under30Min: return .blue
        case .foodFocused: return .orange
        case .diyAndCrafts: return .purple
        case .active: return .red
        case .cozy: return .indigo
        case .romantic: return .pink
        case .adventure: return .cyan
        case .artsAndCulture: return .yellow
        case .seasonal: return .mint
        case .recentlyAdded: return .teal
        }
    }
    
    var icon: String {
        switch self {
        case .budgetFriendly: return "dollarsign.circle"
        case .under30Min: return "clock"
        case .foodFocused: return "fork.knife"
        case .diyAndCrafts: return "hammer"
        case .active: return "figure.run"
        case .cozy: return "house"
        case .romantic: return "heart"
        case .adventure: return "mountain.2"
        case .artsAndCulture: return "theatermasks"
        case .seasonal: return "leaf"
        case .recentlyAdded: return "sparkles"
        }
    }
}

enum Season: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .autumn: return .orange
        case .winter: return .blue
        }
    }
    
    var icon: String {
        switch self {
        case .spring: return "leaf"
        case .summer: return "sun.max"
        case .autumn: return "leaf.fill"
        case .winter: return "snowflake"
        }
    }
}

enum LocationType: String, CaseIterable {
    case indoor = "Indoor"
    case outdoor = "Outdoor"
    case both = "Indoor & Outdoor"
    
    var icon: String {
        switch self {
        case .indoor: return "house"
        case .outdoor: return "tree"
        case .both: return "arrow.left.and.right"
        }
    }
}

// MARK: - Service
class SparkAIService {
    static let shared = SparkAIService()
    private init() {}
    
    var sampleDateIdeas: [DateIdea] {
        [
            DateIdea(
                title: "Sunrise Hiking Adventure",
                description: "Wake up early and hike to a beautiful viewpoint to watch the sunrise together",
                cost: "Free",
                duration: "3 hours",
                viralPotential: 9,
                categories: [.adventure, .active, .budgetFriendly],
                season: .summer,
                location: .outdoor,
                tags: ["nature", "exercise", "photography"]
            ),
            DateIdea(
                title: "Food Truck Rally",
                description: "Visit 3 different food trucks and rate each experience",
                cost: "$40",
                duration: "2.5 hours",
                viralPotential: 7,
                categories: [.foodFocused, .adventure, .active],
                season: .summer,
                location: .outdoor,
                tags: ["food", "variety", "local"]
            ),
            DateIdea(
                title: "Farmers Market Breakfast",
                description: "Shop for fresh ingredients and cook breakfast together",
                cost: "$25",
                duration: "2 hours",
                viralPotential: 7,
                categories: [.foodFocused, .seasonal, .budgetFriendly],
                season: .summer,
                location: .both,
                tags: ["healthy", "local", "cooking"]
            ),
            DateIdea(
                title: "Wine & Paint Night",
                description: "Paint while sipping wine and see who creates the masterpiece",
                cost: "$50",
                duration: "2.5 hours",
                viralPotential: 6,
                categories: [.romantic, .artsAndCulture],
                season: .autumn,
                location: .indoor,
                tags: ["creative", "wine", "art"]
            ),
            DateIdea(
                title: "TikTok Dance Tutorial",
                description: "Learn a viral dance together and film your attempts",
                cost: "Free",
                duration: "30 min",
                viralPotential: 10,
                categories: [.recentlyAdded, .under30Min],
                season: .winter,
                location: .indoor,
                tags: ["social", "fun", "viral"]
            ),
            DateIdea(
                title: "Mystery Picnic Box",
                description: "Pack surprise items for each other and have a mystery picnic",
                cost: "$20",
                duration: "1.5 hours",
                viralPotential: 8,
                categories: [.romantic, .budgetFriendly, .seasonal],
                season: .spring,
                location: .outdoor,
                tags: ["surprise", "picnic", "creative"]
            )
        ]
    }
    
    func generateDateIdeas() async -> [DateIdea] {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Return shuffled ideas to simulate "new" content
        return sampleDateIdeas.shuffled()
    }
}

#Preview {
    ContentView()
}
