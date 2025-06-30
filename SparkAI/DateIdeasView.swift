import SwiftUI

struct DateIdeasView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDateIdea: DateIdea?
    @State private var isGeneratingMore = false
    @State private var showingFilters = false
    
    // Filter States
    @State private var selectedCategories: Set<DateCategory> = []
    @State private var selectedSeason: Season?
    @State private var selectedLocation: LocationType?
    @State private var searchText = ""
    
    var filteredDateIdeas: [DateIdea] {
        appState.dateIdeas.filter { idea in
            let categoryMatch = selectedCategories.isEmpty || selectedCategories.contains { category in
                idea.categories.contains(category)
            }
            
            let seasonMatch = selectedSeason == nil || idea.season == selectedSeason
            let locationMatch = selectedLocation == nil || idea.location == selectedLocation
            
            let searchMatch = searchText.isEmpty || 
                idea.title.localizedCaseInsensitiveContains(searchText) ||
                idea.description.localizedCaseInsensitiveContains(searchText) ||
                idea.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            
            return categoryMatch && seasonMatch && locationMatch && searchMatch
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Clean background
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Minimal Header
                    VStack(spacing: 20) {
                        // Title and Navigation
                        HStack {
                            Button(action: { appState.currentScreen = .onboarding }) {
                                Image(systemName: "chevron.left")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(Circle())
                            }
                            
                            Spacer()
                            
                            VStack(spacing: 2) {
                                Text("Date Ideas")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                
                                Text("\(filteredDateIdeas.count) ideas")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            
                            Spacer()
                            
                            Button(action: { 
                                withAnimation(.spring()) {
                                    showingFilters.toggle() 
                                }
                            }) {
                                Image(systemName: showingFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 44, height: 44)
                                    .background(Color.white.opacity(showingFilters ? 0.3 : 0.1))
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
                        // Minimal Search
                        HStack(spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 16))
                            
                            TextField("Search ideas...", text: $searchText)
                                .textFieldStyle(PlainTextFieldStyle())
                                .foregroundColor(.white)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(Color.white.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .padding(.horizontal, 24)
                        
                        // Clean Filters
                        if showingFilters {
                            VStack(spacing: 16) {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ForEach(DateCategory.allCases, id: \.self) { category in
                                            CleanFilterChip(
                                                title: category.rawValue,
                                                isSelected: selectedCategories.contains(category)
                                            ) {
                                                withAnimation(.spring()) {
                                                    if selectedCategories.contains(category) {
                                                        selectedCategories.remove(category)
                                                    } else {
                                                        selectedCategories.insert(category)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 24)
                                }
                                
                                if !selectedCategories.isEmpty || selectedSeason != nil || selectedLocation != nil {
                                    Button("Clear All") {
                                        withAnimation(.spring()) {
                                            selectedCategories.removeAll()
                                            selectedSeason = nil
                                            selectedLocation = nil
                                            searchText = ""
                                        }
                                    }
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.white.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                            .padding(.bottom, 8)
                            .transition(.asymmetric(
                                insertion: .opacity.combined(with: .move(edge: .top)),
                                removal: .opacity.combined(with: .move(edge: .top))
                            ))
                        }
                    }
                    .background(
                        Color.black
                            .background(.ultraThinMaterial.opacity(0.3))
                    )
                    
                    // Clean Grid
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 16) {
                            ForEach(Array(filteredDateIdeas.enumerated()), id: \.element.id) { index, dateIdea in
                                CleanDateCard(dateIdea: dateIdea, index: index)
                                    .onTapGesture {
                                        selectedDateIdea = dateIdea
                                    }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                        .padding(.bottom, 120)
                    }
                }
                
                // Floating More Button
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button(action: generateMoreIdeas) {
                            HStack(spacing: 8) {
                                if isGeneratingMore {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.9)
                                } else {
                                    Image(systemName: "plus")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                                
                                Text(isGeneratingMore ? "Generating..." : "More Ideas")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                LinearGradient(
                                    colors: [.purple, .blue],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .shadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .disabled(isGeneratingMore)
                        .scaleEffect(isGeneratingMore ? 0.95 : 1.0)
                        .animation(.spring(), value: isGeneratingMore)
                        
                        Spacer()
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .sheet(item: $selectedDateIdea) { dateIdea in
            CleanDateDetailView(dateIdea: dateIdea)
        }
    }
    
    private func generateMoreIdeas() {
        guard !isGeneratingMore else { return }
        
        withAnimation(.spring()) {
            isGeneratingMore = true
        }
        
        Task {
            let newIdeas = await SparkAIService.shared.generateDateIdeas()
            
            await MainActor.run {
                withAnimation(.spring()) {
                    appState.dateIdeas = newIdeas
                    isGeneratingMore = false
                }
            }
        }
    }
}

// MARK: - Clean Components

struct CleanFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .black : .white.opacity(0.8))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .white : Color.white.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(duration: 0.3), value: isSelected)
    }
}

struct CleanDateCard: View {
    let dateIdea: DateIdea
    let index: Int
    @State private var isVisible = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Viral Score Badge
            HStack {
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text("\(dateIdea.viralPotential)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.orange.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Main Content
            VStack(alignment: .leading, spacing: 12) {
                Text(dateIdea.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(dateIdea.description)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.7))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                // Clean Bottom Info
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(dateIdea.cost)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.green)
                        
                        Text(dateIdea.duration)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    Spacer()
                    
                    // Single primary category
                    if let primaryCategory = dateIdea.categories.first {
                        Text(primaryCategory.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white.opacity(0.9))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
        )
        .scaleEffect(isVisible ? 1.0 : 0.9)
        .opacity(isVisible ? 1.0 : 0)
        .animation(
            .spring(dampingFraction: 0.8)
            .delay(Double(index) * 0.1),
            value: isVisible
        )
        .onAppear {
            isVisible = true
        }
    }
}

struct CleanDateDetailView: View {
    let dateIdea: DateIdea
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Hero Section with better styling
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(dateIdea.title)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(.orange)
                                    Text("\(dateIdea.viralPotential) viral score")
                                        .font(.subheadline)
                                        .foregroundColor(.orange)
                                }
                            }
                            
                            Spacer()
                        }
                        
                        Text(dateIdea.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(6)
                    }
                    .padding(.bottom, 8)
                    
                    // Quick Info Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        QuickInfoCard(title: "Cost", value: dateIdea.cost, icon: "dollarsign.circle.fill", color: .green)
                        QuickInfoCard(title: "Duration", value: dateIdea.duration, icon: "clock.fill", color: .blue)
                        QuickInfoCard(title: "Location", value: dateIdea.location.rawValue, icon: "location.fill", color: .purple)
                        QuickInfoCard(title: "Season", value: dateIdea.season.rawValue, icon: dateIdea.season.icon, color: dateIdea.season.color)
                    }
                    
                    // Categories Section
                    if !dateIdea.categories.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(dateIdea.categories, id: \.self) { category in
                                        Text(category.rawValue)
                                            .font(.subheadline)
                                            .fontWeight(.medium)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(category.color)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                                .padding(.horizontal, 1)
                            }
                        }
                    }
                    
                    // Tags Section
                    if !dateIdea.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Perfect For")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    ForEach(dateIdea.tags, id: \.self) { tag in
                                        Text(tag.capitalized)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.secondary)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Color.gray.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .padding(.horizontal, 1)
                            }
                        }
                    }
                    
                    Spacer(minLength: 40)
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Date Idea")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

struct QuickInfoCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}



#Preview {
    DateIdeasView()
        .environmentObject(AppState())
}