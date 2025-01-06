import 'dart:async';
import 'dart:typed_data';

import 'data.dart';
import 'messages.g.dart';

class StoreKitFlutterApiImpl implements StoreKitFlutterApi {
  static void setUp(StoreKitFlutterApi? api) {
    StoreKitFlutterApi.setUp(api);
  }

  final _streamControllers = <String, StreamController>{
    'all': StreamController<List<Transaction>>.broadcast(),
    'current': StreamController<List<Transaction>>.broadcast(),
    'unfinished': StreamController<List<Transaction>>.broadcast(),
    'introOffer': StreamController<bool>.broadcast(),
    'product': StreamController<Uint8List>.broadcast(),
    'purchased': StreamController<Transaction>.broadcast(),
    'updates': StreamController<Transaction>.broadcast(),
  };

  /// Accessors for stream controllers
  Stream<List<Transaction>> get allTransactionStream =>
      _streamControllers['all']!.stream.cast<List<Transaction>>();

  Stream<List<Transaction>> get currentTransactionStream =>
      _streamControllers['current']!.stream.cast<List<Transaction>>();

  Stream<List<Transaction>> get unfinishedTransactionStream =>
      _streamControllers['unfinished']!.stream.cast<List<Transaction>>();

  Stream<bool> get introOfferStream =>
      _streamControllers['introOffer']!.stream.cast<bool>();

  Stream<Uint8List> get productStream =>
      _streamControllers['product']!.stream.cast<Uint8List>();

  Stream<Transaction> get purchasedStream =>
      _streamControllers['purchased']!.stream.cast<Transaction>();

  Stream<Transaction> get updateTransactionStream =>
      _streamControllers['updates']!.stream.cast<Transaction>();

  /// Dispose all stream controllers
  void dispose() {
    for (final controller in _streamControllers.values) {
      controller.close();
    }
  }

  @override
  void onAll(Map<String, Object?> data) {
    _handleListTransactionEvent('all', data);
  }

  @override
  void onCurrent(Map<String, Object?> data) {
    _handleListTransactionEvent('current', data);
  }

  @override
  void onUnfinished(Map<String, Object?> data) {
    _handleListTransactionEvent('unfinished', data);
  }

  @override
  void onIntroOffer(Map<String, Object?> data) {
    _handleEvent<bool>('introOffer', data, (json) => json == true,
        defaultValue: false);
  }

  @override
  void onProduct(Map<String, Object?> data) {
    _handleEvent<Uint8List>('product', data, (json) => json as Uint8List);
  }

  @override
  void onPurchased(Map<String, Object?> data) {
    _handleTransactionEvent('purchased', data);
  }

  @override
  void onUpdates(Map<String, Object?> data) {
    _handleTransactionEvent('updates', data);
  }

  /// Handles events emitting a list of transactions
  void _handleListTransactionEvent(
      String streamKey, Map<String, Object?> data) {
    final result = Result<List<Transaction>>.fromJson(
      data,
      (json) => (json as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(Transaction.fromJson)
          .toList(),
    );
    _notify(streamKey, result, defaultValue: const <Transaction>[]);
  }

  /// Handles events emitting a single transaction
  void _handleTransactionEvent(String streamKey, Map<String, Object?> data) {
    final result = Result<Transaction>.fromJson(
      data,
      (json) => Transaction.fromJson(json as Map<String, dynamic>),
    );
    _notify(streamKey, result);
  }

  /// Generalized event handler for other data types
  void _handleEvent<T>(
    String streamKey,
    Map<String, Object?> data,
    T Function(Object?) parser, {
    T? defaultValue,
  }) {
    final result = Result<T>.fromJson(data, parser);
    _notify(streamKey, result, defaultValue: defaultValue);
  }

  /// Emits events or errors to the appropriate stream
  void _notify<T>(
    String streamKey,
    Result<T> result, {
    T? defaultValue,
  }) {
    final controller = _streamControllers[streamKey];
    if (controller == null) {
      throw ArgumentError('No stream controller found for key: $streamKey');
    }

    if (result.error != null) {
      controller.addError(result.error!);
    } else {
      final data = result.data ?? defaultValue;
      if (data != null) {
        controller.add(data);
      }
    }
  }
}
