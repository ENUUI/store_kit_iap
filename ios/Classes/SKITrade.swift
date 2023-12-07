import Foundation
import StoreKit

class Trader {
    enum Result {
        case verified(UInt64)
        case unverified(Error)
        case `cancelled`
        case pending
        case `unknown`
    }
}

private class SKITransaction {
    func purchase(_ purchase: Opt.Purchase) async throws -> Trader.Result {
        let product = try await product(purchase.productId)
        
        let result = try await product.purchase(options: purchase.option())
        
        switch result {
        case let .success(verification):
            return try verificationResult(verification)
        case .userCancelled:
            print("StoreKitIap purchase result: userCancelled")
            return .cancelled
        case .pending:
            print("StoreKitIap purchase result: pending")
            return .pending
        @unknown default:
            print("StoreKitIap purchase result: unknown")
            return .unknown
        }
    }
    
    func product(_ productId: String) async throws -> Product {
        let products = try await Product.products(for: [productId])
        guard !products.isEmpty else {
            throw SKError(.invalidOfferIdentifier)
        }
        
        guard let product = products.first(where: { productId == $0.id }) else {
            throw SKIError.arguments("未能找到商品")
        }
        return product
    }
}

extension SKITransaction {
    func verificationResult(_ result: VerificationResult<Transaction>) throws -> Trader.Result {
        switch result {
        case let .unverified(_, error):
            // TODO: 如何处理 unverified 时的 transaction
            return .unverified(error)
        case let .verified(transaction):
            return .verified(transaction.id)
        }
    }
}

extension Opt.Purchase {
    func option() -> Set<Product.PurchaseOption> {
        var options: Set<Product.PurchaseOption> = []
        
        if let uuidString = uuid, let uuid = UUID(uuidString: uuidString) {
            options.insert(.appAccountToken(uuid))
        }
        
        if let quantity = quantity {
            options.insert(.quantity(quantity))
        }
        
        if let extra = extra, !extra.isEmpty  {
            for (k, v) in extra {
                options.insert(.custom(key: k, value: v))
            }
        }
        
        return options
    }
}

extension Trader.Result {
    var name: String {
        switch self {
        case .verified(_):
            return "verified"
        case .unverified(_):
            return "unverified"
        case .`cancelled`:
            return "cancelled"
        case .pending:
            return "pending"
        case .`unknown`:
            return "unknown"
        }
    }
    
    var transactionId: UInt64 {
        if case .verified(let id) = self {
            return id
        }
        return 0
    }
}
