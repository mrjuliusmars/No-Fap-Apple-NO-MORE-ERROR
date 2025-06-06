import SwiftUI

struct CreatePostView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var content = ""
    @State private var isContentExpanded = false
    
    // Computed property to check if form is valid
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Button("Cancel") {
                            dismiss()
                        }
                        .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text("Create Post")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button("Post") {
                            // Handle post creation
                            dismiss()
                        }
                        .foregroundColor(isFormValid ? .white : .white.opacity(0.4))
                        .disabled(!isFormValid)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 20)
                    
                    // Form Content
                    VStack(spacing: 24) {
                        // Title Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            TextField("Enter post title...", text: $title)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.white.opacity(0.08))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                        )
                                )
                        }
                        
                        // Content Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Content")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            
                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.04))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                                    )
                                    .frame(minHeight: isContentExpanded ? 120 : 80)
                                
                                TextEditor(text: $content)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.clear)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minHeight: isContentExpanded ? 120 : 80)
                                    .onTapGesture {
                                        isContentExpanded = true
                                    }
                                
                                if content.isEmpty {
                                    Text("Share your thoughts...")
                                        .font(.system(size: 16))
                                        .foregroundColor(.white.opacity(0.3))
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 16)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                        
                        // Karma Reward Message
                        HStack(spacing: 12) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.yellow)
                            
                            Text("Post to earn karma points!")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.purple.opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple.opacity(0.4), lineWidth: 1)
                                )
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    Spacer()
                }
            }
            .background(
                // Purple starry background
                LinearGradient(
                    colors: [
                        Color.purple.opacity(0.3),
                        Color.purple.opacity(0.1),
                        Color.black
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CreatePostView()
        .preferredColorScheme(.dark)
} 