## StoreKitIap Flutter 插件文档

StoreKitIap 是一个用于在 Flutter 应用中集成苹果 StoreKit 2 的插件。它提供了与苹果 App Store 进行应用内购买和订阅交易的功能。

### iOS 版本
  
  `platform = :ios, '15.0'`

### 安装

要在 Flutter 项目中使用 StoreKitIap 插件，请按照以下步骤进行安装：

1. 在项目的 `pubspec.yaml` 文件中添加 StoreKitIap 依赖：

   ```yaml
   dependencies:
     storekit_iap: ^版本号
   ```

   将 `^版本号` 替换为您希望使用的 StoreKitIap 版本号。
2. 运行以下命令获取依赖项：

   ```bash
   flutter pub get
   ```

### 集成 StoreKitIap

要在 Flutter 应用中使用 StoreKitIap 插件，您需要按照以下步骤进行集成：

1. 在您的 Dart 代码文件中导入 StoreKitIap：

   ```dart
   import 'package:store_kit_iap/store_kit_iap.dart';
   ```
2. 使用 StoreKitIap 进行应用内购买和订阅交易：

   StoreKitIap 提供了两种方式来进行应用内购买和订阅交易：

   #### 第一种方式：使用 StoreKit
   ``` dart
   // MethodChannel MethodCallHandler
   class StoreKitIapCallbackImpl implements StoreKitIapCallback {
    void purchase(Result<Transaction> result) {
      final error = result.error
      if (error != null) {
        if (error.isCancel) {
          // 用户取消
        } else {
          // 支付错误
          print('message: ${error.message}, details: ${error.details}');
        }
      }
    }
    // implements ...
   }
   ```
   ```dart
   final opt = PurchaseOpt(productId: "product id");
   StoreKit kit = StoreKit();
   
   kit.addListener(StoreKitIapCallbackImpl());
   kit.purchase(opt);

   ```

   使用这种方式，您需要创建一个 StoreKit 对象，并调用 `purchase` 方法来执行购买或订阅交易。您可以通过添加监听器来处理支付结果。

   #### 第二种方式：使用 StoreKitAsync

   ```dart
   StoreKitAsync kit = StoreKitAsync();
   try {
      final opt = PurchaseOpt(productId: "product id");
      Transaction transaction = await kit.purchase(opt);
   } catch (error) {
      final skError = error as SkiError;
      if (skError.isCancel) {
        // 用户取消
      } else {
        // 支付错误
        print('message: ${error.message}, details: ${error.details}');
      }
   }
   ```

   使用这种方式，您需要创建一个 StoreKitAsync 对象，并调用 `purchase` 方法来执行购买或订阅交易。该方法返回一个 Future 对象，您可以使用 `await` 关键字来等待交易完成并获取交易结果。

### 注意事项
- StoreKitIap 插件仅支持 iOS 平台，并且最低支持的 iOS 系统版本为 iOS 15。
- 在使用 StoreKitIap 插件之前，确保您的 Flutter 项目已正确配置和运行，并且已在 iOS 设备上进行了适当的测试。

### API 文档

[Apple Developer](https://developer.apple.com/documentation/storekit/in-app_purchase)
