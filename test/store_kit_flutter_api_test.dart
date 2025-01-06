import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:store_kit_iap/core/data.dart';
import 'package:store_kit_iap/core/iap_flutter_api.dart';

void main() {
  late StoreKitFlutterApiImpl api;

  setUp(() {
    api = StoreKitFlutterApiImpl();
  });

  tearDown(() {
    api.dispose();
  });

  test('onAll emits correct data', () {
    final testTransactions = [
      {'id': 1, 'product_id': 'test1'},
      {'id': 2, 'product_id': 'test2'},
    ];

    final data = {
      'data': testTransactions,
      'error': null,
    };

    final listener = expectLater(
      api.allTransactionStream,
      emitsInOrder([
        isA<List<Transaction>>().having(
          (list) => list.map((e) => e.productId).toList(),
          'productIds',
          ['test1', 'test2'],
        ),
      ]),
    );

    api.onAll(data);

    return listener;
  });

  test('onIntroOffer emits correct data', () {
    final data = {'data': true, 'error': null};

    final listener = expectLater(api.introOfferStream, emits(true));

    api.onIntroOffer(data);

    return listener;
  });

  test('onProduct emits Uint8List data', () {
    final data = {
      'data': Uint8List.fromList([0x01, 0x02]),
      'error': null,
    };

    final listener = expectLater(
      api.productStream,
      emits(isA<Uint8List>()),
    );

    api.onProduct(data);

    return listener;
  });

  test('handles errors correctly', () {
    final error = {
      'error': {'code': 400, 'message': 'Something went wrong', 'details': ''},
      'data': null
    };

    expectLater(
      api.allTransactionStream,
      emitsError(const SkiError(
        code: 400,
        message: 'Something went wrong',
        details: '',
      )),
    );

    api.onAll(error);
  });
}
