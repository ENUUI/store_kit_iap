import Foundation

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
            /// 用户取消了
            case cancelled
            /// 待处理
            case pending
            case unknown
        }

        let id: UInt64 // Transaction.Id, 当 verified 或者 unverified 时有效
        let originalID: UInt64 // Transaction.originalID, 当 verified 或者 unverified 时有效
        let state: State // 状态
        let message: String // 错误信息
        let details: String // 错误信息详情
        let env: String // 订单生产当环境, 当 verified 或者 unverified 时有效

        init(id: UInt64 = 0, originalID: UInt64 = 0, state: State, message: String, details: String = "", env: String = "") {
            self.id = id
            self.originalID = originalID
            self.state = state
            self.message = message
            self.details = details
            self.env = env
        }
    }
}

extension D.Transaction: ToMap {
    func toMap() -> [String: Any?] {
        ["state": state, "message": message, "details": details, "id": id, "original_id": originalID, "env": env]
    }
}

/// 通过channel返回给flutter端的结果
struct R<T> {
    struct Err {
        let message: String
        let details: String
    }

    let requestId: String
    let data: T?
    let error: Err?
}

extension R.Err: ToMap {
    func toMap() -> [String: Any?] {
        ["message": message, "details": details]
    }
}

extension R: ToMap {
    func toMap() -> [String: Any?] {
        let dataToMap: Any? = if data is ToMap {
            (data as! ToMap).toMap()
        } else {
            data
        }

        return ["request_id": requestId, "error": error?.toMap(), "data": dataToMap]
    }
}
