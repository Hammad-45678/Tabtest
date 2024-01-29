import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {
  Function? onAdLoading;
  Function? onAdLoaded;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int _numInterstitialLoadAttempts = 0;
  bool isRewardedAdLoaded() {
    return _rewardedAd != null;
  }

  AdManager({this.onAdLoading, this.onAdLoaded});
  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/4411468910',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < 3) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose(); // Disposal when ad is dismissed
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose(); // Disposal when ad fails to show
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isIOS
          ? "ca-app-pub-3940256099942544/2934735716"
          : "ca-app-pub-3940256099942544/6300978111",
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    _bannerAd?.load();
  }

  Function? _onAdReadyCallback;

  void createRewardedAd() {
    onAdLoading?.call();
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1712485313',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          onAdLoaded?.call();
          print('$ad loaded.');
          _rewardedAd = ad;
          _isRewardedAdReady = true;
          _numRewardedLoadAttempts = 0;
          _onAdReadyCallback?.call();
          _onAdReadyCallback = null;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          _rewardedAd = null;
          _numRewardedLoadAttempts += 1;
          if (_numRewardedLoadAttempts < 3) {
            createRewardedAd();
          }
        },
      ),
    );
  }

  void addAds(bool interstitial, bool bannerAd, bool rewardedAd) {
    if (interstitial) {
      createRewardedAd();
    }

    if (bannerAd) {
      loadBannerAd();
    }

    // if (rewardedAd) {
    //   loadRewardedAd();
    // }
  }

  // void showInterstitial() {
  //   _interstitialAd?.show();
  // }

  BannerAd? getBannerAd() {
    return _bannerAd;
  }

  bool _isRewardedAdReady = false;

  void showRewardedAd(BuildContext context, Function navigateAfterAd) {
    if (_rewardedAd == null || !_isRewardedAdReady) {
      onAdLoading?.call();
      createRewardedAd();
      onAdLoaded?.call();
      _onAdReadyCallback = () => showRewardedAd(context, navigateAfterAd);

      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createRewardedAd();
        navigateAfterAd(); // Call the navigation function after ad is closed
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      },
    );
    _rewardedAd = null;
    _isRewardedAdReady = false;
  }
}
