import 'package:flutter_test/flutter_test.dart';

import 'package:store_kit_iap/core/iap_flutter_api.dart';
import 'package:store_kit_iap/store_kit_iap.dart';
import 'package:store_kit_iap/core/messages.g.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'store_kit_iap_test.mocks.dart';

@GenerateMocks([StoreKitIosApi, StoreKitFlutterApiImpl])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StoreKit storeKit;
  late MockStoreKitIosApi mockHostApi;
  late MockStoreKitFlutterApiImpl mockFlutterApi;

  setUp(() {
    mockHostApi = MockStoreKitIosApi();
    mockFlutterApi = MockStoreKitFlutterApiImpl();
    storeKit = StoreKit(hostApi: mockHostApi, flutterApi: mockFlutterApi);
  });

  group('StoreKit tests', () {
    test('eligibleForIntroOffer should call hostApi method', () async {
      when(mockHostApi.eligibleForIntroOffer(any)).thenAnswer((_) async {});

      await storeKit.eligibleForIntroOffer('test_product');

      verify(mockHostApi.eligibleForIntroOffer('test_product')).called(1);
    });
    test('getProduct should call hostApi method', () async {
      when(mockHostApi.getProduct(any)).thenAnswer((_) async {});

      await storeKit.getProduct('product_id');

      verify(mockHostApi.getProduct('product_id')).called(1);
    });

    test('finish should validate input and call hostApi method', () async {
      when(mockHostApi.finish(any)).thenAnswer((_) async {});

      await storeKit.finish(123);

      verify(mockHostApi.finish(123)).called(1);
    });

    test('finish should throw error for invalid input', () async {
      expect(() => storeKit.finish(-1), throwsA(isA<SkiError>()));
    });

    test('vendorId should call hostApi method and return value', () async {
      when(mockHostApi.vendorId()).thenAnswer((_) async => 'test_vendor_id');

      final result = await storeKit.vendorId();

      expect(result, 'test_vendor_id');
      verify(mockHostApi.vendorId()).called(1);
    });

    test('purchase should validate input and call hostApi method', () async {
      final mockOpt = PurchaseOpt(productId: 'test_product');
      when(mockHostApi.purchase(any)).thenAnswer((_) async {});

      await storeKit.purchase(mockOpt);

      verify(mockHostApi.purchase(mockOpt.toJson())).called(1);
    });

    test('purchase should throw error for invalid input', () async {
      final mockOpt = PurchaseOpt(productId: '');

      expect(() => storeKit.purchase(mockOpt), throwsA(isA<ArgumentError>()));
    });

    test('updates should call hostApi method ', () async {
      when(mockHostApi.updates()).thenAnswer((_) async {});
      await storeKit.updates();

      verify(mockHostApi.updates()).called(1);
    });

    test('cancelUpdates should call hostApi method ', () async {
      when(mockHostApi.cancelUpdates()).thenAnswer((_) async {});
      await storeKit.cancelUpdates();

      verify(mockHostApi.cancelUpdates()).called(1);
    });

    test('current should call hostApi method ', () async {
      when(mockHostApi.current()).thenAnswer((_) async {});
      await storeKit.current();

      verify(mockHostApi.current()).called(1);
    });

    test('unfinished should call hostApi method ', () async {
      when(mockHostApi.unfinished()).thenAnswer((_) async {});
      await storeKit.unfinished();

      verify(mockHostApi.unfinished()).called(1);
    });

    test('all should call hostApi method ', () async {
      when(mockHostApi.all()).thenAnswer((_) async {});
      await storeKit.all();

      verify(mockHostApi.all()).called(1);
    });
  });
}
