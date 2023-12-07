import Foundation

typealias SKIUserInfo = [String: String]

enum SKIError: Error {
    case arguments(String)
}

struct Opt {
    struct Purchase {
        let productId: String
        let quantity: Int?
        let uuid: String?
        let extra: SKIUserInfo?
        
        init(_ parameters: [String: Any]) throws {
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
                self.quantity = nil
            }
            
            self.uuid = parameters["uuid"] as? String
            self.extra = parameters["extra"] as? SKIUserInfo
        }
    }
    
}
