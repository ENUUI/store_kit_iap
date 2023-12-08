import Foundation
import StoreKit

/// 交易
struct SKITransaction {
    init() {}

    enum Result {
        /// 完成
        case verified(UInt64)
        /// 失败
        ///  - 获取商品失败
        ///  - 拉起支付失败
        ///  - 支付失败
        case unverified(Error)
        /// 用户取消了
        case cancelled
        /// 待处理
        case pending
        case unknown
    }
}

extension SKITransaction {
    /// 支付商品
    func purchase(_ p: Opt.Purchase, result: @escaping (Result) -> Void) {
        Task {
            do {
                try await result(purchase(p))
            } catch {
                result(.unverified(error))
            }
        }
    }

    /// 未处理的交易
    func unfinished(result: @escaping ([Result]) -> Void) {
        Task {
            await result(unfinished())
        }
    }

    /// 当前的权益序列
    func current(result: @escaping ([Result]) -> Void) {
        Task {
            await result(current())
        }
    }

    /// 当前的权益序列
    func updates(result: @escaping ([Result]) -> Void) {
        Task {
            await result(updates())
        }
    }

    /// 所有交易
    func all(result: @escaping ([Result]) -> Void) {
        Task {
            await result(all())
        }
    }
}

extension SKITransaction {
    /// 支付商品
    func purchase(_ p: Opt.Purchase) async throws -> SKITransaction.Result {
        let product = try await product(p.productId)

        let result = try await product.purchase(options: p.option())

        return purchaseResult(result)
    }
}

extension SKITransaction {
    /// 交易历史记录包括应用程序尚未通过调用finish()完成的可消耗应用内购买。
    /// 它不包括已完成的可消耗产品或已完成的非续订订阅，重新购买的非消耗性产品或订阅，或已恢复的购买。
    func all() async -> [SKITransaction.Result] {
        await iterator(Transaction.all)
    }

    /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
    func unfinished() async -> [SKITransaction.Result] {
        await iterator(Transaction.unfinished)
    }

    /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
    /// - 每个非消耗性应用内购买的交易
    /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
    /// - 每个非续订订阅的最新交易，包括已完成的订阅
    /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
    /// [Important] 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
    func current() async -> [SKITransaction.Result] {
        await iterator(Transaction.currentEntitlements)
    }

    /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
    /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
    func updates() async -> [SKITransaction.Result] {
        await iterator(Transaction.updates)
    }
}

private extension SKITransaction {
    func iterator(_ transactions: Transaction.Transactions) async -> [SKITransaction.Result] {
        var results: [SKITransaction.Result] = []
        for await result in transactions {
            results.append(verificationResult(result))
        }

        return results
    }
}

private extension SKITransaction {
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

private extension SKITransaction {
    /// 处理支付结果
    func purchaseResult(_ result: Product.PurchaseResult) -> SKITransaction.Result {
        switch result {
        case let .success(verification):
            return verificationResult(verification)
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
    func verificationResult(_ result: VerificationResult<Transaction>) -> SKITransaction.Result {
        switch result {
        case let .unverified(_, error):
            // TODO: 如何处理 unverified 时的 transaction
            .unverified(error)
        case let .verified(transaction):
            .verified(transaction.id)
        }
    }
}

private extension Opt.Purchase {
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
extension SKITransaction.Result {
    var state: String {
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
        ["state": state, "message": message, "description": description, "transaction_id": transactionId]
    }
}
