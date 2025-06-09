import Foundation
import StoreKit

@MainActor
class SubscriptionManager: ObservableObject {
    @Published var isSubscribed: Bool = false
    @Published var isLoading: Bool = false
    @Published var subscriptionError: String?
    @Published var products: [Product] = []
    @Published var userCancelledPurchase: Bool = false
    
    // Product IDs - match exactly with StoreKit.storekit
    private let yearlyProductID = "nuro_yearly_29_99"
    private let discountProductID = "nuro_yearly_19_99"
    private let freeTrialProductID = "nuro_trial_19_99"
    
    // UserDefaults keys
    private let isSubscribedKey = "isSubscribed"
    private let subscriptionDateKey = "subscriptionDate"
    
    private var updateListenerTask: Task<Void, Error>? = nil
    
    init() {
        loadSubscriptionStatus()
        
        // Start listening for transaction updates
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    // MARK: - Product Loading
    
    func requestProducts() async {
        do {
            products = try await Product.products(for: [yearlyProductID, discountProductID, freeTrialProductID])
            print("✅ Loaded \(products.count) products")
        } catch {
            print("❌ Failed to load products: \(error)")
            subscriptionError = "Failed to load subscription options"
        }
    }
    
    var yearlyProduct: Product? {
        products.first { $0.id == yearlyProductID }
    }
    
    var discountProduct: Product? {
        products.first { $0.id == discountProductID }
    }
    
    var freeTrialProduct: Product? {
        products.first { $0.id == freeTrialProductID }
    }
    
    // MARK: - Purchase Flow
    
    func purchaseYearlySubscription() async {
        guard let product = yearlyProduct else {
            subscriptionError = "Subscription not available. Please try again."
            return
        }
        
        await purchaseProduct(product)
    }
    
    func purchaseDiscountSubscription() async {
        guard let product = discountProduct else {
            subscriptionError = "Discount offer not available. Please try again."
            return
        }
        
        await purchaseProduct(product)
    }
    
    func purchaseFreeTrialSubscription() async {
        guard let product = freeTrialProduct else {
            subscriptionError = "Free trial not available. Please try again."
            return
        }
        
        await purchaseProduct(product)
    }
    
    private func purchaseProduct(_ product: Product) async {
        isLoading = true
        subscriptionError = nil
        userCancelledPurchase = false // Reset cancellation flag at start
        
        do {
            print("🛒 Starting purchase for: \(product.displayName)")
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                print("✅ Purchase successful")
                
                switch verification {
                case .verified(let transaction):
                    print("✅ Transaction verified: \(transaction.id)")
                    
                    // Update subscription status
                    await updateCustomerProductStatus()
                    
                    // Finish the transaction
                    await transaction.finish()
                    
                    print("🎉 Subscription activated!")
                    
                case .unverified:
                    print("❌ Transaction unverified")
                    subscriptionError = "Purchase verification failed. Please contact support."
                }
                
            case .pending:
                print("⏳ Purchase pending")
                subscriptionError = "Your purchase is pending approval."
                
            case .userCancelled:
                print("❌ User cancelled purchase")
                print("❌ Setting userCancelledPurchase to true")
                userCancelledPurchase = true
                print("❌ userCancelledPurchase is now: \(userCancelledPurchase)")
                
            @unknown default:
                print("❌ Unknown purchase result")
                subscriptionError = "An unexpected error occurred. Please try again."
            }
            
        } catch VerificationError.failedVerification {
            subscriptionError = "Your purchase could not be verified. Please try again."
        } catch {
            print("❌ Purchase error: \(error)")
            print("❌ Error type: \(type(of: error))")
            print("❌ Error description: \(error.localizedDescription)")
            
            // Check if this is a user cancellation
            let errorDescription = error.localizedDescription.lowercased()
            if errorDescription.contains("cancelled") || errorDescription.contains("canceled") || errorDescription.contains("user") {
                print("❌ User cancelled via error description")
                userCancelledPurchase = true
            } else {
                subscriptionError = "Purchase failed: \(error.localizedDescription)"
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Restore Purchases
    
    func restorePurchases() async {
        isLoading = true
        subscriptionError = nil
        
        do {
            print("🔄 Syncing with App Store...")
            try await AppStore.sync()
            await updateCustomerProductStatus()
            
            if isSubscribed {
                print("✅ Subscription restored!")
            } else {
                subscriptionError = "No previous purchases found."
            }
            
        } catch {
            print("❌ Restore failed: \(error)")
            subscriptionError = "Failed to restore purchases: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Subscription Status Management
    
    func updateCustomerProductStatus() async {
        var hasActiveSubscription = false
        
        // Check for valid transactions
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                if transaction.productID == yearlyProductID || transaction.productID == discountProductID || transaction.productID == freeTrialProductID {
                    hasActiveSubscription = true
                    print("✅ Active subscription found: \(transaction.id)")
                    break
                }
            } catch {
                print("❌ Transaction verification failed: \(error)")
            }
        }
        
        await MainActor.run {
            self.setSubscriptionStatus(hasActiveSubscription)
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw VerificationError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func setSubscriptionStatus(_ status: Bool) {
        isSubscribed = status
        UserDefaults.standard.set(status, forKey: isSubscribedKey)
        
        if status {
            UserDefaults.standard.set(Date(), forKey: subscriptionDateKey)
        }
        
        print("📱 Subscription status updated: \(status)")
    }
    
    private func loadSubscriptionStatus() {
        isSubscribed = UserDefaults.standard.bool(forKey: isSubscribedKey)
        print("📱 Loaded subscription status: \(isSubscribed)")
    }
    
    // MARK: - Transaction Listener
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try await self.checkVerified(result)
                    
                    // Update subscription status
                    await self.updateCustomerProductStatus()
                    
                    // Finish the transaction
                    await transaction.finish()
                } catch {
                    print("❌ Transaction update failed: \(error)")
                }
            }
        }
    }
    
    // MARK: - Debug & Testing
    
    #if DEBUG
    func grantTestSubscription() {
        setSubscriptionStatus(true)
        print("🧪 Test subscription granted")
    }
    
    func revokeTestSubscription() {
        setSubscriptionStatus(false)
        print("🧪 Test subscription revoked")
    }
    #endif
    
    func resetSubscription() {
        setSubscriptionStatus(false)
        UserDefaults.standard.removeObject(forKey: subscriptionDateKey)
        print("🔄 Subscription reset")
    }
    
    func resetCancellationFlag() {
        userCancelledPurchase = false
        print("🔄 Cancellation flag reset")
    }
}

// Add custom error type for verification
enum VerificationError: Error {
    case failedVerification
} 