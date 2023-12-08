import 'model.dart';

/// 回调
abstract class StoreKitIapCallback {
  /// Callback after invoking [StoreKitIap.purchase]
  void purchase(Transaction transaction);

  /// Callback after invoking [StoreKitIap.current]
  /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
  /// - 每个非消耗性应用内购买的交易
  /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
  /// - 每个非续订订阅的最新交易，包括已完成的订阅
  /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
  /// Important: 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
  void current(List<Transaction> transactions) {}

  /// Callback after invoking [StoreKitIap.updates]
  /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
  /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
  void updates(List<Transaction> transactions) {}

  /// Callback after invoking [StoreKitIap.unfinished]
  /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
  void unfinished(List<Transaction> transactions) {}

  /// Callback after invoking [StoreKitIap.all]
  /// 交易历史记录包括应用程序尚未通过调用finish()完成的可消耗应用内购买。
  /// 它不包括已完成的可消耗产品或已完成的非续订订阅，重新购买的非消耗性产品或订阅，或已恢复的购买。
  void all(List<Transaction> transactions) {}
}
