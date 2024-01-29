import google_mobile_ads

class ListTileNativeAdFactory3: FLTNativeAdFactory {

    func createNativeAd(_ nativeAd: GADNativeAd, customOptions: [AnyHashable: Any]? = nil) -> GADNativeAdView? {
        let nibView = Bundle.main.loadNibNamed("ListTileNativeAdView3", owner: nil, options: nil)!.first
        guard let nativeAdView = nibView as? GADNativeAdView else { return nil }

        // Configure headline
        if let headlineLabel = nativeAdView.headlineView as? UILabel {
            headlineLabel.text = nativeAd.headline
        }

        // Configure body
        if let bodyLabel = nativeAdView.bodyView as? UILabel {
            bodyLabel.text = nativeAd.body
            nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        }

        // Configure icon
        if let iconImageView = nativeAdView.iconView as? UIImageView {
            iconImageView.image = nativeAd.icon?.image
            nativeAdView.iconView?.isHidden = nativeAd.icon == nil
        }

        // Configure media view
//        if let mediaView = nativeAdView.mediaView as? GADMediaView {
//            nativeAdView.mediaView = mediaView
//            // Adjust the media view if needed, for example, setting content mode
//            mediaView.contentMode = .scaleAspectFit
//        }

        nativeAdView.callToActionView?.isUserInteractionEnabled = false
        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }
}
