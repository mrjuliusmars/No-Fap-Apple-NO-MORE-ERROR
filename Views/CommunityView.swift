import SwiftUI

struct CommunityView: View {
    @State private var selectedTab = "Forum"
    @State private var showNewPostOptions = false
    @State private var sortBy = "New" // "New" or "Trending"
    @State private var showCreatePost = false
    
    // Sample forum posts data
    let forumPosts = [
        ForumPost(
            id: 1,
            title: "First Day",
            content: "Well, shit im hoping this is the final straw. Been watching porn since i was 11, at 14 i...",
            author: "Jose",
            streakDays: 0,
            timeAgo: "1 hour ago",
            upvotes: 14,
            badge: "No Fap"
        ),
        ForumPost(
            id: 2,
            title: "Tempted",
            content: "I felt tempted for the first time in a long time. All by myself, I had the idea pop in...",
            author: "Myles",
            streakDays: 70,
            timeAgo: "1 hour ago",
            upvotes: 0,
            badge: "No Fap"
        ),
        ForumPost(
            id: 3,
            title: "Dont smoke weed",
            content: "Smoked weed. Relapsed. Easy to do when you're stoned as",
            author: "Jed",
            streakDays: 0,
            timeAgo: "1 hour ago",
            upvotes: 0,
            badge: "No Fap"
        ),
        ForumPost(
            id: 4,
            title: "Visualization",
            content: "Whenever you feel like relapsing, i want you to visualize yourself free from all...",
            author: "Mohammed",
            streakDays: 0,
            timeAgo: "1 hour ago",
            upvotes: 91,
            badge: "No Fap"
        )
    ]
    
    // Computed property to sort posts based on selected sort option
    private var sortedPosts: [ForumPost] {
        if sortBy == "Trending" {
            return forumPosts.sorted { $0.upvotes > $1.upvotes }
        } else {
            return forumPosts // Already in chronological order (new first)
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top Header
                HStack {
                    Text("Community")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "doc.plaintext")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
                
                // Tab Bar
                HStack {
                    // Forum Tab
                    Button(action: { selectedTab = "Forum" }) {
                        Text("Forum")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedTab == "Forum" ? .black : .white.opacity(0.7))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                selectedTab == "Forum" ? 
                                    Color.white : Color.clear
                            )
                            .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    // Sort Button
                    Button(action: { sortBy = sortBy == "New" ? "Trending" : "New" }) {
                        HStack(spacing: 8) {
                            Text(sortBy)
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Content
                ZStack {
                    // Forum Posts
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(sortedPosts) { post in
                                ForumPostRow(post: post)
                                    .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 16)
                    }
                    
                    // Floating Add Button
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: { showCreatePost = true }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(width: 56, height: 56)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .padding(.trailing, 20)
                            .padding(.bottom, 100)
                        }
                    }
                }
                
                Spacer()
                
                // Bottom Navigation
                HStack {
                    Spacer()
                    BottomNavButton(icon: "square.grid.2x2.fill", isSelected: false)
                    Spacer()
                    BottomNavButton(icon: "chart.xyaxis.line", isSelected: false)
                    Spacer()
                    BottomNavButton(icon: "bubble.left.and.bubble.right.fill", isSelected: true)
                    Spacer()
                    BottomNavButton(icon: "person.crop.circle", isSelected: false)
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.bottom, 8)
                .frame(height: 60)
                .background(Color.black.opacity(0.35))
            }
        }
        .background(
            // Purple theme background
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
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showCreatePost) {
            CreatePostView()
        }
    }
}

struct ForumPost: Identifiable {
    let id: Int
    let title: String
    let content: String
    let author: String
    let streakDays: Int
    let timeAgo: String
    let upvotes: Int
    let badge: String
}

struct ForumPostRow: View {
    let post: ForumPost
    @State private var isUpvoted = false
    @State private var upvoteCount: Int
    
    init(post: ForumPost) {
        self.post = post
        self._upvoteCount = State(initialValue: post.upvotes)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Post Content
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(post.content)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                HStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text(post.author)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text("\(post.streakDays) Day Streak")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("•")
                        .foregroundColor(.white.opacity(0.5))
                    
                    Text(post.timeAgo)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                // Badge
                Text(post.badge)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.purple.opacity(0.6))
                    .cornerRadius(6)
            }
            
            Spacer()
            
            // Upvote Section
            VStack(spacing: 4) {
                Button(action: {
                    isUpvoted.toggle()
                    upvoteCount += isUpvoted ? 1 : -1
                }) {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isUpvoted ? Color.purple : .white.opacity(0.7))
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(isUpvoted ? 0.2 : 0.1))
                        )
                }
                
                Text("\(upvoteCount)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.purple.opacity(0.2), lineWidth: 1)
                )
        )
        .padding(.bottom, 16)
    }
}

#Preview {
    CommunityView()
        .preferredColorScheme(.dark)
} 