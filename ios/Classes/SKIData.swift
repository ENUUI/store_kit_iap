import Foundation

typealias SKITransactionsResult = Swift.Result<[TransactionData], SKIError>
typealias SKITransactionResult = Swift.Result<TransactionData, SKIError>

struct TransactionData {
    enum State: String {
        case verified
        /// 失败
        ///  - 获取商品失败
        ///  - 拉起支付失败
        ///  - 支付失败
        case unverified
    }

    let id: UInt64 // Transaction.Id
    let originalID: UInt64 // Transaction.originalID
    let productId: String
    let state: State // 状态
    let message: String // 错误信息
    let details: String // 错误信息详情
    let env: String // 订单生产当环境
}

extension TransactionData {
    func toMap() -> [String: Any?] {
        ["id": id, "original_id": originalID, "product_id": productId, "state": state.rawValue, "message": message, "details": details, "env": env]
    }
}

/// 通过channel返回给flutter端的结果
extension SKITransactionsResult {
    func toMap() -> [String: Any?] {
        switch self {
        case let .success(data):
            ["data": data.map { $0.toMap() }]
        case let .failure(error):
            ["error": error.toMap()]
        }
    }
}

extension SKITransactionResult {
    func toMap() -> [String: Any?] {
        switch self {
        case let .success(data):
            ["data": data.toMap()]
        case let .failure(error):
            ["error": error.toMap()]
        }
    }
}

extension Swift.Result<Bool, SKIError> {
    func toMap() -> [String: Any?] {
        switch self {
        case let .success(data):
            ["data": data]
        case let .failure(error):
            ["error": error.toMap()]
        }
    }
}

extension Swift.Result<Data, SKIError> {
    func toMap() -> [String: Any?] {
        switch self {
        case let .success(data):
            ["data": data]
        case let .failure(error):
            ["error": error.toMap()]
        }
    }
}
