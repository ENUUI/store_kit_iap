import Foundation

typealias SKIUserInfo = [String: String]

enum SKIError: Error {
    case arguments(String)
}

enum Opt {
    struct Purchase {
        let productId: String
        let quantity: Int?
        let uuid: String?
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
        }
    }
}
