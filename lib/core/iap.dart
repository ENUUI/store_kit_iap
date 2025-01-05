import 'dart:async';

import 'package:flutter/foundation.dart';

import 'iap_flutter_api.dart';
import 'messages.g.dart';
import 'data.dart';

class StoreKit {
  StoreKit({@visibleForTesting StoreKitIosApi? hostApi})
      : _hostApi = hostApi ?? StoreKitIosApi() {
    StoreKitFlutterApi.setUp(_flutterApi);
  }

  final StoreKitIosApi _hostApi;
  final _flutterApi = StoreKitFlutterApiImpl();

  /// After call [StoreKit.all], the result will be callback by [StoreKit.allTransactions]
  Stream<List<Transaction>> get allTransactions =>
      _flutterApi.allTransactionController.stream;

  /// After call [StoreKit.current], the result will be callback by [StoreKit.currentTransactions]
  Stream<List<Transaction>> get currentTransactions =>
      _flutterApi.currentTransactionController.stream;

  /// After call [StoreKit.unfinished], the result will be callback by [StoreKit.unfinishedTransactions]
  Stream<List<Transaction>> get unfinishedTransactions =>
      _flutterApi.unfinishedTransactionController.stream;

  /// 是否有资格获得推介促销优惠(新用户)
  Stream<bool> get introOffer =>
      _flutterApi.introOfferTransactionController.stream;

  /// After call [StoreKit.getProduct], the result will be callback by [StoreKit.product]
  Stream<Uint8List> get product =>
      _flutterApi.productTransactionController.stream;

  /// 支付完成回调
  Stream<Transaction> get purchased =>
      _flutterApi.purchasedTransactionController.stream;

  /// 当开启监听交易更新时，其有更新发生，更新会由[updateTransaction]回调
  Stream<Transaction> get updateTransaction =>
      _flutterApi.updateTransactionController.stream;

  /// 是否有资格获得推介促销优惠(新用户)
  Future<void> eligibleForIntroOffer(String productId) {
    if (productId.isEmpty) {
      return Future.error(
        const SkiError(
          code: 400,
          message: 'productId不能为空',
          details: 'productId is empty',
        ),
        StackTrace.current,
      );
    }

    return _hostApi.eligibleForIntroOffer(productId);
  }

  Future<void> getProduct(String productId, {String requestId = ''}) {
    if (productId.isEmpty) {
      return Future.error(
        const SkiError(
          code: 400,
          message: 'productId不能为空',
          details: 'productId is empty',
        ),
        StackTrace.current,
      );
    }

    return _hostApi.getProduct(productId);
  }

  /// 关闭订单
  Future<void> finish(int transactionId) {
    if (transactionId <= 0) {
      return Future.error(
        const SkiError(
          code: 400,
          message: 'transactionId 不能小于 0',
          details: 'transactionId must be bigger then 0.',
        ),
        StackTrace.current,
      );
    }
    return _hostApi.finish(transactionId);
  }

  Future<String> vendorId() {
    return _hostApi.vendorId();
  }

  /// 支付
  Future<void> purchase(PurchaseOpt opt) async {
    final err = opt.validate();
    if (err != null) {
      return Future.error(err, StackTrace.current);
    }

    return _hostApi.purchase(opt.toJson());
  }

  /// 当前的权益序列会发出用户拥有权益的每个产品的最新交易，具体包括：
  /// - 每个非消耗性应用内购买的交易
  /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
  /// - 每个非续订订阅的最新交易，包括已完成的订阅
  /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
  /// Important: 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all序列。
  Future<void> current() {
    return _hostApi.current();
  }

  /// 当前的权益序列，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
  /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
  /// 每当用户购买或恢复购买产品时，都会触发此序列。
  /// 监听此序列， 每接受到一个交易更新，都会回调 [StoreKitIapCallback.updates]。
  /// 通过调用 [cancelUpdates] 取消监听。
  Future<void> updates() {
    return _hostApi.updates();
  }

  /// 取消监听更新
  Future<void> cancelUpdates() {
    return _hostApi.cancelUpdates();
  }

  /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
  Future<void> unfinished() {
    return _hostApi.unfinished();
  }

  /// 交易历史记录包括应用程序尚未通过调用finish()完成的可消耗应用内购买。
  /// 它不包括已完成的可消耗产品或已完成的非续订订阅，重新购买的非消耗性产品或订阅，或已恢复的购买。
  Future<void> all() {
    return _hostApi.all();
  }
}
