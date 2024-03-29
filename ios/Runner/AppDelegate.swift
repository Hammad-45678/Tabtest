import UIKit
import Flutter
// TODO: Import google_mobile_ads
import google_mobile_ads

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // TODO: Register ListTileNativeAdFactory
      let listTileFactory = ListTileNativeAdFactory()
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self, factoryId: "listTile", nativeAdFactory: listTileFactory)
      
      let listTileFactory2 = ListTileNativeAdFactory2()
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self, factoryId: "listTileMedia", nativeAdFactory: listTileFactory2)
      
      
      let listTileFactory3 = ListTileNativeAdFactory3()
      FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
          self, factoryId: "listTileBanner", nativeAdFactory: listTileFactory3)
    // TODO: You can add test devices
    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "e3e7e04c3f28fae5ad995f71016792cc" ]


    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
