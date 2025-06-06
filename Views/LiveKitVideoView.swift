import SwiftUI

#if canImport(LiveKit)
import LiveKit

struct LiveKitVideoView: View {
    let track: VideoTrack
    
    var body: some View {
        // Actual LiveKit video implementation
        VideoView(track)
    }
}
#else
// Fallback when LiveKit is not available
struct LiveKitVideoView: View {
    let track: Any
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.black.opacity(0.8))
            
            VStack(spacing: 16) {
                Image(systemName: "video.slash")
                    .font(.system(size: 48))
                    .foregroundColor(.white.opacity(0.6))
                
                Text("Video Unavailable")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))
                
                Text("LiveKit module not available")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }
}
#endif 