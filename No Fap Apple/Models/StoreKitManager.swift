import StoreKit
import SwiftUI

@MainActor
class StoreKitManager: ObservableObject {
    static let shared = StoreKitManager()
    
    @Published var products: [Product] = []
    @Published var purchasedSubscriptions: [Product] = []
    @Published var subscriptionGroupStatus: Product.SubscriptionInfo.RenewalState?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var purchaseState: PurchaseState = .idle
    
    enum PurchaseState {
        case idle
        case purchasing
        case purchased
        case failed
    }
    
    private let productIDs = [
        "nofap_premium_yearly"
    ]
    
    private var updates: Task<Void, Never>? = nil
    
    private init() {
        updates = observeTransactionUpdates()
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: productIDs)
            products = storeProducts.sorted { product1, product2 in
                // Sort so yearly comes first (higher value)
                return product1.price > product2.price
            }
            await updateSubscriptionStatus()
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
            print("Failed to load products: \(error)")
        }
        isLoading = false
    }
    
    func purchase(_ product: Product) async {
        isLoading = true
        purchaseState = .purchasing
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                let transaction = try checkVerified(verification)
                await updateSubscriptionStatus()
                await transaction.finish()
                purchaseState = .purchased
                
            case .userCancelled:
                print("User cancelled purchase")
                purchaseState = .failed
                
            case .pending:
                print("Purchase is pending")
                purchaseState = .idle
                
            @unknown default:
                print("Unknown purchase result")
                purchaseState = .failed
            }
        } catch {
            errorMessage = "Purchase failed: \(error.localizedDescription)"
            print("Purchase failed: \(error)")
            purchaseState = .failed
        }
        isLoading = false
    }
    
    func restorePurchases() async {
        isLoading = true
        try? await AppStore.sync()
        await updateSubscriptionStatus()
        isLoading = false
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) {
            for await result in Transaction.updates {
                do {
                    let transaction = try checkVerified(result)
                    await updateSubscriptionStatus()
                    await transaction.finish()
                } catch {
                    print("Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    private func updateSubscriptionStatus() async {
        var purchasedSubscriptions: [Product] = []
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if let subscription = products.first(where: { $0.id == transaction.productID }) {
                    purchasedSubscriptions.append(subscription)
                }
            } catch {
                print("Failed to verify transaction: \(error)")
            }
        }
        
        self.purchasedSubscriptions = purchasedSubscriptions
        
        // Check subscription group status
        if let subscription = purchasedSubscriptions.first {
            subscriptionGroupStatus = try? await subscription.subscription?.status.first?.state
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    var hasActiveSubscription: Bool {
        return !purchasedSubscriptions.isEmpty && 
               subscriptionGroupStatus == .subscribed
    }
    
    var yearlyProduct: Product? {
        return products.first { $0.id == "nofap_premium_yearly" }
    }
}

enum StoreError: Error {
    case failedVerification
}

extension StoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .failedVerification:
            return "Transaction verification failed"
        }
    }
} 