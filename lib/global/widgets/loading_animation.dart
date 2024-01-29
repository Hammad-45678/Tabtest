import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/enhance_screen/provider/dynamic_loadingProvider.dart';

class LoadingAnimation extends StatelessWidget {
  const LoadingAnimation(
      {super.key,
      this.spinKitColor = Colors.white,
      this.spinKitSize = 50.0,
      required this.loadingText,
      required this.generatingText,
      required this.customLoadingWidget,
      this.resultText});

  final Widget customLoadingWidget;
  final Color spinKitColor;
  final double spinKitSize;
  final String loadingText;
  final String generatingText;
  final String? resultText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/loading_bg.webp'),
                    width: 116,
                    height: 119,
                  ),
                  customLoadingWidget,
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                loadingText,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Consumer<LoadingTextData>(builder:
                  (BuildContext context, LoadingTextData value, Widget? child) {
                return Text(
                  generatingText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                );
              }),
              resultText != null
                  ? Text(
                      resultText!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    )
                  : Container()
            ],
          ),
        ),
      ]),
    );
  }
}
