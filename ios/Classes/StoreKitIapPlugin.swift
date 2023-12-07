import Flutter
import UIKit

public class StoreKitIapPlugin: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel
    
    public init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "cn.banzuoshan/store_kit_iap", binaryMessenger: registrar.messenger())
        let instance = StoreKitIapPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "purchase":
            guard let opts = call.arguments as? [String: Any], let productId = opts["product_id"] as? String else {
                result(FlutterError(code: "404", message: "获取product id 失败", details: "\(String(describing: call.arguments))"))
                return
            }
    
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func invoke(_ method: String, value: Any? = nil) {
        print(Thread.current.isMainThread)
        if Thread.current.isMainThread {
            self.channel.invokeMethod(method, arguments: value)
        } else {
            DispatchQueue.main.async {
                self.channel.invokeMethod(method, arguments: value)
            }
        }
    }
}
