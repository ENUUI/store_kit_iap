import Foundation
import StoreKit

/// code  > 4100 支付错误
/// code  = 499 用户取消
enum SKIError: Error {
    case arguments(String)
    case pending
    case cancelled(String)
    case other(Error)
    case unknown

    struct SKIErrorContent {
        let code: Int
        let message: String
        let details: String

        init(code: Int, message: String, details: String = "") {
            self.code = code
            self.message = message
            self.details = details
        }
    }
}

extension SKIError {
    func toContent() -> SKIErrorContent {
        switch self {
        case let .arguments(message):
            SKIErrorContent(code: 400, message: "参数错误", details: message)
        case .pending:
            SKIErrorContent(code: 102, message: "等待处理")
        case let .cancelled(message):
            SKIErrorContent(code: 499, message: message)
        case let .other(error):
            errorToInfo(error)
        case .unknown:
            SKIErrorContent(code: 500, message: "未知错误")
        }
    }

    private func errorToInfo(_ e: Error) -> SKIErrorContent {
        if let skiError = e as? SKIError {
            return skiError.toContent()
        }

        var code = 400
        var message = "未知错误"
        var details: String = e.localizedDescription

        if let skError = e as? StoreKitError {
            switch skError {
            case .unknown:
                message = "未知错误"
                code = 500
            case .userCancelled:
                code = 499
                message = "用户取消"
            case let .networkError(err):
                message = "网络错误"
                details = err.localizedDescription
                code = 502
            case let .systemError(err):
                message = "系统错误"
                details = err.localizedDescription
                code = 500
            case .notAvailableInStorefront:
                message = "该产品在当前商店不可用"
            case .notEntitled:
                message = "无权限"
                code = 403
            @unknown default:
                message = "未知错误"
                code = 500
            }
        } else if let pError = e as? Product.PurchaseError {
            code = 4100
            switch pError {
            case .invalidQuantity:
                code += 1
                message = "购买数量错误"
            case .productUnavailable:
                code += 2
                message = "商品不可用"
            case .purchaseNotAllowed:
                code += 3
                message = "购买被拒绝"
            case .ineligibleForOffer:
                code += 4
                message = "不能享受优惠"
            case .invalidOfferIdentifier:
                code += 5
                message = "标识符无效"
            case .invalidOfferPrice:
                code += 6
                message = "价格无效"
            case .invalidOfferSignature:
                code += 7
                message = "签名无效"
            case .missingOfferParameters:
                code += 8
                message = "参数错误"
            @unknown default:
                message = "未知错误"
            }
        }

        return SKIErrorContent(code: code, message: message, details: details)
    }
}

extension SKIError.SKIErrorContent: ToMap {
    func toMap() -> [String: Any?] {
        ["code": code, "message": message, "details": details]
    }
}
