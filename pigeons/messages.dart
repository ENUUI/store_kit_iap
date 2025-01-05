import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/core/messages.g.dart',
  swiftOut: 'ios/Classes/messages.g.swift',
  swiftOptions: SwiftOptions(),
))
@HostApi()
abstract class StoreKitIosApi {
  /// 是否有资格获得推介促销优惠(新用户)
  @async
  @SwiftFunction("eligibleForIntroOffer(productId:)")
  void eligibleForIntroOffer(String productId);

  /// 获取指定商品信息
  /// @return Data
  @async
  @SwiftFunction("getProduct(productId:)")
  void getProduct(String productId);

  /// 关闭订单
  @async
  @SwiftFunction("finish(transactionId:)")
  void finish(int transactionId);

  @async
  String vendorId();

  @async
  @SwiftFunction("purchase(arguments:)")
  void purchase(Map<String, Object?> arguments);

  /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
  /// - 每个非消耗性应用内购买的交易
  /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
  /// - 每个非续订订阅的最新交易，包括已完成的订阅
  /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
  /// Important: 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
  @async
  void current();

  /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
  /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
  /// 每当用户购买或恢复购买产品时，都会触发此序列。
  /// 监听此序列， 每接受到一个交易更新，都会回调 [StoreKitIapCallback.updates]。
  /// 通过调用 [cancelUpdates] 取消监听。
  @async
  void updates();

  /// 取消监听更新
  @async
  void cancelUpdates();

  /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
  @async
  void unfinished();

  /// 交易历史记录包括应用程序尚未通过调用finish()完成的可消耗应用内购买。
  /// 它不包括已完成的可消耗产品或已完成的非续订订阅，重新购买的非消耗性产品或订阅，或已恢复的购买。
  @async
  void all();
}

@FlutterApi()
abstract class StoreKitFlutterApi {
  @SwiftFunction('onPurchased(data:)')
  void onPurchased(Map<String, Object?> data);

  @SwiftFunction('onUpdates(data:)')
  void onUpdates(Map<String, Object?> data);

  @SwiftFunction('onCurrent(data:)')
  void onCurrent(Map<String, Object?> data);

  @SwiftFunction('onUnfinished(data:)')
  void onUnfinished(Map<String, Object?> data);

  @SwiftFunction('onAll(data:)')
  void onAll(Map<String, Object?> data);

  /// 是否有资格获得推介促销优惠回调
  @SwiftFunction('onIntroOffer(data:)')
  void onIntroOffer(Map<String, Object?> data);

  @SwiftFunction('onProduct(data:)')
  void onProduct(Map<String, Object?> data);
}
