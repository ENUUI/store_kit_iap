import 'dart:async';

import 'package:store_kit_iap/core/data/model.dart';
import 'package:store_kit_iap/core/ut.dart';

import 'data/error.dart';
import 'data/result.dart';
import 'iap.dart';
import 'iap_callback.dart';

class StoreKitAsync {
  StoreKitAsync() {
    _storeKit.addListener(_callback);
  }

  final StoreKit _storeKit = StoreKit();
  final _callback = _StoreKitIapCallback();

  /// 是否有资格获得推介促销优惠(新用户)
  Future<bool> eligibleForIntroOffer(String productId) {
    final task = _callback.newTask<bool>();

    _storeKit.eligibleForIntroOffer(productId, requestId: task.requestId).catchError(task.error);

    return task.future;
  }

  /// 是否有资格获得促销优惠(正在使用/使用过的用户), 购买提供优惠时，需要签名。
  Future<bool> eligibleForPromotionOffer(String productId, {String requestId = ''}) {
    final task = _callback.newTask<bool>();

    _storeKit.eligibleForPromotionOffer(productId, requestId: task.requestId).catchError(task.error);

    return task.future;
  }

  Future<Object?> getProduct(String productId) {
    final task = _callback.newTask<Object>();

    _storeKit.getProduct(productId, requestId: task.requestId).catchError(task.error);

    return task.future;
  }

  Future<void> finish(int transactionId) {
    return _storeKit.finish(transactionId);
  }

  Future<String> vendorId() {
    return _storeKit.vendorId();
  }

  /// 支付
  Future<Transaction> purchase(PurchaseOpt opt) {
    final task = _callback.newTask<Transaction>();

    _storeKit.purchase(opt, requestId: task.requestId).catchError(task.error);

    return task.future;
  }

  /// 当前的权益列表会发出用户拥有权益的每个产品的最新交易，具体包括：
  /// - 每个非消耗性应用内购买的交易
  /// - 每个自动续订订阅的最新交易，其Product.SubscriptionInfo.RenewalState状态为subscribed或inGracePeriod
  /// - 每个非续订订阅的最新交易，包括已完成的订阅
  /// - App Store退款或撤销的产品不会出现在当前的权益中。消耗性应用内购买也不会出现在当前的权益中。
  /// Important: 要获取未完成的消耗性产品的交易，请使用Transaction中的unfinished或all列表。
  Future<List<Transaction>> current() {
    final task = _callback.newTask<List<Transaction>>();

    _storeKit.current(requestId: task.requestId).catchError(task.error);

    return task.future;
  }

  /// 当前的权益列表，例如询问购买交易、订阅优惠码兑换以及客户在App Store中进行的购买。
  /// 它还会发出在另一台设备上完成的客户端在您的应用程序中的交易。
  Stream<Transaction> updates() {
    final task = _callback.updatesTask();
    if (task.running) {
      return task.stream;
    }

    task.running = true;
    _storeKit.updates().catchError(task.error);

    return task.stream;
  }

  Future<void> cancelUpdates() async {
    final task = _callback.updatesTask();
    task.cancel();
    await _storeKit.cancelUpdates();
  }

  /// 需要处理的交易。未处理的交易会在启动时的 updates 中返回
  Future<List<Transaction>> unfinished() {
    final task = _callback.newTask<List<Transaction>>();

    _storeKit.unfinished(requestId: task.requestId).catchError(task.error);

    return task.future;
  }

  /// 所有的交易
  Future<List<Transaction>> all() {
    final task = _callback.newTask<List<Transaction>>();

    _storeKit.all(requestId: task.requestId).catchError(task.error);

    return task.future;
  }
}

abstract class _Task<T> {
  _Task(this.requestId);

  final String requestId;

  void complete(Result<T> result);

  void error(Object error, StackTrace? stackTrace);
}

class _SequenceTask<T> extends _Task<T> {
  _SequenceTask() : super('');

  Stream<T> get stream => _controller.stream;
  final StreamController<T> _controller = StreamController<T>.broadcast();

  bool running = false;

  @override
  void complete(Result<T> result) {
    if (result.requestId != requestId) return;
    final error = result.error;
    if (error != null) {
      _controller.addError(error);
      return;
    }

    final data = result.data;
    if (data == null) {
      _controller.addError(
        SkiError(
          code: 500,
          message: '未知错误',
          details: '[$runtimeType.data] is null. Sequence Task Event cannot be null.',
        ),
        StackTrace.current,
      );
      return;
    }

    _controller.add(data);
  }

  @override
  void error(Object error, StackTrace? stackTrace) {
    _controller.addError(SkiError.fromError(error), stackTrace);
  }

  Future<void> cancel() async {
    await _controller.close();
  }
}

class _RequestTask<T> extends _Task<T> {
  _RequestTask(super.requestId);

  Future<T> get future => _completer.future;
  final _completer = Completer<T>();

  @override
  void complete(Result<T> result) {
    if (result.requestId != requestId) return;
    if (_completer.isCompleted) return;

    if (result.error != null) {
      _completer.completeError(result.error!, StackTrace.current);
    } else {
      _completer.complete(result.data);
    }
  }

  @override
  void error(Object error, StackTrace? stackTrace) {
    _completer.completeError(SkiError.fromError(error), stackTrace);
  }
}

class _StoreKitIapCallback implements StoreKitIapCallback {
  final _callbacks = <String, _Task>{};

  _RequestTask<T> newTask<T>() {
    final requestId = uuid();
    final task = _RequestTask<T>(requestId);
    _callbacks[requestId] = task;
    return task;
  }

  _SequenceTask<Transaction>? _updatesTask;

  _SequenceTask<Transaction> updatesTask() {
    _SequenceTask<Transaction>? task = _updatesTask;
    if (task != null) {
      return task;
    }

    task = _SequenceTask<Transaction>();
    _updatesTask = task;
    return task;
  }

  void complete<T>(Result<T> r) {
    final task = _callbacks.remove(r.requestId);
    if (task == null) {
      assert(false, '未找到对应的task');
      return;
    }
    task.complete(r);
  }

  @override
  void all(Result<List<Transaction>> result) {
    complete(result);
  }

  @override
  void current(Result<List<Transaction>> result) {
    complete(result);
  }

  @override
  void eligibleIntroOfferCallback(Result<bool> result) {
    complete(result);
  }

  @override
  void eligiblePromotionOfferCallback(Result<bool> result) {
    complete(result);
  }

  @override
  void productCallback(Result<Map<String, dynamic>> result) {
    complete(result);
  }

  @override
  void purchase(Result<Transaction> result) {
    complete(result);
  }

  @override
  void unfinished(Result<List<Transaction>> result) {
    complete(result);
  }

  @override
  void updates(Result<Transaction> result) {
    _SequenceTask<Transaction>? task = _updatesTask;
    if (task == null) {
      assert(false, '未找到对应的task');
      return;
    }

    task.complete(result);
  }
}
