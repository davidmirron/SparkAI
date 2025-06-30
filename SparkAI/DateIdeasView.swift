import SwiftUI

struct DateIdeasView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedDateIdea: DateIdea?
    @State private var isGeneratingMore = false
    @State private var showingDetailSheet = false
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
                                        showingDetailSheet = true
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
        .sheet(isPresented: $showingDetailSheet) {
            if let selectedIdea = selectedDateIdea {
                CleanDateDetailView(dateIdea: selectedIdea)
            }
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
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Hero Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text(dateIdea.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text(dateIdea.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
                    // Clean Stats Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        CleanStatCard(title: "Cost", value: dateIdea.cost, icon: "dollarsign.circle", color: .green)
                        CleanStatCard(title: "Duration", value: dateIdea.duration, icon: "clock", color: .blue)
                        CleanStatCard(title: "Location", value: dateIdea.location.rawValue, icon: "location", color: .purple)
                        CleanStatCard(title: "Viral Score", value: "\(dateIdea.viralPotential)/10", icon: "flame", color: .orange)
                    }
                    
                    // Categories
                    if !dateIdea.categories.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Categories")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(dateIdea.categories, id: \.self) { category in
                                    Text(category.rawValue)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(category.color.opacity(0.8))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                    
                    // Tags
                    if !dateIdea.tags.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Tags")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(dateIdea.tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.1))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                }
                .padding(24)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .medium))
                }
            }
        }
    }
}

struct CleanStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
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

// Keep the existing FlowLayout
struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        let height = rows.reduce(0) { $0 + $1.maxHeight } + CGFloat(max(0, rows.count - 1)) * spacing
        return CGSize(width: proposal.width ?? 0, height: height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let rows = computeRows(proposal: proposal, subviews: subviews)
        var currentY = bounds.minY
        
        for row in rows {
            var currentX = bounds.minX
            
            for subview in row.subviews {
                subview.place(at: CGPoint(x: currentX, y: currentY), proposal: ProposedViewSize(width: subview.sizeThatFits(.unspecified).width, height: row.maxHeight))
                currentX += subview.sizeThatFits(.unspecified).width + spacing
            }
            
            currentY += row.maxHeight + spacing
        }
    }
    
    private func computeRows(proposal: ProposedViewSize, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var currentRow = Row()
        var currentRowWidth: CGFloat = 0
        
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(.unspecified)
            
            if currentRowWidth + subviewSize.width + spacing > (proposal.width ?? .infinity) && !currentRow.subviews.isEmpty {
                rows.append(currentRow)
                currentRow = Row()
                currentRowWidth = 0
            }
            
            currentRow.subviews.append(subview)
            currentRow.maxHeight = max(currentRow.maxHeight, subviewSize.height)
            currentRowWidth += subviewSize.width + spacing
        }
        
        if !currentRow.subviews.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    private struct Row {
        var subviews: [LayoutSubview] = []
        var maxHeight: CGFloat = 0
    }
}

#Preview {
    DateIdeasView()
        .environmentObject(AppState())
}