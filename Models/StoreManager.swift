import Foundation
import StoreKit

@MainActor
class StoreManager: ObservableObject {
    @Published var isLoading = false
    @Published var yearlyProduct: Product?
    
    func purchase(_ product: Product) async {
        isLoading = true
        
        // Simulate purchase delay
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        isLoading = false
        
        // For demo purposes, we'll just complete the purchase
        // In a real app, you'd implement actual StoreKit logic here
    }
} 