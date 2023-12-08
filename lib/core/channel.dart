import 'package:flutter/services.dart';
import 'model.dart';

import 'iap_callback.dart';

class Channel {
  final _channel = const MethodChannel('cn.banzuoshan/store_kit_iap');

  StoreKitIapCallback? _callback;

  Channel() {
    _channel.setMethodCallHandler((call) => _listenCallback(call.method, call.arguments));
  }

  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeMethod<T>(method, arguments);
  }

  void addListener(StoreKitIapCallback callback) {
    assert(() {
      if (_callback != null) {
        throw StateError('只能添加一个监听器');
      }
      return true;
    }());
    if (_callback != null) {
      return;
    }
    _callback = callback;
  }

  Future<void> _listenCallback(String method, dynamic arguments) async {
    final callback = _callback;
    if (callback == null) {
      return;
    }

    switch (method) {
      case 'purchase_completed':
        assert(arguments is Map<String, dynamic>);
        final result = Transaction.fromJson(arguments as Map<String, dynamic>);
        callback.purchase(result);
        break;
      case 'updates_callback':
        callback.current(_fromArguments(arguments));
        break;
      case 'current_callback':
        callback.updates(_fromArguments(arguments));
        break;
      case 'unfinished_callback':
        callback.unfinished(_fromArguments(arguments));
        break;
      case 'all_callback':
        callback.all(_fromArguments(arguments));
        break;
      default:
        assert(false, '未知的方法 $method');
        break;
    }
  }

  List<Transaction> _fromArguments(dynamic arguments) {
    assert(arguments is List<Map<String, dynamic>>);
    final list = arguments as List<Map<String, dynamic>>;
    return list.map((e) => Transaction.fromJson(e)).toList();
  }
}
