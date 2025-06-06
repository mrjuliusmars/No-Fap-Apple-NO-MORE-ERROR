import Foundation

// MARK: - API Configuration (following official HeyGen demo structure)
struct ApiConfig {
    // Copy and paste your API Key to this line (from https://app.heygen.com/settings?nav=API)
    static let apiKey: String = "ZjFlMjgwNGQ3NTMxNDNjMTk2ZGJmY2FjN2JlZTFiYjItMTc0OTEyMzMxNw=="
    
    // Default settings - you can customize these
    static let quality = "high"
    static let voice = "1bd001e7-e5f2-4982-8bac-fb27b82c7421" // Default English voice that works with streaming
    static let avatarId = "Pedro_CasualLook_public" // Real HeyGen public avatar
    
    // Alternative public avatars (for backup):
    static let backupAvatars = [
        "Pedro_CasualLook_public",
        "Anna_public_3_20240108",
        "Tyler-insuit-20220721", 
        "josh_lite3_20230714",
        "Susan_public_2_20240328"
    ]
    
    // API Endpoints (following official documentation)
    static let baseURL = "https://api.heygen.com"
    static let createTokenEndpoint = "/v1/streaming.create_token"
    static let newSessionEndpoint = "/v1/streaming.new"
    static let startSessionEndpoint = "/v1/streaming.start"
    static let submitICEEndpoint = "/v1/streaming.ice"
    static let sendTaskEndpoint = "/v1/streaming.task"
    static let stopSessionEndpoint = "/v1/streaming.stop"
    
    // Validation
    static var isValid: Bool {
        return !apiKey.contains("YOUR_API_KEY") && apiKey.count > 10
    }
}

// MARK: - Configuration Error Messages
extension ApiConfig {
    static var configurationError: String? {
        if apiKey.contains("YOUR_API_KEY") || apiKey.isEmpty {
            return "Please configure your HeyGen API key in ApiConfig.swift"
        }
        return nil
    }
} 