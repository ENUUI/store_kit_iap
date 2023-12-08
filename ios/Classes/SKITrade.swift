import Foundation
import StoreKit

enum Trader {
    enum Result {
        case verified(UInt64)
        case unverified(Error)
        case cancelled
        case pending
        case unknown
    }
}

/// 交易
private class SKITransaction {
    /// 支付商品
    func purchase(_ purchase: Opt.Purchase) async throws -> Trader.Result {
        let product = try await product(purchase.productId)

        let result = try await product.purchase(options: purchase.option())

        return try purchaseResult(result)
    }
}

extension SKITransaction {
    /// 通过id获取商品
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
    /// 处理支付结果
    func purchaseResult(_ result: Product.PurchaseResult) throws -> Trader.Result {
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

    /// 处理交易结果
    func verificationResult(_ result: VerificationResult<Transaction>) throws -> Trader.Result {
        switch result {
        case let .unverified(_, error):
            // TODO: 如何处理 unverified 时的 transaction
            .unverified(error)
        case let .verified(transaction):
            .verified(transaction.id)
        }
    }
}

extension Opt.Purchase {
    /// 将 flutter 端传入的参数convert to [Product.PurchaseOption]
    func option() -> Set<Product.PurchaseOption> {
        var options: Set<Product.PurchaseOption> = []

        if let uuidString = uuid, let uuid = UUID(uuidString: uuidString) {
            options.insert(.appAccountToken(uuid))
        }

        if let quantity {
            options.insert(.quantity(quantity))
        }

        if let extra, !extra.isEmpty {
            for (k, v) in extra {
                options.insert(.custom(key: k, value: v))
            }
        }

        return options
    }
}

/// extension on [Trader.Result]
extension Trader.Result {
    /// Result名称, 代替code
    var name: String {
        switch self {
        case .verified:
            "verified"
        case .unverified:
            "unverified"
        case .cancelled:
            "cancelled"
        case .pending:
            "pending"
        case .unknown:
            "unknown"
        }
    }

    /// 当支付成功后，将 transaction.id 回调
    var transactionId: UInt64 {
        if case let .verified(id) = self {
            return id
        }
        return 0
    }

    /// 当前状态描述
    var message: String {
        switch self {
        case .verified:
            "支付成功"
        case .unverified:
            "支付失败"
        case .cancelled:
            "以取消"
        case .pending:
            "待处理"
        case .unknown:
            "未知错误"
        }
    }

    /// 支付失败描述
    var description: String {
        if case let .unverified(error) = self {
            return error.localizedDescription
        }
        return ""
    }

    /// 用于通过channel回调给flutter
    var json: [String: Any] {
        ["name": name, "message": message, "description": description, "transaction_id": transactionId]
    }
}
