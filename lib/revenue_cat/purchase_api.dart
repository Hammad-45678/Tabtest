// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
// import '../global/constants.dart';
// import '../global/preferences.dart';
// import 'store_config.dart';
// import 'singleton_data.dart';

// class RevenueCat {
//   static Future<void> configStore() async {
//     if (await Purchases.isConfigured) return;
//     if (Platform.isIOS || Platform.isMacOS) {
//       StoreConfig(
//         store: Store.appStore,
//         apiKey: appleApiKey,
//       );
//     } else if (Platform.isAndroid) {
//       // Uncomment the following lines if you want to use Amazon Appstore.
//       // const useAmazon = bool.fromEnvironment("amazon");
//       // StoreConfig(
//       //   store: useAmazon ? Store.amazon : Store.playStore,
//       //   apiKey: useAmazon ? amazonApiKey : googleApiKey,
//       // );
//     }
//     await _configureSDK();
//   }

//   static Future<void> _configureSDK() async {
//     await Purchases.setLogLevel(LogLevel.debug);
//     PurchasesConfiguration configuration;
//     if (StoreConfig.isForAmazonAppstore()) {
//       configuration = AmazonConfiguration(StoreConfig.instance.apiKey)
//         ..appUserID = null
//         ..observerMode = false;
//     } else {
//       configuration = PurchasesConfiguration(StoreConfig.instance.apiKey)
//         ..appUserID = null
//         ..observerMode = false;
//     }
//     await Purchases.configure(configuration);
//     if (await Purchases.isConfigured) RevenueCat.initPlatformState();
//   }

//   static Future<void> initPlatformState(
//       {Function(void Function())? setState}) async {
//     appData.appUserID = await Purchases.appUserID;
//     appData.entitlementIsActive = (await Purchases.getCustomerInfo())
//             .entitlements
//             .all[entitlementID]
//             ?.isActive ??
//         false;
//     if (setState != null) setState(() => appData);
//     Preferences.userProId = appData.appUserID;
//     Preferences.proFeature = appData.entitlementIsActive;
//     Purchases.addCustomerInfoUpdateListener((customerInfo) async {
//       appData.appUserID = await Purchases.appUserID;
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//       EntitlementInfo? entitlement =
//           customerInfo.entitlements.all[entitlementID];
//       appData.entitlementIsActive = entitlement?.isActive ?? false;
//     });
//   }

//   static Future<List<Object>> getOfferings() async {
//     try {
//       Offerings offerings = await Purchases.getOfferings();
//       if (offerings.current != null) {
//         return offerings.current!.availablePackages;
//       }
//       return [];
//     } catch (e) {
//       return [];
//     }
//   }

//   static Future<void> purchasePackage(Package package) async {
//     try {
//       await Purchases.purchasePackage(package);
//     } catch (e) {}
//   }
// }

// class SubscriptionScreen extends StatefulWidget {
//   @override
//   _SubscriptionScreenState createState() => _SubscriptionScreenState();
// }

// class _SubscriptionScreenState extends State<SubscriptionScreen> {
//   List<Package> _packages = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchOfferings();
//   }

//   Future<void> _fetchOfferings() async {
//     try {
//       var packages = await RevenueCat.getOfferings();
//       setState(() {
//         _packages = packages as List<Package>;
//       });
//       debugPrint("Offerings fetched: ${packages.length}");
//     } catch (e) {
//       debugPrint("Error fetching offerings: $e");
//       setState(() {
//         // Handle the error state in your UI
//       });
//     }
//   }

//   static Future<void> restorePurchases() async {
//     try {
//       CustomerInfo restoredInfo = await Purchases.restorePurchases();
//       updateAppDataWithCustomerInfo(restoredInfo);
//     } catch (e) {
//       debugPrint("Error restoring purchases: $e");
//       // Handle error
//     }
//   }

//   static void updateAppDataWithCustomerInfo(CustomerInfo info) {
//     appData.entitlementIsActive =
//         info.entitlements.all[entitlementID]?.isActive ?? false;
//     // Update other app data as necessary
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Subscriptions'),
//       ),
//       body: Column(children: [
//         _packages.isEmpty
//             ? const Center(child: CircularProgressIndicator())
//             : Container(
//                 height: 200,
//                 child: ListView.builder(
//                   itemCount: _packages.length,
//                   itemBuilder: (context, index) {
//                     final package = _packages[index];
//                     return ListTile(
//                       title: Text(package.storeProduct.title),
//                       subtitle: Text(package.storeProduct.description),
//                       trailing: Text('\$${package.storeProduct.price}'),
//                       onTap: () {
//                         RevenueCat.purchasePackage(package);
//                       },
//                     );
//                   },
//                 ),
//               ),
//         ElevatedButton(
//           onPressed: () {
//             restorePurchases();
//           },
//           child: Text('Restore Purchases'),
//         )
//       ]),
//     );
//   }
// }
