import 'package:flutter/services.dart';

import 'iap_callback.dart';
import 'model.dart';

class StoreKit {
  static const _channel = MethodChannel('cn.banzuoshan/store_kit_iap');
  StoreKitIapCallback? _callback;

  StoreKit() {
    _channel.setMethodCallHandler((call) => _listenCallback(call.method, call.arguments));
  }

  /// 是否有资格获得试用优惠
  Future<bool> eligibleForIntroOffer(String productId) async {
    if (productId.isEmpty) {
      throw ArgumentError.value(
        productId,
        'productId不能为空',
        'productId is empty',
      );
    }
    final result = await _channel.invokeMethod<bool>('eligible_for_intro_offer', productId);
    return result == true;
  }

  Future getProduct(String productId) async {
    if (productId.isEmpty) {
      throw ArgumentError.value(
        productId,
        'productId不能为空',
        'productId is empty',
      );
    }
    return await _channel.invokeMethod('get_product', productId);
  }

  /// 关闭订单
  Future<void> finish(int transactionId) async {
    await _channel.invokeMethod('finish_transaction', transactionId);
  }

  Future<String> vendorId() async {
    final result = await _channel.invokeMethod('vendor_id');
    return result as String? ?? '';
  }

  /// 支付
  Future<void> purchase(PurchaseOpt opt) async {
    if (opt.productId.isEmpty) {
      throw ArgumentError.value(
        opt.productId,
        'productId不能为空',
        'productId is empty',
      );
    }
    if (opt.quantity != null && opt.quantity! <= 0) {
      throw ArgumentError.value(
        opt.quantity,
        '购买数量必须大于0',
        'quantity must be greater than 0',
      );
    }

    await _channel.invokeMethod('purchase', opt.toJson());
  }

  /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
  /// - 每个非消耗性应用内购买的交易
  /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
  /// - 每个非续订订阅的最新交易，包括已完成的订阅
  /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
  /// Important: 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
  Future<void> current() async {
    await _channel.invokeMethod('current');
  }

  /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
  /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
  Future<void> updates() async {
    await _channel.invokeMethod('updates');
  }

  /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
  Future<void> unfinished() async {
    await _channel.invokeMethod('unfinished');
  }

  /// 交易历史记录包括应用程序尚未通过调用finish()完成的可消耗应用内购买。
  /// 它不包括已完成的可消耗产品或已完成的非续订订阅，重新购买的非消耗性产品或订阅，或已恢复的购买。
  Future<void> all() async {
    await _channel.invokeMethod('all');
  }
}

extension StoreKitCallback on StoreKit {
  /// 添加监听器
  void addListener(StoreKitIapCallback callback) {
    assert(() {
      if (_callback != null) {
        throw StateError('只能添加一个监听器');
      }
      return true;
    }());
    if (_callback != null) {
      return;
    }
    _callback = callback;
  }

  Future<void> _listenCallback(String method, dynamic arguments) async {
    assert(() {
      print('[StoreKit] callback method: $method, arguments: $arguments');
      return true;
    }());
    final callback = _callback;
    if (callback == null) {
      assert(false, '未添加监听器');
      return;
    }
    switch (method) {
      case 'purchase_completed':
        assert(arguments is Map);
        final result = Transaction.fromJson((arguments as Map).cast());
        callback.purchase(result);
        break;
      case 'updates_callback':
        callback.updates(_fromArguments(arguments));
        break;
      case 'current_callback':
        callback.current(_fromArguments(arguments));
        break;
      case 'unfinished_callback':
        callback.unfinished(_fromArguments(arguments));
        break;
      case 'all_callback':
        callback.all(_fromArguments(arguments));
        break;
      default:
        assert(false, '未知的方法 $method');
        break;
    }
  }

  List<Transaction> _fromArguments(dynamic arguments) {
    assert(arguments is List);
    final list = arguments as List;
    return list.map<Map<String, dynamic>>((e) => (e as Map).cast()).map((e) => Transaction.fromJson(e)).toList();
  }
}
