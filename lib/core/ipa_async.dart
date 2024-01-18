import 'dart:async';

import 'package:store_kit_iap/core/model.dart';

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
  void all(List<Transaction> transactions) {
    // TODO: implement all
  }

  @override
  void current(List<Transaction> transactions) {
    // TODO: implement current
  }

  @override
  void purchase(Transaction transaction) {
    // TODO: implement purchase
  }

  @override
  void unfinished(List<Transaction> transactions) {
    // TODO: implement unfinished
  }

  @override
  void updates(List<Transaction> transactions) {
    // TODO: implement updates
  }

  @override
  void eligibleCallback(EligibleResult result) {
    // TODO: implement eligibleCallback
  }

  @override
  void productCallback(ProductResult result) {
    // TODO: implement productCallback
  }
}
