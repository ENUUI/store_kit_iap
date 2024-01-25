import 'dart:async';

import 'package:store_kit_iap/core/data/model.dart';

import 'data/result.dart';
import 'iap.dart';
import 'iap_callback.dart';

class StoreKitAsync {
  final StoreKit _storeKit = StoreKit();
  final _callback = _StoreKitIapCallback();
}

class _StoreKitIapCallback implements StoreKitIapCallback {
  final _callbacks = <String, Completer>{};

  void add(String method, Completer completer) {
    _callbacks[method] = completer;
  }

  @override
  void all(Result<List<Transaction>> result) {
    // TODO: implement all
  }

  @override
  void current(Result<List<Transaction>> result) {
    // TODO: implement current
  }

  @override
  void eligibleCallback(Result<bool> result) {
    // TODO: implement eligibleCallback
  }

  @override
  void productCallback(Result<Map<String, dynamic>> result) {
    // TODO: implement productCallback
  }

  @override
  void purchase(Result<Transaction> result) {
    // TODO: implement purchase
  }

  @override
  void unfinished(Result<List<Transaction>> result) {
    // TODO: implement unfinished
  }

  @override
  void updates(Result<List<Transaction>> result) {
    // TODO: implement updates
  }
}
