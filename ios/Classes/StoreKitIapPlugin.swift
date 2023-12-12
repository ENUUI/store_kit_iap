import Flutter
import UIKit

public class StoreKitIapPlugin: NSObject, FlutterPlugin {
    var channel: FlutterMethodChannel

    lazy var transaction = SKITransaction()

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
        case "eligible_for_intro_offer":
            // 是否有资格获得试用优惠
            eligibleForIntroOffer(call.arguments, result: result)
        case "get_product":
            // 获取商品信息
            getProduct(call.arguments, result: result)
        case "finish_transaction":
            // 结束交易
            finish(call.arguments, result: result)
        case "vendor_id":
            // 获取vendorId
            result(vendorId())
        case "purchase":
            // 购买商品
            purchase(call.arguments, result: result)
        case "updates":
            /// 监听是否有交易更新
            updates()
            result(nil)
        case "current":
            // 获取当前可用的交易
            current()
            result(nil)
        case "unfinished":
            // 获取当前不可用的交易
            unfinished()
            result(nil)
        case "all":
            // 获取所有交易
            all()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

/// channel listeners
private extension StoreKitIapPlugin {
    /// 是否有资格获得试用优惠
    func eligibleForIntroOffer(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments else {
            result(FlutterError(code: "404", message: "参数错误", details: ""))
            return
        }

        guard let pid = arguments as? String else {
            result(FlutterError(code: "404", message: "参数错误", details: ""))
            return
        }

        transaction.eligibleForIntroOffer(pid) {
            switch $0 {
            case let .success(enable):
                result(enable)
            case let .failure(error):
                result(FlutterError(code: "500", message: "从苹果获取优惠失败", details: error.localizedDescription))
            }
        }
    }

    // 获取商品信息
    func getProduct(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments else {
            result(FlutterError(code: "404", message: "参数错误", details: ""))
            return
        }

        guard let pid = arguments as? String else {
            result(FlutterError(code: "404", message: "参数错误", details: ""))
            return
        }

        transaction.getProduct(pid) {
            switch $0 {
            case let .success(data):
                result(data)
            case let .failure(error):
                result(FlutterError(code: "500", message: "从苹果获取商品失败", details: error.localizedDescription))
            }
        }
    }

    /// 结束交易
    func finish(_ arguments: Any?, result: @escaping FlutterResult) {
        guard let arguments else {
            result(FlutterError(code: "404", message: "参数错误", details: ""))
            return
        }

        guard let id = arguments as? UInt64 else {
            result(FlutterError(code: "404", message: "参数错误", details: ""))
            return
        }
        guard transaction.finish(id) else {
            result(FlutterError(code: "400", message: "", details: "未找到订单: \(id)"))
            return
        }
        result(nil)
    }

    /// 获取vendorId
    func vendorId() -> String? {
        transaction.deviceVerificationID()
    }

    /// 购买商品
    func purchase(_ arguments: Any?, result: @escaping FlutterResult) {
        do {
            let opt = try Opt.Purchase(arguments)
            transaction.purchase(opt) {
                // flutter与原生通讯有超时限制，而拉起支付弹窗后时间不可控，所以通过channel回调结果。
                self.purchaseCompleted($0)
            }
            result(nil)
        } catch let SKIError.arguments(details) {
            result(FlutterError(code: "404", message: "参数错误", details: details))
        } catch {
            result(FlutterError(code: "500", message: "未知错误", details: ""))
        }
    }

    /// 监听是否有交易更新
    func updates() {
        transaction.updates { self.updatesCompleted($0) }
    }

    /// 获取当前可用的交易
    func current() {
        transaction.current { self.currentCompleted($0) }
    }

    /// 获取当前不可用的交易
    func unfinished() {
        transaction.unfinished { self.unfinishedCompleted($0) }
    }

    /// 获取所有交易
    func all() {
        transaction.all { self.allCompleted($0) }
    }
}

/// channel callback
private extension StoreKitIapPlugin {
    func purchaseCompleted(_ result: SKITransaction.Result) {
        invoke("purchase_completed", arguments: result.json)
    }

    func updatesCompleted(_ results: [SKITransaction.Result]) {
        resultsCompleted("updates_callback", results: results)
    }

    func currentCompleted(_ results: [SKITransaction.Result]) {
        resultsCompleted("current_callback", results: results)
    }

    func unfinishedCompleted(_ results: [SKITransaction.Result]) {
        resultsCompleted("unfinished_callback", results: results)
    }

    func allCompleted(_ results: [SKITransaction.Result]) {
        resultsCompleted("all_callback", results: results)
    }

    func resultsCompleted(_ method: String, results: [SKITransaction.Result]) {
        invoke(method, arguments: results.map(\.json))
    }

    func invoke(_ method: String, arguments: Any? = nil) {
        let invokeFn = { self.channel.invokeMethod(method, arguments: arguments) }

        if Thread.current.isMainThread {
            invokeFn()
        } else {
            DispatchQueue.main.async(execute: invokeFn)
        }
    }
}
