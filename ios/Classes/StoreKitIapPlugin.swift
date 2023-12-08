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
        case "purchase":
            purchase(call.arguments, result: result)
        case "updates":
            updates()
            result(nil)
        case "current":
            updates()
            result(nil)
        case "unfinished":
            unfinished()
            result(nil)
        case "all":
            all()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}

/// channel listeners
private extension StoreKitIapPlugin {
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

    func updates() {
        transaction.updates { self.updatesCompleted($0) }
    }

    func current() {
        transaction.current { self.currentCompleted($0) }
    }

    func unfinished() {
        transaction.unfinished { self.unfinishedCompleted($0) }
    }

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
