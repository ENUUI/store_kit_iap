// import 'package:flutter_test/flutter_test.dart';
// import 'package:store_kit_iap/store_kit_iap.dart';
// import 'package:store_kit_iap/store_kit_iap_platform_interface.dart';
// import 'package:store_kit_iap/store_kit_iap_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockStoreKitIapPlatform
//     with MockPlatformInterfaceMixin
//     implements StoreKitIapPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final StoreKitIapPlatform initialPlatform = StoreKitIapPlatform.instance;
//
//   test('$MethodChannelStoreKitIap is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelStoreKitIap>());
//   });
//
//   test('getPlatformVersion', () async {
//     StoreKitIap storeKitIapPlugin = StoreKitIap();
//     MockStoreKitIapPlatform fakePlatform = MockStoreKitIapPlatform();
//     StoreKitIapPlatform.instance = fakePlatform;
//
//     expect(await storeKitIapPlugin.getPlatformVersion(), '42');
//   });
// }
