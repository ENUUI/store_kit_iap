import Foundation

typealias SKIUserInfo = [String: String]

enum SKIError: Error {
    case arguments(String)
    case device
}

enum Opt {
    struct Purchase {
        struct Promotion {
            let offerId: String
            let keyID: String
            let nonce: UUID
            let signature: Data
            let timestamp: Int

            init(_ params: [String: Any]) throws {
                guard let offerId = params["offer_id"] as? String else {
                    throw SKIError.arguments("优惠offerId不能为空")
                }
                guard let keyID = params["key_id"] as? String else {
                    throw SKIError.arguments("优惠keyID不能为空")
                }
                guard let nonceString = params["nonce"] as? String, let nonce = UUID(uuidString: nonceString) else {
                    throw SKIError.arguments("优惠nonce不能为空")
                }
                guard let signatureString = params["signature"] as? String, let signature = signatureString.data(using: .utf8) else {
                    throw SKIError.arguments("优惠signature不能为空")
                }
                guard let timestamp = params["timestamp"] as? Int else {
                    throw SKIError.arguments("优惠timestamp不能为空")
                }
                self.offerId = offerId
                self.keyID = keyID
                self.nonce = nonce
                self.signature = signature
                self.timestamp = timestamp
            }
        }

        let productId: String
        let quantity: Int?
        let uuid: String?
        let promotion: Promotion?
        let extra: SKIUserInfo?

        init(_ arguments: Any?) throws {
            guard let arguments else {
                throw SKIError.arguments("参数不能为空")
            }

            guard let parameters = arguments as? [String: Any] else {
                throw SKIError.arguments("参数类型错误")
            }

            guard let productId = parameters["product_id"] as? String else {
                throw SKIError.arguments("product_id不能为空")
            }

            self.productId = productId

            if let quantity = parameters["quantity"] as? Int {
                guard quantity >= 1 else {
                    throw SKIError.arguments("购买数量最少为1")
                }
                self.quantity = quantity
            } else {
                quantity = nil
            }

            uuid = parameters["uuid"] as? String
            extra = parameters["extra"] as? SKIUserInfo

            if let promotion = parameters["promotion"] as? [String: Any] {
                self.promotion = try Promotion(promotion)
            } else {
                promotion = nil
            }
        }
    }
}
