## StoreKitIap Flutter 插件文档

StoreKitIap 是一个用于在 Flutter 应用中集成苹果 StoreKit 2 的插件。它提供了与苹果 App Store 进行应用内购买和订阅交易的功能。

### iOS 版本
  
  `platform = :ios, '15.0'`

### 安装

要在 Flutter 项目中使用 StoreKitIap 插件，请按照以下步骤进行安装：

1. 在项目的 `pubspec.yaml` 文件中添加 StoreKitIap 依赖：

   ```yaml
   dependencies:
     store_kit_iap:
       git:
         url: https://github.com/ENUUI/store_kit_iap.git
         ref: main
   ```
2. 运行以下命令获取依赖项：

   ```bash
   flutter pub get
   ```

### 集成 StoreKitIap

要在 Flutter 应用中使用 StoreKit 插件，您需要按照以下步骤进行集成：

1. 在您的 Dart 代码文件中导入 StoreKit：

   ```dart
   import 'package:store_kit_iap/store_kit_iap.dart';
   ```
2. 使用 StoreKit 进行应用内购买和订阅交易：
   ```
   final StoreKit storeKit = StoreKit();
   storeKit.purchased.listen((transaction) {
      // do something ...
   }, onError: (error) {
      // handle error ...
   });
   final opt = PurchaseOpt(productId: 'productId');
   storeKit.purchase(opt).catchError((error) {
      // handle error before purchasing
   });
   ```
### 注意事项
- StoreKit 插件仅支持 iOS 平台，并且最低支持的 iOS 系统版本为 iOS 15。
- 在使用 StoreKit 插件之前，确保您的 Flutter 项目已正确配置和运行，并且已在 iOS 设备上进行了适当的测试。

### API 文档

[Apple Developer](https://developer.apple.com/documentation/storekit/in-app_purchase)
