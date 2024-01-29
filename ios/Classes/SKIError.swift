import Foundation
import StoreKit

enum SKIError: Error {
    case arguments(String)
    case pending
    case cancelled(String)
    case other(Error)
    case unknown
}

extension SKIError: ToMap {
    func toMap() -> [String: Any?] {
        switch self {
        case let .arguments(message):
            ["code": 400, "message": "参数错误", "details": message]
        case .pending:
            ["code": 102, "message": "等待处理"]
        case let .cancelled(message):
            ["code": 499, "message": message]
        case let .other(error):
            errorToInfo(error)
        case .unknown:
            ["code": 500, "message": "未知错误"]
        }
    }

    private func errorToInfo(_ e: Error) -> [String: Any?] {
        if let skiError = e as? SKIError {
            return skiError.toMap()
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
            code = 410
            switch pError {
            case .invalidQuantity:
                message = "购买数量错误"
            case .productUnavailable:
                message = "商品不可用"
            case .purchaseNotAllowed:
                message = "购买被拒绝"
            case .ineligibleForOffer:
                message = "不能享受优惠"
            case .invalidOfferIdentifier:
                message = "标识符无效"
            case .invalidOfferPrice:
                message = "价格无效"
            case .invalidOfferSignature:
                message = "签名无效"
            case .missingOfferParameters:
                message = "参数错误"
            @unknown default:
                message = "未知错误"
            }
        }

        return ["code": code, "message": message, "details": details]
    }
}
