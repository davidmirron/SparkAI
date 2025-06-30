import SwiftUI
import UIKit
import AVFoundation

struct CameraView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingPermissionAlert = false
    @State private var cameraError: String?
    @State private var isGenerating = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Dynamic gradient background
                LinearGradient(
                    colors: [
                        Color.black,
                        Color.purple.opacity(0.3),
                        Color.pink.opacity(0.2)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with back button
                    HStack {
                        Button(action: {
                            withAnimation(.spring()) {
                                appState.currentScreen = .onboarding
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        Text("Capture the Moment")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        // Placeholder for symmetry
                        Color.clear
                            .frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    // Main Content
                    VStack(spacing: 40) {
                        // Camera preview area (Instagram-style)
                        ZStack {
                            // Background card
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.white.opacity(0.05))
                                .frame(width: min(geometry.size.width - 40, 320), 
                                       height: min(geometry.size.width - 40, 320) * 1.3)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 24)
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                )
                            
                            VStack(spacing: 24) {
                                // Camera icon with animation
                                ZStack {
                                    Circle()
                                        .fill(.white.opacity(0.1))
                                        .frame(width: 80, height: 80)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 32, weight: .medium))
                                        .foregroundColor(.white)
                                        .scaleEffect(1.0 + sin(Date().timeIntervalSince1970 * 2) * 0.05)
                                }
                                
                                VStack(spacing: 12) {
                                    Text("Ready for your date night?")
                                        .font(.system(size: 22, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Take a selfie together or skip to get personalized date ideas instantly")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                        .lineLimit(3)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Action buttons (TikTok-style layout)
                        VStack(spacing: 20) {
                            // Primary camera button
                            Button(action: {
                                checkCameraPermissionAndPresent()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 80, height: 80)
                                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                                    
                                    Circle()
                                        .stroke(.white.opacity(0.3), lineWidth: 4)
                                        .frame(width: 92, height: 92)
                                    
                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                            }
                            .scaleEffect(1.0)
                            .buttonStyle(ScaleButtonStyle())
                            
                            // Secondary actions
                            HStack(spacing: 32) {
                                // Photo library button
                                VStack(spacing: 8) {
                                    Button(action: {
                                        showingImagePicker = true
                                    }) {
                                        Circle()
                                            .fill(.white.opacity(0.15))
                                            .frame(width: 56, height: 56)
                                            .overlay(
                                                Image(systemName: "photo.on.rectangle")
                                                    .font(.system(size: 20, weight: .semibold))
                                                    .foregroundColor(.white)
                                            )
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                    
                                    Text("Photos")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                
                                // Skip button
                                VStack(spacing: 8) {
                                    Button(action: {
                                        generateDateIdeasDirectly()
                                    }) {
                                        Circle()
                                            .fill(.white.opacity(0.15))
                                            .frame(width: 56, height: 56)
                                            .overlay(
                                                Image(systemName: isGenerating ? "circle.dashed" : "arrow.right")
                                                    .font(.system(size: 20, weight: .semibold))
                                                    .foregroundColor(.white)
                                                    .rotationEffect(.degrees(isGenerating ? 360 : 0))
                                                    .animation(
                                                        isGenerating ? 
                                                        .linear(duration: 1).repeatForever(autoreverses: false) : 
                                                        .default, 
                                                        value: isGenerating
                                                    )
                                            )
                                    }
                                    .buttonStyle(ScaleButtonStyle())
                                    .disabled(isGenerating)
                                    
                                    Text("Skip")
                                        .font(.system(size: 12, weight: .medium))
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Bottom tip
                    VStack(spacing: 8) {
                        Text("💡 Pro tip")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.yellow)
                        
                        Text("Looking at each other creates better date suggestions")
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom, 20))
                }
            }
        }
        .sheet(isPresented: $showingCamera) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                ImagePicker(sourceType: .camera) { image in
                    processSelectedImage(image)
                }
            } else {
                CameraUnavailableView()
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                processSelectedImage(image)
            }
        }
        .alert("Camera Permission Required", isPresented: $showingPermissionAlert) {
            Button("Settings") {
                if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsUrl)
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("SparkAI needs camera access to capture your moments. Enable camera access in Settings to continue.")
        }
        .alert("Camera Error", isPresented: .constant(cameraError != nil)) {
            Button("OK") {
                cameraError = nil
            }
        } message: {
            Text(cameraError ?? "")
        }
    }
    
    private func checkCameraPermissionAndPresent() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                showingCamera = true
            } else {
                cameraError = "Camera is not available on this device"
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) {
                            showingCamera = true
                        } else {
                            cameraError = "Camera is not available on this device"
                        }
                    } else {
                        showingPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showingPermissionAlert = true
        @unknown default:
            cameraError = "Unknown camera permission status"
        }
    }
    
    private func processSelectedImage(_ image: UIImage) {
        appState.capturedImage = image
        generateDateIdeasDirectly()
    }
    
    private func generateDateIdeasDirectly() {
        isGenerating = true
        
        Task {
            let dateIdeas = await SparkAIService.shared.generateDateIdeas()
            
            await MainActor.run {
                withAnimation(.spring()) {
                    appState.dateIdeas = dateIdeas
                    appState.currentScreen = .dateIdeas
                    isGenerating = false
                }
            }
        }
    }
}

struct CameraUnavailableView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "camera.fill")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            VStack(spacing: 12) {
                Text("Camera Not Available")
                    .font(.title2.bold())
                    .foregroundColor(.primary)
                
                Text("Camera access is not available on this device. Please use the photo library instead.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Button("OK") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(20)
    }
}

// MARK: - Image Picker (Enhanced)
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImageSelected: (UIImage) -> Void
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        
        // Enhanced camera settings
        if sourceType == .camera {
            picker.cameraDevice = .front
            picker.cameraFlashMode = .auto
        }
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.onImageSelected(image)
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview {
    CameraView()
        .environmentObject(AppState())
} 