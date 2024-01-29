import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:picstar/shared/constants/ad_constants.dart';

class NativeAdWidgetBanner extends StatefulWidget {
  const NativeAdWidgetBanner({
    Key? key,
  }) : super(key: key);

  @override
  _NativeAdWidgetBannerState createState() => _NativeAdWidgetBannerState();
}

class _NativeAdWidgetBannerState extends State<NativeAdWidgetBanner> {
  late NativeAd _nativeAd;
  bool _isAdLoaded = false;
  bool isIOS = Platform.isIOS;
  @override
  void initState() {
    super.initState();
    _nativeAd = NativeAd(
      adUnitId: Platform.isIOS
          ? AdConstants.iosAdUnitId // Use iOS ad unit ID
          : AdConstants.androidAdUnitId,
      factoryId: 'listTileBanner',
      listener: NativeAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    _nativeAd.load();
  }

  @override
  void dispose() {
    _nativeAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: _isAdLoaded
          ? Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              height: Platform.isIOS ? 70 : 265,
              child: AdWidget(ad: _nativeAd),
            )
          : const SizedBox(),
    );
  }
}
