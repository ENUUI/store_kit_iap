import 'dart:async';
import 'dart:typed_data';

import 'data.dart';
import 'messages.g.dart';

class StoreKitFlutterApiImpl implements StoreKitFlutterApi {
  static void setUp(StoreKitFlutterApi? api) {
    StoreKitFlutterApi.setUp(api);
  }

  late final StreamController<List<Transaction>> allTransactionController =
      StreamController<List<Transaction>>.broadcast();

  late final StreamController<List<Transaction>> currentTransactionController =
      StreamController<List<Transaction>>.broadcast();

  late final StreamController<List<Transaction>>
      unfinishedTransactionController =
      StreamController<List<Transaction>>.broadcast();

  late final StreamController<bool> introOfferTransactionController =
      StreamController<bool>.broadcast();

  late final StreamController<Uint8List> productTransactionController =
      StreamController<Uint8List>.broadcast();

  late final StreamController<Transaction> purchasedTransactionController =
      StreamController<Transaction>.broadcast();

  late final StreamController<Transaction> updateTransactionController =
      StreamController<Transaction>.broadcast();

  @override
  void onAll(Map<String, Object?> data) {
    final result = _parseTransactionList(data);
    _notify<List<Transaction>>(result, allTransactionController,
        def: const <Transaction>[]);
  }

  @override
  void onCurrent(Map<String, Object?> data) {
    final result = _parseTransactionList(data);
    _notify<List<Transaction>>(result, currentTransactionController,
        def: const <Transaction>[]);
  }

  @override
  void onUnfinished(Map<String, Object?> data) {
    final result = _parseTransactionList(data);
    _notify<List<Transaction>>(result, unfinishedTransactionController,
        def: const <Transaction>[]);
  }

  @override
  void onIntroOffer(Map<String, Object?> data) {
    final result = Result<bool>.fromJson(data, (json) => json == true);
    _notify<bool>(result, introOfferTransactionController, def: false);
  }

  @override
  void onProduct(Map<String, Object?> data) {
    final result =
        Result<Uint8List>.fromJson(data, (json) => json as Uint8List);
    _notify<Uint8List>(result, productTransactionController);
  }

  @override
  void onPurchased(Map<String, Object?> data) {
    final result = Result<Transaction>.fromJson(
      data,
      (j) => Transaction.fromJson(j as Map<String, dynamic>),
    );
    _notify<Transaction>(result, purchasedTransactionController);
  }

  @override
  void onUpdates(Map<String, Object?> data) {
    final result = Result<Transaction>.fromJson(
      data,
      (j) => Transaction.fromJson(j as Map<String, dynamic>),
    );
    _notify<Transaction>(result, updateTransactionController);
  }
}

extension on StoreKitFlutterApiImpl {
  Result<List<Transaction>> _parseTransactionList(Map<String, Object?> data) {
    return Result.fromJson(
      data,
      (json) => (json as List<Map<String, dynamic>>)
          .map(Transaction.fromJson)
          .toList(),
    );
  }

  void _notify<T>(Result<T> result, StreamController<T> controller, {T? def}) {
    if (result.error != null) {
      controller.addError(result.error!);
    } else {
      final data = result.data ?? def;
      if (data != null) {
        controller.add(data);
      }
    }
  }
}
