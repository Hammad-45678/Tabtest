import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'package:picstar/shared/constants/ad_constants.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({
    Key? key,
  }) : super(key: key);

  @override
  _NativeAdWidgetState createState() => _NativeAdWidgetState();
}

class _NativeAdWidgetState extends State<NativeAdWidget> {
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
      factoryId: 'listTile',
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
    return _isAdLoaded
        ? Container(
            width: double.infinity,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            height: Platform.isIOS ? 140 : 150,
            child: AdWidget(ad: _nativeAd),
          )
        : const SizedBox();
  }
}
