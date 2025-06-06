import Foundation
import Combine
import SwiftUI
import AVFoundation
import Network

#if canImport(LiveKit)
import LiveKit
#else
// Placeholder types when LiveKit is not available
typealias VideoTrack = NSObject
typealias VideoView = NSObject
typealias AudioTrack = NSObject
typealias RemoteParticipant = NSObject
typealias RemoteTrackPublication = NSObject
typealias LiveKitError = NSError

// Placeholder for Room
class Room: NSObject {
    init(roomOptions: RoomOptions? = nil) {
        super.init()
    }
    
    func add(delegate: RoomDelegate) {
        // Placeholder implementation
    }
    
    func connect(url: String, token: String) async throws {
        // Placeholder implementation
        print("🎥 Placeholder Room connect called")
    }
    
    func disconnect() async {
        // Placeholder implementation
        print("🔌 Placeholder Room disconnect called")
    }
}

// Placeholder for RoomOptions
class RoomOptions: NSObject {
    let adaptiveStream: Bool
    let dynacast: Bool
    
    init(adaptiveStream: Bool, dynacast: Bool) {
        self.adaptiveStream = adaptiveStream
        self.dynacast = dynacast
        super.init()
    }
}

protocol RoomDelegate {}
#endif

// MARK: - Session Info Model
struct SessionInfo: Codable {
    let sessionId: String
    let url: String
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case url
        case accessToken = "access_token"
    }
}

// MARK: - API Response Models
struct HeyGenResponse<T: Codable>: Codable {
    let data: T
    let error: String?
    let code: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case error
        case code
        case message
    }
}

struct TokenResponse: Codable {
    let token: String
}

// MARK: - Connection Status
enum ConnectionStatus: Equatable {
    case disconnected
    case connecting
    case connected
    case error(String)
    
    var displayText: String {
        switch self {
        case .disconnected:
            return "Disconnected"
        case .connecting:
            return "Connecting..."
        case .connected:
            return "Connected"
        case .error(let message):
            return "Error: \(message)"
        }
    }
}

#if canImport(LiveKit)
// MARK: - LiveKit Room Delegate (Updated for latest LiveKit SDK)
extension NuroAvatarManager: RoomDelegate {
    func roomDidConnect(_ room: Room) {
        print("🔗 LiveKit room connected")
        Task { @MainActor in
            self.connectionStatus = .connected
        }
    }
    
    func room(_ room: Room, didDisconnectWithError error: LiveKitError?) {
        print("🔌 LiveKit room disconnected")
        if let error = error {
            print("❌ Disconnect error: \(error)")
        }
    }
    
    func room(_ room: Room, didFailToConnectWithError error: LiveKitError?) {
        print("❌ Failed to connect to LiveKit: \(error?.localizedDescription ?? "Unknown error")")
        Task { @MainActor in
            connectionStatus = .error("Failed to connect: \(error?.localizedDescription ?? "Unknown error")")
        }
    }
    
    func room(_ room: Room, participant: RemoteParticipant, didSubscribeTrack publication: RemoteTrackPublication) {
        guard let track = publication.track else { return }
        print("📺 Subscribed to track: \(track.kind) from participant: \(participant.identity)")
        
        if let videoTrack = track as? VideoTrack {
            DispatchQueue.main.async {
                self.remoteVideoTrack = videoTrack
                print("🎥 Video track received and set")
            }
        } else if track is AudioTrack {
            print("🔊 Audio track received")
        }
    }
    
    func room(_ room: Room, participant: RemoteParticipant, didUnsubscribeTrack publication: RemoteTrackPublication) {
        guard let track = publication.track else { return }
        print("📺 Unsubscribed from track: \(track.kind)")
        
        if track is VideoTrack {
            DispatchQueue.main.async {
                self.remoteVideoTrack = nil
                print("🎥 Video track removed")
            }
        }
    }
}
#else
// Fallback when LiveKit is not available
extension NuroAvatarManager: RoomDelegate {
    // Empty implementation for when LiveKit is not available
}
#endif

// MARK: - Nuro Avatar Manager (Following Official HeyGen Documentation)
class NuroAvatarManager: ObservableObject, @unchecked Sendable {
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var isSessionActive = false
    @Published var isMuted = false
    @Published var isCameraOn = true
    @Published var lastMessage: String = ""
    @Published var isAvatarSpeaking = false
    
    // Session management
    private var sessionToken: String?
    private var sessionInfo: SessionInfo?
    private var webSocket: URLSessionWebSocketTask?
    
    // LiveKit connection
    private var room: Room?
    private var videoView: VideoView?
    @Published var remoteVideoTrack: VideoTrack?
    
    // MARK: - Session Management (Following Official Flow)
    
    /// Step 1: Create session token
    func startSession() async {
        await MainActor.run {
            connectionStatus = .connecting
        }
        
        guard ApiConfig.isValid else {
            await MainActor.run {
                connectionStatus = .error(ApiConfig.configurationError ?? "Configuration error")
            }
            return
        }
        
        do {
            // Step 1: Get session token
            let token = try await createSessionToken()
            self.sessionToken = token
            
            // Step 2: Create new session
            let sessionInfo = try await createNewSession(token: token)
            self.sessionInfo = sessionInfo
            
            // Step 3: Start streaming session
            try await startStreamingSession(sessionId: sessionInfo.sessionId)
            
            // Step 4: Connect WebSocket for real-time events
            await connectWebSocket(sessionInfo: sessionInfo, token: token)
            
            // Step 5: Initialize LiveKit connection (placeholder)
            await initializeLiveKit(sessionInfo: sessionInfo)
            
            await MainActor.run {
                self.isSessionActive = true
                self.connectionStatus = .connected
            }
            
            print("✅ Session started successfully")
            
        } catch {
            await MainActor.run {
                connectionStatus = .error(error.localizedDescription)
            }
            print("❌ Session start failed: \(error)")
        }
    }
    
    /// End the session and cleanup
    func endSession() {
        Task {
            guard let sessionInfo = sessionInfo else { return }
            
            do {
                // Stop streaming session
                try await stopStreamingSession(sessionId: sessionInfo.sessionId)
            } catch {
                print("⚠️ Error stopping session: \(error)")
            }
            
            // Cleanup
            await cleanupSession()
        }
    }
    
    // MARK: - Communication
    
    /// Send text message to avatar (Talk mode - processes through LLM)
    func sendMessage(_ text: String) async {
        // Try WebSocket first for real-time conversation
        if let webSocket = webSocket {
            sendWebSocketMessage(text)
        } else {
            // Fallback to HTTP API
            await sendTask(text: text, taskType: "talk")
        }
    }
    
    /// Send real-time message via WebSocket for instant conversation
    private func sendWebSocketMessage(_ text: String) {
        let message = [
            "type": "chat",
            "message": text
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: message),
              let jsonString = String(data: jsonData, encoding: .utf8) else {
            print("❌ Failed to encode WebSocket message")
            return
        }
        
        webSocket?.send(.string(jsonString)) { error in
            if let error = error {
                print("❌ WebSocket send error: \(error)")
                // Fallback to HTTP if WebSocket fails
                Task {
                    await self.sendTask(text: text, taskType: "talk")
                }
            } else {
                DispatchQueue.main.async {
                    self.lastMessage = text
                }
                print("📤 Real-time message sent: \(text)")
            }
        }
    }
    
    /// Send text for avatar to repeat exactly
    func repeatText(_ text: String) async {
        await sendTask(text: text, taskType: "repeat")
    }
    
    private func sendTask(text: String, taskType: String) async {
        guard let sessionInfo = sessionInfo,
              let sessionToken = sessionToken,
              isSessionActive else {
            print("❌ No active session for sending message")
            return
        }
        
        await MainActor.run {
            lastMessage = text
            isAvatarSpeaking = true
        }
        
        do {
            try await sendStreamingTask(
                sessionId: sessionInfo.sessionId,
                token: sessionToken,
                text: text,
                taskType: taskType
            )
            print("📤 Sent \(taskType): \(text)")
        } catch {
            await MainActor.run {
                connectionStatus = .error("Failed to send message: \(error.localizedDescription)")
                isAvatarSpeaking = false
            }
            print("❌ Failed to send task: \(error)")
        }
    }
    
    // MARK: - Media Controls
    
    func toggleMute() {
        isMuted.toggle()
        // TODO: Implement with LiveKit SDK
        print("🔇 Audio \(isMuted ? "muted" : "unmuted")")
    }
    
    func toggleCamera() {
        isCameraOn.toggle()
        // TODO: Implement with LiveKit SDK  
        print("📹 Camera \(isCameraOn ? "enabled" : "disabled")")
    }
    
    // MARK: - API Implementation (Following Official Documentation)
    
    /// Step 1: Create session token
    private func createSessionToken() async throws -> String {
        let url = URL(string: "\(ApiConfig.baseURL)\(ApiConfig.createTokenEndpoint)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(ApiConfig.apiKey, forHTTPHeaderField: "X-Api-Key")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Debug: Print response for troubleshooting
        if let responseString = String(data: data, encoding: .utf8) {
            print("🔍 API Response (\(httpResponse.statusCode)): \(responseString)")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        // Try to decode with different possible response formats
        do {
            let tokenResponse = try JSONDecoder().decode(HeyGenResponse<TokenResponse>.self, from: data)
            return tokenResponse.data.token
        } catch {
            print("🔄 Trying direct TokenResponse decode...")
            // Try direct decode in case the response isn't wrapped
            let directResponse = try JSONDecoder().decode(TokenResponse.self, from: data)
            return directResponse.token
        }
    }
    
    /// Step 2: Create new session
    private func createNewSession(token: String) async throws -> SessionInfo {
        let url = URL(string: "\(ApiConfig.baseURL)\(ApiConfig.newSessionEndpoint)")!
        
        let payload: [String: Any] = [
            "quality": ApiConfig.quality,
            "avatar_name": ApiConfig.avatarId,
            "version": "v2",
            "video_encoding": "H264",
            "stt_settings": [
                "provider": "deepgram",  // High-quality STT provider
                "confidence": 0.55       // Confidence threshold for speech recognition
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        // Debug: Print response for troubleshooting
        if let responseString = String(data: data, encoding: .utf8) {
            print("🔍 Session API Response (\(httpResponse.statusCode)): \(responseString)")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        // Try to decode with different possible response formats
        do {
            let sessionResponse = try JSONDecoder().decode(HeyGenResponse<SessionInfo>.self, from: data)
            return sessionResponse.data
        } catch {
            print("🔄 Trying direct SessionInfo decode...")
            // Try direct decode in case the response isn't wrapped
            let directResponse = try JSONDecoder().decode(SessionInfo.self, from: data)
            return directResponse
        }
    }
    
    /// Step 3: Start streaming session
    private func startStreamingSession(sessionId: String) async throws {
        let url = URL(string: "\(ApiConfig.baseURL)\(ApiConfig.startSessionEndpoint)")!
        
        let payload: [String: Any] = [
            "session_id": sessionId
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(sessionToken!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
    }
    
    /// Send task to avatar
    private func sendStreamingTask(sessionId: String, token: String, text: String, taskType: String) async throws {
        let url = URL(string: "\(ApiConfig.baseURL)\(ApiConfig.sendTaskEndpoint)")!
        
        let payload: [String: Any] = [
            "session_id": sessionId,
            "text": text,
            "task_type": taskType
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.networkError("Failed to send task")
        }
    }
    
    /// Stop streaming session
    private func stopStreamingSession(sessionId: String) async throws {
        let url = URL(string: "\(ApiConfig.baseURL)\(ApiConfig.stopSessionEndpoint)")!
        
        let payload: [String: Any] = [
            "session_id": sessionId
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(sessionToken!)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONSerialization.data(withJSONObject: payload)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.networkError("Failed to stop session")
        }
    }
    
    // MARK: - WebSocket Integration (Real-time Events)
    
    /// Connect WebSocket for real-time avatar events
    private func connectWebSocket(sessionInfo: SessionInfo, token: String) async {
        guard let sessionToken = sessionToken else { return }
        
        let params = [
            "session_id": sessionInfo.sessionId,
            "session_token": sessionToken,
            "silence_response": "false",
            "opening_text": "Hello! I'm Nuro, your AI recovery coach. How can I support you today?",
            "stt_language": "en",
            "enable_stt": "true",
            "enable_voice_activity": "true"
        ]
        
        let queryString = params.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        let wsURLString = "wss://api.heygen.com/v1/ws/streaming.chat?\(queryString)"
        
        guard let wsURL = URL(string: wsURLString) else { return }
        
        let urlSession = URLSession(configuration: .default)
        webSocket = urlSession.webSocketTask(with: wsURL)
        
        webSocket?.resume()
        
        // Start listening for messages
        listenForWebSocketMessages()
        
        print("🔌 WebSocket connected")
    }
    
    /// Listen for WebSocket messages
    private func listenForWebSocketMessages() {
        webSocket?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self?.handleWebSocketMessage(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self?.handleWebSocketMessage(text)
                    }
                @unknown default:
                    break
                }
                
                // Continue listening
                self?.listenForWebSocketMessages()
                
            case .failure(let error):
                print("❌ WebSocket error: \(error)")
            }
        }
    }
    
    /// Handle WebSocket events
    private func handleWebSocketMessage(_ message: String) {
        guard let data = message.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        
        if let eventType = json["type"] as? String {
            DispatchQueue.main.async {
                switch eventType {
                case "avatar_start_talking":
                    self.isAvatarSpeaking = true
                    print("🗣️ Avatar started talking")
                case "avatar_stop_talking":
                    self.isAvatarSpeaking = false
                    print("🤐 Avatar stopped talking")
                case "stream_ready":
                    self.connectionStatus = .connected
                    print("📺 Stream ready - STT enabled")
                case "user_start":
                    print("👤 User started speaking (detected by HeyGen STT)")
                case "user_stop":
                    print("👤 User stopped speaking (detected by HeyGen STT)")
                case "user_message":
                    // Handle transcribed user speech from HeyGen's STT
                    if let userText = json["message"] as? String {
                        print("🎤 User said: \(userText)")
                        self.lastMessage = userText
                    }
                case "stt_result":
                    // Handle real-time STT transcription
                    if let transcript = json["text"] as? String,
                       let isFinal = json["is_final"] as? Bool {
                        print("📝 STT: \(transcript) (final: \(isFinal))")
                        if isFinal {
                            self.lastMessage = transcript
                        }
                    }
                case "error":
                    if let errorMsg = json["message"] as? String {
                        self.connectionStatus = .error("WebSocket error: \(errorMsg)")
                        print("❌ WebSocket error: \(errorMsg)")
                    }
                default:
                    print("📨 WebSocket event: \(eventType)")
                    if let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        print("📄 Full message: \(jsonString)")
                    }
                }
            }
        }
    }
    
    // MARK: - LiveKit Integration (Placeholder)
    
    /// Initialize LiveKit connection for video streaming
    private func initializeLiveKit(sessionInfo: SessionInfo) async {
        #if canImport(LiveKit)
        // Configure room with settings from documentation
        let roomOptions = RoomOptions(
            adaptiveStream: true,
            dynacast: true
        )
        
        let room = Room(roomOptions: roomOptions)
        
        // Set up room delegate to handle events
        room.add(delegate: self)
        
        do {
            // Connect to LiveKit room (prepareConnection not needed in this SDK version)
            try await room.connect(
                url: sessionInfo.url,
                token: sessionInfo.accessToken
            )
            
            await MainActor.run {
                self.room = room
            }
            
            print("🎥 LiveKit connected successfully")
            print("📍 Room URL: \(sessionInfo.url)")
            print("🔑 Access Token: \(sessionInfo.accessToken.prefix(20))...")
            
        } catch {
            await MainActor.run {
                connectionStatus = .error("LiveKit connection failed: \(error.localizedDescription)")
            }
            print("❌ LiveKit connection failed: \(error)")
        }
        #else
        // LiveKit not available - using placeholder
        let roomOptions = RoomOptions(
            adaptiveStream: true,
            dynacast: true
        )
        
        let room = Room()
        
        await MainActor.run {
            self.room = room
        }
        
        print("🎥 LiveKit placeholder initialized (LiveKit not available)")
        print("📍 Room URL: \(sessionInfo.url)")
        print("🔑 Access Token: \(sessionInfo.accessToken.prefix(20))...")
        #endif
    }
    
    // MARK: - Cleanup
    
    private func cleanupSession() async {
        // Close WebSocket
        webSocket?.cancel(with: .normalClosure, reason: nil)
        webSocket = nil
        
        // Disconnect LiveKit room
        await room?.disconnect()
        room = nil
        remoteVideoTrack = nil
        
        await MainActor.run {
            isSessionActive = false
            sessionToken = nil
            sessionInfo = nil
            connectionStatus = .disconnected
            isAvatarSpeaking = false
            lastMessage = ""
        }
        
        print("🧹 Session cleaned up")
    }
}

// MARK: - Error Types
enum APIError: LocalizedError {
    case invalidResponse
    case networkError(String)
    case configurationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid response from server"
        case .networkError(let message):
            return "Network error: \(message)"
        case .configurationError(let message):
            return "Configuration error: \(message)"
        }
    }
} 