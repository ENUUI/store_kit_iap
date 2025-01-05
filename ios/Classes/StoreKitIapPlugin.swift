import Flutter
import UIKit

public class StoreKitIapPlugin: NSObject, FlutterPlugin {
    lazy var transaction: SKITransaction = SKITransactionImpl()
    var flutterApi: StoreKitFlutterApi

    init(flutterApi: StoreKitFlutterApi) {
        self.flutterApi = flutterApi
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let flutterApi = StoreKitFlutterApi(binaryMessenger: registrar.messenger())
        let instance = StoreKitIapPlugin(flutterApi: flutterApi)

        StoreKitIosApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)
    }
}

extension StoreKitIapPlugin: StoreKitIosApi {
    func eligibleForIntroOffer(productId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard !productId.isEmpty else {
            completion(.failure(PigeonError(code: "400", message: "参数不能为空", details: nil)))
            return
        }
        transaction.eligibleForIntroOffer(productId) {
            self.flutterApi.onIntroOffer(data: $0.toMap()) { debugPrint($0) }
        }
    }

    func eligibleForPromotionOffer(productId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard !productId.isEmpty else {
            completion(.failure(PigeonError(code: "400", message: "参数不能为空", details: nil)))
            return
        }

        transaction.eligibleForPromotionOffer(productId) {
            self.flutterApi.onIntroPromotion(data: $0.toMap()) { debugPrint($0) }
        }
    }

    func getProduct(productId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard !productId.isEmpty else {
            completion(.failure(PigeonError(code: "400", message: "参数不能为空", details: nil)))
            return
        }
        transaction.getProduct(productId) {
            self.flutterApi.onProduct(data: $0.toMap()) { debugPrint($0) }
        }
    }

    func finish(transactionId: Int64, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard transactionId > 0 else {
            completion(.failure(PigeonError(code: "400", message: "参数错误", details: "transactionId: \(transactionId) 必须大于 0")))
            return
        }
        if transaction.finish(UInt64(transactionId)) {
            completion(.success(()))
        } else {
            completion(.failure(PigeonError(code: "404", message: "未找到交易", details: "调用 [current]/[unfinished]/[all] 等方法确认交易是否存在")))
        }
    }

    func vendorId(completion: @escaping (Result<String, any Error>) -> Void) {
        completion(.success(transaction.deviceVerificationID() ?? ""))
    }

    func purchase(arguments: [String: Any?], completion: @escaping (Result<Void, any Error>) -> Void) {
        do {
            try transaction.purchase(PurchaseOpt(arguments)) {
                self.flutterApi.onPurchased(data: $0.toMap()) { debugPrint($0) }
            }
        } catch let err as SKIError {
            completion(.failure(err.toPigeon()))
        } catch {
            completion(.failure(PigeonError(code: "500", message: "未知错误", details: error.localizedDescription)))
        }
    }

    func updates(completion: @escaping (Result<Void, any Error>) -> Void) {
        transaction.updatesDelegate = self
        transaction.updates()

        completion(.success(()))
    }

    func cancelUpdates(completion: @escaping (Result<Void, any Error>) -> Void) {
        transaction.updatesDelegate = nil
        transaction.cancelUpdates()
        completion(.success(()))
    }

    func current(completion: @escaping (Result<Void, any Error>) -> Void) {
        transaction.current {
            self.flutterApi.onCurrent(data: $0.toMap()) { debugPrint($0) }
        }
        completion(.success(()))
    }

    func unfinished(completion: @escaping (Result<Void, any Error>) -> Void) {
        transaction.unfinished {
            self.flutterApi.onUnfinished(data: $0.toMap()) { debugPrint($0) }
        }
        completion(.success(()))
    }

    func all(completion: @escaping (Result<Void, any Error>) -> Void) {
        transaction.all {
            self.flutterApi.onAll(data: $0.toMap()) { debugPrint($0) }
        }
        completion(.success(()))
    }
}

extension StoreKitIapPlugin: SKIUpdatesDelegate {
    func onUpdate(transaction: SKITransactionResult) {
        flutterApi.onUpdates(data: transaction.toMap()) { debugPrint($0) }
    }
}

private extension SKIError {
    func toPigeon() -> PigeonError {
        let content = toContent()
        return PigeonError(code: "\(content.code)", message: content.message, details: content.details)
    }
}
