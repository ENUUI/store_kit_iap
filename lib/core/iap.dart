import 'package:flutter/services.dart';

class StoreKitIap {
  final channel = const MethodChannel('cn.banzuoshan/store_kit_iap');

  Future<void> purchase(String productId) async {
    await channel.invokeMethod('purchase', {'product_id': productId});
  }
}
