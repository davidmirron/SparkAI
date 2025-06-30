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
            case .camera:
                CameraView()
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
    @Published var isSubscribed = false
    
    enum AppScreen {
        case onboarding, camera, dateIdeas, paywall
    }
}

// MARK: - Date Ideas Models
struct DateIdea {
    let id = UUID()
    let title: String
    let description: String
    let cost: String
    let duration: String
    let viralPotential: Int
    let categories: [DateCategory]
    let season: Season?
    let location: LocationType
    let tags: [String]
}

enum DateCategory: String, CaseIterable {
    case budgetFriendly = "Budget Friendly"
    case quick = "Under 30 Min"
    case food = "Food Focused"
    case diy = "DIY & Crafts"
    case active = "Active & Outdoors"
    case indoor = "Cozy Indoors"
    case romantic = "Romantic"
    case adventure = "Adventure"
    case cultural = "Arts & Culture"
    case seasonal = "Seasonal Special"
    case newlyAdded = "Recently Added"
    
    var icon: String {
        switch self {
        case .budgetFriendly: return "dollarsign.circle.fill"
        case .quick: return "clock.fill"
        case .food: return "fork.knife.circle.fill"
        case .diy: return "hammer.fill"
        case .active: return "figure.run"
        case .indoor: return "house.fill"
        case .romantic: return "heart.fill"
        case .adventure: return "mountain.2.fill"
        case .cultural: return "theatermasks.fill"
        case .seasonal: return "leaf.fill"
        case .newlyAdded: return "sparkles"
        }
    }
    
    var color: Color {
        switch self {
        case .budgetFriendly: return .green
        case .quick: return .blue
        case .food: return .orange
        case .diy: return .purple
        case .active: return .red
        case .indoor: return .indigo
        case .romantic: return .pink
        case .adventure: return .cyan
        case .cultural: return .yellow
        case .seasonal: return .mint
        case .newlyAdded: return .teal
        }
    }
}

enum Season: String, CaseIterable {
    case spring = "Spring"
    case summer = "Summer"
    case autumn = "Autumn"
    case winter = "Winter"
    
    var icon: String {
        switch self {
        case .spring: return "leaf.fill"
        case .summer: return "sun.max.fill"
        case .autumn: return "leaf.arrow.circlepath"
        case .winter: return "snowflake"
        }
    }
    
    var color: Color {
        switch self {
        case .spring: return .green
        case .summer: return .yellow
        case .autumn: return .orange
        case .winter: return .blue
        }
    }
}

enum LocationType: String, CaseIterable {
    case indoor = "Behind Closed Doors"
    case outdoor = "Active & Out"
    case mixed = "Indoor & Outdoor"
    
    var icon: String {
        switch self {
        case .indoor: return "house.fill"
        case .outdoor: return "tree.fill"
        case .mixed: return "arrow.left.arrow.right"
        }
    }
}

// MARK: - Date Ideas Service
class SparkAIService: ObservableObject {
    static let shared = SparkAIService()
    
    func generateDateIdeas() async -> [DateIdea] {
        // Simulate processing time
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let allDateIdeas = [
            // Budget Friendly & Quick
            DateIdea(
                title: "Coffee Shop Poetry Battle",
                description: "Pick random books and read dramatic poetry to each other",
                cost: "Free",
                duration: "30 min",
                viralPotential: 9,
                categories: [.budgetFriendly, .quick, .cultural],
                season: nil,
                location: .indoor,
                tags: ["creative", "fun", "spontaneous"]
            ),
            
            // Food Focused & Seasonal
            DateIdea(
                title: "Farmers Market Breakfast",
                description: "Shop for fresh ingredients and cook breakfast together",
                cost: "$25",
                duration: "2 hours",
                viralPotential: 7,
                categories: [.food, .seasonal, .budgetFriendly],
                season: .summer,
                location: .mixed,
                tags: ["healthy", "local", "cooking"]
            ),
            
            // DIY & Indoor
            DateIdea(
                title: "Paint Your Partner Portrait",
                description: "Create silly portraits of each other with watercolors",
                cost: "$15",
                duration: "1.5 hours",
                viralPotential: 8,
                categories: [.diy, .indoor, .romantic],
                season: nil,
                location: .indoor,
                tags: ["artistic", "memorable", "laughs"]
            ),
            
            // Active & Adventure
            DateIdea(
                title: "Sunrise Hike & Breakfast",
                description: "Wake up early, hike to see sunrise, then breakfast picnic",
                cost: "$15",
                duration: "4 hours",
                viralPotential: 8,
                categories: [.active, .adventure, .food],
                season: .spring,
                location: .outdoor,
                tags: ["fitness", "nature", "early bird"]
            ),
            
            // Food & Indoor
            DateIdea(
                title: "Midnight Taco Making",
                description: "Make tacos from scratch at home with a twist competition",
                cost: "$20",
                duration: "2 hours",
                viralPotential: 8,
                categories: [.food, .indoor, .diy],
                season: nil,
                location: .indoor,
                tags: ["cooking", "late night", "competitive"]
            ),
            
            // Quick & Active
            DateIdea(
                title: "Neighborhood Photo Hunt",
                description: "Create a list of weird things to find and photograph",
                cost: "Free",
                duration: "45 min",
                viralPotential: 8,
                categories: [.quick, .active, .budgetFriendly],
                season: nil,
                location: .outdoor,
                tags: ["photography", "exploration", "creative"]
            ),
            
            // Romantic & Seasonal
            DateIdea(
                title: "Stargazing Picnic",
                description: "Find a dark spot, bring blankets and point out constellations",
                cost: "$30",
                duration: "3 hours",
                viralPotential: 7,
                categories: [.romantic, .seasonal, .active],
                season: .autumn,
                location: .outdoor,
                tags: ["peaceful", "intimate", "nature"]
            ),
            
            // Cultural & Indoor
            DateIdea(
                title: "Home Museum Tour",
                description: "Create exhibits of your belongings with funny descriptions",
                cost: "Free",
                duration: "1 hour",
                viralPotential: 9,
                categories: [.cultural, .indoor, .diy],
                season: .winter,
                location: .indoor,
                tags: ["creative", "storytelling", "personal"]
            ),
            
            // Adventure & Food
            DateIdea(
                title: "Food Truck Rally",
                description: "Visit 3 different food trucks and rate each experience",
                cost: "$40",
                duration: "2.5 hours",
                viralPotential: 7,
                categories: [.adventure, .food, .active],
                season: .summer,
                location: .outdoor,
                tags: ["variety", "exploration", "social"]
            ),
            
            // DIY & Quick
            DateIdea(
                title: "Build a Blanket Fort",
                description: "Engineer the ultimate living room fortress together",
                cost: "Free",
                duration: "45 min",
                viralPotential: 9,
                categories: [.diy, .quick, .indoor],
                season: .winter,
                location: .indoor,
                tags: ["cozy", "playful", "engineering"]
            ),
            
            // Recently Added & Trending
            DateIdea(
                title: "TikTok Dance Tutorial",
                description: "Learn a viral dance together and film your attempts",
                cost: "Free",
                duration: "30 min",
                viralPotential: 10,
                categories: [.newlyAdded, .quick, .active],
                season: nil,
                location: .indoor,
                tags: ["trending", "social media", "dancing"]
            ),
            
            // Seasonal & Romantic
            DateIdea(
                title: "Hot Chocolate Bar",
                description: "Create an elaborate hot chocolate station with toppings",
                cost: "$25",
                duration: "1 hour",
                viralPotential: 6,
                categories: [.seasonal, .romantic, .food],
                season: .winter,
                location: .indoor,
                tags: ["warm", "cozy", "sweet"]
            ),
            
            // Cultural & Active
            DateIdea(
                title: "Street Art Walking Tour",
                description: "Explore your city's murals and create your own chalk art",
                cost: "$10",
                duration: "2 hours",
                viralPotential: 7,
                categories: [.cultural, .active, .budgetFriendly],
                season: .spring,
                location: .outdoor,
                tags: ["artistic", "urban", "creative"]
            ),
            
            // Adventure & DIY
            DateIdea(
                title: "Backyard Camping",
                description: "Set up a tent, make s'mores, and tell ghost stories",
                cost: "$20",
                duration: "4 hours",
                viralPotential: 8,
                categories: [.adventure, .diy, .seasonal],
                season: .summer,
                location: .outdoor,
                tags: ["camping", "nostalgic", "outdoor"]
            ),
            
            // Food & Romantic
            DateIdea(
                title: "Wine & Paint Night",
                description: "Paint while sipping wine and see who creates the masterpiece",
                cost: "$50",
                duration: "2.5 hours",
                viralPotential: 6,
                categories: [.romantic, .cultural, .diy],
                season: nil,
                location: .indoor,
                tags: ["artistic", "relaxing", "classy"]
            )
        ]
        
        // Return 6-8 random date ideas
        return Array(allDateIdeas.shuffled().prefix(Int.random(in: 6...8)))
    }
    
    func getDateIdeas(filteredBy categories: [DateCategory] = [], season: Season? = nil, location: LocationType? = nil) async -> [DateIdea] {
        let allIdeas = await generateDateIdeas()
        
        return allIdeas.filter { idea in
            let categoryMatch = categories.isEmpty || categories.contains { category in
                idea.categories.contains(category)
            }
            
            let seasonMatch = season == nil || idea.season == season
            let locationMatch = location == nil || idea.location == location
            
            return categoryMatch && seasonMatch && locationMatch
        }
    }
}

#Preview {
    ContentView()
}
