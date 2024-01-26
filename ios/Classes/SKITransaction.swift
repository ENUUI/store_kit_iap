import CryptoKit
import Dispatch
import Foundation
import StoreKit

protocol SKITransaction {
    /// 获取vendor id
    func deviceVerificationID() -> String?
    /// 是否有资格获得试用优惠
    func eligibleForIntroOffer(_ pid: String, result: @escaping (Swift.Result<Bool, SKIError>) -> Void)
    /// 获取商品数据
    func getProduct(_ pid: String, result: @escaping (Swift.Result<Any, SKIError>) -> Void)
    /// 支付商品
    func purchase(_ p: Opt.Purchase, result: @escaping (SKITransactionResult) -> Void)

    /// 未处理的交易
    func unfinished(result: @escaping (SKITransactionsResult) -> Void)
    /// 当前的权益序列
    /// As mentioned before, this only works on release mode and doesn't work on debug mode without StoreKit Testing, that is without a Configuration.storekit.
    /// https://stackoverflow.com/questions/69768519/appstore-sync-not-restoring-purchases
    func current(result: @escaping (SKITransactionsResult) -> Void)
    /// 获取有更新的交易
    func updates(result: @escaping (SKITransactionsResult) -> Void)
    /// 所有交易
    func all(result: @escaping (SKITransactionsResult) -> Void)

    /// 结束交易
    func finish(_ id: UInt64) -> Bool
}

/// 交易
class SKITransactionImpl: SKITransaction {
    init() {}

    private var transactionCaches: [UInt64: Transaction] = [:]
    private var semaphore = DispatchSemaphore(value: 1)
}

extension SKITransactionImpl {
    /// 获取vendor id
    func deviceVerificationID() -> String? {
        AppStore.deviceVerificationID?.uuidString
    }

    /// 是否有资格获得试用优惠
    func eligibleForIntroOffer(_ pid: String, result: @escaping (Swift.Result<Bool, SKIError>) -> Void) {
        Task.detached {
            do {
                let enable = try await self.eligibleForIntroOffer(pid)
                result(.success(enable))
            } catch {
                result(.failure(.other(error)))
            }
        }
    }

    /// 获取商品数据
    func getProduct(_ pid: String, result: @escaping (Swift.Result<Any, SKIError>) -> Void) {
        Task.detached {
            do {
                let product = try await self.product(pid)
                let jsonObj = try JSONSerialization.jsonObject(with: product.jsonRepresentation)
                result(.success(jsonObj))
            } catch {
                result(.failure(.other(error)))
            }
        }
    }

    /// 支付商品
    func purchase(_ p: Opt.Purchase, result: @escaping (SKITransactionResult) -> Void) {
        Task.detached {
            do {
                try await result(.success(self.purchase(p)))
            } catch {
                result(.failure(.other(error)))
            }
        }
    }

    /// 未处理的交易
    func unfinished(result: @escaping (SKITransactionsResult) -> Void) {
        Task.detached {
            await result(.success(self.unfinished()))
        }
    }

    /// 当前的权益序列
    /// As mentioned before, this only works on release mode and doesn't work on debug mode without StoreKit Testing, that is without a Configuration.storekit.
    /// https://stackoverflow.com/questions/69768519/appstore-sync-not-restoring-purchases
    func current(result: @escaping (SKITransactionsResult) -> Void) {
        Task.detached {
            do {
                try await AppStore.sync()
                await result(.success(self.current()))
            } catch {
                result(.failure(.other(error)))
            }
        }
    }

    /// 当前的权益序列
    func updates(result: @escaping (SKITransactionsResult) -> Void) {
        Task.detached {
            await result(.success(self.updates()))
        }
    }

    /// 所有交易
    func all(result: @escaping (SKITransactionsResult) -> Void) {
        Task.detached {
            await result(.success(self.all()))
        }
    }
}

extension SKITransactionImpl {
    /// 支付商品
    func purchase(_ p: Opt.Purchase) async throws -> D.Transaction {
        let product = try await product(p.productId)

        let result = try await product.purchase(options: p.option())

        return try purchaseResult(result)
    }
}

extension SKITransactionImpl {
    func finish(_ id: UInt64) -> Bool {
        guard let transaction = find(id) else {
            return false
        }
        Task {
            await transaction.finish()
        }
        return true
    }

    /// 交易历史记录包括应用程序尚未通过调用finish()完成的可消耗应用内购买。
    /// 它不包括已完成的可消耗产品或已完成的非续订订阅，重新购买的非消耗性产品或订阅，或已恢复的购买。
    func all() async -> D.TransactionList {
        await iterator(Transaction.all)
    }

    /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
    func unfinished() async -> D.TransactionList {
        await iterator(Transaction.unfinished)
    }

    /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
    /// - 每个非消耗性应用内购买的交易
    /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
    /// - 每个非续订订阅的最新交易，包括已完成的订阅
    /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
    /// [Important] 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
    func current() async -> D.TransactionList {
        await iterator(Transaction.currentEntitlements)
    }

    /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
    /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
    func updates() async -> D.TransactionList {
        await iterator(Transaction.updates)
    }
}

private extension SKITransactionImpl {
    func insert(_ transaction: Transaction) {
        semaphore.wait()
        defer { semaphore.signal() }

        transactionCaches[transaction.id] = transaction
    }

    func find(_ id: UInt64) -> Transaction? {
        semaphore.wait()
        defer { semaphore.signal() }

        return transactionCaches.removeValue(forKey: id)
    }

    func iterator(_ transactions: Transaction.Transactions) async -> [D.Transaction] {
        var results: D.TransactionList = []
        for await result in transactions {
            results.append(verificationResult(result))
        }

        return results
    }
}

private extension SKITransactionImpl {
    // 有资格获得试用优惠
    func eligibleForIntroOffer(_ productId: String) async throws -> Bool {
        let product = try await product(productId)
        guard let subscription = product.subscription else {
            throw SKIError.arguments("商品不是订阅类型")
        }
        return await subscription.isEligibleForIntroOffer
    }

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

private extension SKITransactionImpl {
    /// 处理支付结果
    func purchaseResult(_ result: Product.PurchaseResult) throws -> D.Transaction {
        switch result {
        case let .success(verification):
            return verificationResult(verification)
        case .userCancelled:
            throw SKIError.cancelled("用户取消")
        case .pending:
            throw SKIError.pending
        @unknown default:
            throw SKIError.unknown
        }
    }

    /// 处理交易结果
    func verificationResult(_ result: VerificationResult<Transaction>) -> D.Transaction {
        switch result {
        case let .unverified(transaction, error):
            // TODO: 如何处理 unverified 时的 transaction
            return transaction.toDTransaction(.unverified, message: "支付失败", details: error.localizedDescription)
        case let .verified(transaction):
            guard transactionOfDevice(transaction) else {
                return transaction.toDTransaction(.unverified, message: "交易不属于本设备")
            }
            insert(transaction)
            return transaction.toDTransaction(.verified)
        }
    }

    /// 验证交易是否属于设备的设备验证值
    // https://developer.apple.com/documentation/storekit/transaction/3749690-deviceverification/
    func transactionOfDevice(_ transaction: Transaction) -> Bool {
        guard let deviceVerificationUUID = AppStore.deviceVerificationID else { return false }

        // Assemble the values to hash.
        let deviceVerificationIDString = deviceVerificationUUID.uuidString.lowercased()
        let nonceString = transaction.deviceVerificationNonce.uuidString.lowercased()
        let hashTargetString = nonceString.appending(deviceVerificationIDString)

        // Compute the hash.
        let hashTargetData = Data(hashTargetString.utf8)
        let digest = SHA384.hash(data: hashTargetData)
        let digestData = Data(digest)

        return digestData == transaction.deviceVerification
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

extension StoreKit.Transaction {
    func envString() -> String {
        var env = ""
        if #available(iOS 16.0, *) {
            env = environment.rawValue.lowercased()
        } else {
            env = environmentStringRepresentation.lowercased()
        }

        return env
    }

    func toDTransaction(_ state: D.Transaction.State, message: String = "", details: String = "") -> D.Transaction {
        D.Transaction(id: id, originalID: originalID, productId: productID, state: state, message: message, details: details, env: envString())
    }
}
