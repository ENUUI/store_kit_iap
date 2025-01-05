import CryptoKit
import Dispatch
import Foundation
import StoreKit

private func runAsync<T>(
    _ work: @escaping () async throws -> T,
    back onMain: @MainActor @escaping (Result<T, SKIError>) -> Void
) {
    Task.detached {
        do {
            let result = try await work()
            await onMain(.success(result))
        } catch {
            await onMain(.failure(.other(error)))
        }
    }
}

/// 回调 update 结果
protocol SKIUpdatesDelegate {
    func onUpdate(transaction: SKITransactionResult)
}

/// interfaces
protocol SKITransaction {
    var updatesDelegate: SKIUpdatesDelegate? { set get }

    /// 获取vendor id
    func deviceVerificationID() -> String?
    /// 是否有资格获得推介促销优惠(新用户)
    func eligibleForIntroOffer(_ pid: String, result: @escaping (Swift.Result<Bool, SKIError>) -> Void)
    /// 是否有资格获得促销优惠(正在使用/使用过的用户), 购买提供优惠时，需要签名。
    func eligibleForPromotionOffer(_ pid: String, result: @escaping (Swift.Result<Bool, SKIError>) -> Void)
    /// 获取商品数据
    func getProduct(_ pid: String, result: @escaping (Swift.Result<Data, SKIError>) -> Void)
    /// 支付商品
    func purchase(_ p: PurchaseOpt, result: @escaping (SKITransactionResult) -> Void)
    /// 未处理的交易
    func unfinished(result: @escaping (SKITransactionsResult) -> Void)
    /// 当前的权益序列
    /// As mentioned before, this only works on release mode and doesn't work on debug mode without StoreKit Testing, that is without a Configuration.storekit.
    /// https://stackoverflow.com/questions/69768519/appstore-sync-not-restoring-purchases
    func current(result: @escaping (SKITransactionsResult) -> Void)
    /// 获取有更新的交易
    func updates()

    func cancelUpdates()

    /// 所有交易
    func all(result: @escaping (SKITransactionsResult) -> Void)

    /// 结束交易
    func finish(_ id: UInt64) -> Bool
}

/// 交易
final class SKITransactionImpl: SKITransaction {
    init() {}

    private var transactionCaches: [UInt64: Transaction] = [:]
    private var semaphore = DispatchSemaphore(value: 1)

    fileprivate lazy var updatesOb = SKITransactionImpl.UpdatesObserver {
        self.updatesDelegate?.onUpdate(transaction: .success(self.verificationResult($0)))
    }

    var updatesDelegate: SKIUpdatesDelegate?
}

// Updates
extension SKITransactionImpl {
    fileprivate final class UpdatesObserver {
        /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
        /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
        var updatesTask: Task<Void, Never>?
        var resultCallback: @MainActor (VerificationResult<Transaction>) -> Void

        init(resultCallback: @MainActor @escaping (VerificationResult<Transaction>) -> Void) {
            self.resultCallback = resultCallback
        }

        deinit {
            updatesTask?.cancel()
        }

        func start() {
            guard updatesTask == nil || updatesTask?.isCancelled == true else {
                return
            }

            updatesTask = newTransactionListenerTask()
        }

        func cancel() {
            updatesTask?.cancel()
            updatesTask = nil
        }

        private func newTransactionListenerTask() -> Task<Void, Never> {
            Task(priority: .background) {
                for await result in Transaction.updates {
                    await self.resultCallback(result)
                }
            }
        }
    }

    /// 当前的权益序列
    func updates() {
        updatesOb.start()
    }

    func cancelUpdates() {
        updatesOb.cancel()
    }
}

extension SKITransactionImpl {
    /// 获取vendor id
    func deviceVerificationID() -> String? {
        AppStore.deviceVerificationID?.uuidString
    }

    /// 是否有资格获得推介促销优惠(新用户)
    func eligibleForIntroOffer(_ pid: String, result: @escaping (Swift.Result<Bool, SKIError>) -> Void) {
        runAsync({ try await self.eligibleForIntroOffer(pid) }, back: result)
    }

    /// 是否有资格获得促销优惠(正在使用/使用过的用户), 购买提供优惠时，需要签名。
    func eligibleForPromotionOffer(_ pid: String, result: @escaping (Result<Bool, SKIError>) -> Void) {
        runAsync({ try await self.eligibleForPromotionOffer(pid) }, back: result)
    }

    /// 获取商品数据
    func getProduct(_ pid: String, result: @escaping (Swift.Result<Data, SKIError>) -> Void) {
        runAsync({
            let product = try await self.product(pid)
            return product.jsonRepresentation
        }, back: result)
    }

    /// 支付商品
    func purchase(_ p: PurchaseOpt, result: @escaping (SKITransactionResult) -> Void) {
        runAsync({ try await self.purchase(p) }, back: result)
    }

    /// 未处理的交易
    func unfinished(result: @escaping (SKITransactionsResult) -> Void) {
        runAsync({ await self.unfinished() }, back: result)
    }

    /// 当前的权益序列
    /// As mentioned before, this only works on release mode and doesn't work on debug mode without StoreKit Testing, that is without a Configuration.storekit.
    /// https://stackoverflow.com/questions/69768519/appstore-sync-not-restoring-purchases
    func current(result: @escaping (SKITransactionsResult) -> Void) {
        runAsync({
            try await AppStore.sync()
            return await self.current()
        }, back: result)
    }

    /// 所有交易
    func all(result: @escaping (SKITransactionsResult) -> Void) {
        runAsync({ await self.all() }, back: result)
    }
}

extension SKITransactionImpl {
    /// 支付商品
    func purchase(_ p: PurchaseOpt) async throws -> TransactionData {
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
    func all() async -> [TransactionData] {
        await iterator(Transaction.all)
    }

    /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
    func unfinished() async -> [TransactionData] {
        await iterator(Transaction.unfinished)
    }

    /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
    /// - 每个非消耗性应用内购买的交易
    /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
    /// - 每个非续订订阅的最新交易，包括已完成的订阅
    /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
    /// [Important] 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
    func current() async -> [TransactionData] {
        await iterator(Transaction.currentEntitlements)
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

    func iterator(_ transactions: Transaction.Transactions) async -> [TransactionData] {
        var results: [TransactionData] = []
        for await result in transactions {
            results.append(verificationResult(result))
        }

        return results
    }
}

private extension SKITransactionImpl {
    /// 是否有资格获得推介促销优惠(新用户).
    func eligibleForIntroOffer(_ productId: String) async throws -> Bool {
        let product = try await product(productId)
        guard let subscription = product.subscription else {
            throw SKIError.arguments("商品不是订阅类型")
        }
        return await subscription.isEligibleForIntroOffer
    }

    /// 是否有资格获得促销优惠(正在使用/使用过的用户), 购买提供优惠时，需要签名。
    func eligibleForPromotionOffer(_ productId: String) async throws -> Bool {
        let product = try await product(productId)
        guard let subscription = product.subscription else {
            throw SKIError.arguments("商品不是订阅类型")
        }

        let statuses = try await subscription.status
        if statuses.isEmpty {
            return false
        }

        // [product.isFamilyShareable == true] 可能由多个
        // TODO: 如何处理家庭分享
        let status = statuses[0]

        return status.state == .expired
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
    func purchaseResult(_ result: Product.PurchaseResult) throws -> TransactionData {
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
    func verificationResult(_ result: VerificationResult<Transaction>) -> TransactionData {
        switch result {
        case let .unverified(transaction, error):
            // TODO: 如何处理 unverified 时的 transaction
            return transaction.toDTransaction(.unverified, message: error.localizedDescription, details: error.localizedDescription)
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

private extension PurchaseOpt {
    /// 将 flutter 端传入的参数convert to [Product.PurchaseOption]
    func option() -> Set<Product.PurchaseOption> {
        var options: Set<Product.PurchaseOption> = []

        if let uuidString = uuid, let uuid = UUID(uuidString: uuidString) {
            options.insert(.appAccountToken(uuid))
        }

        if let quantity {
            options.insert(.quantity(quantity))
        }

        if let promotion {
            options.insert(.promotionalOffer(offerID: promotion.offerId, keyID: promotion.keyID, nonce: promotion.nonce, signature: promotion.signature, timestamp: promotion.timestamp))
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

    func toDTransaction(_ state: TransactionData.State, message: String = "", details: String = "") -> TransactionData {
        TransactionData(id: id, originalID: originalID, productId: productID, state: state, message: message, details: details, env: envString())
    }
}
