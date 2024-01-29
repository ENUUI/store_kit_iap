import Foundation

typealias SKITransactionsResult = Swift.Result<D.TransactionList, SKIError>
typealias SKITransactionResult = Swift.Result<D.Transaction, SKIError>

protocol ToMap {
    func toMap() -> [String: Any?]
}

enum D {
    typealias TransactionList = [D.Transaction]

    struct Transaction {
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
}

extension D.Transaction: ToMap {
    func toMap() -> [String: Any?] {
        ["id": id, "original_id": originalID, "product_id": productId, "state": state.rawValue, "message": message, "details": details, "env": env]
    }
}

/// 通过channel返回给flutter端的结果
struct R<T> {
    let requestId: String
    let data: T?
    let error: SKIError?
}

extension R: ToMap {
    func toMap() -> [String: Any?] {
        let dataToMap: Any? = if data is ToMap {
            (data as! ToMap).toMap()
        } else if data is D.TransactionList {
            (data as! D.TransactionList).map { $0.toMap() }
        } else {
            data
        }

        return ["request_id": requestId, "error": error?.toMap(), "data": dataToMap]
    }
}

extension SKITransactionsResult {
    func toR(requestId: String) -> R<D.TransactionList> {
        switch self {
        case let .success(transactions):
            R(requestId: requestId, data: transactions, error: nil)
        case let .failure(error):
            R(requestId: requestId, data: nil, error: error)
        }
    }
}

extension SKITransactionResult {
    func toR(requestId: String) -> R<D.Transaction> {
        switch self {
        case let .success(transaction):
            R(requestId: requestId, data: transaction, error: nil)
        case let .failure(error):
            R(requestId: requestId, data: nil, error: error)
        }
    }
}

extension Swift.Result<Bool, SKIError> {
    func toR(requestId: String) -> R<Bool> {
        switch self {
        case let .success(enable):
            R(requestId: requestId, data: enable, error: nil)
        case let .failure(error):
            R(requestId: requestId, data: nil, error: error)
        }
    }
}

extension Swift.Result<Any, SKIError> {
    func toR(requestId: String) -> R<Any> {
        switch self {
        case let .success(product):
            R(requestId: requestId, data: product, error: nil)
        case let .failure(error):
            R(requestId: requestId, data: nil, error: error)
        }
    }
}
