import 'package:flutter/material.dart';

class SavingDialog extends StatelessWidget {
  const SavingDialog(
      {super.key,
      this.spinKitColor = Colors.white,
      this.spinKitSize = 50.0,
      required this.loadingText,
      required this.generatingText,
      required this.customLoadingWidget,
      required this.resultText});
  final Widget customLoadingWidget;
  final Color spinKitColor;
  final double spinKitSize;
  final String loadingText;
  final String generatingText;
  final String resultText;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 264,
        height: 364,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(
                255, 165, 164, 164), // Set the desired border color here
            width: 1.0, // Set the desired border width here
          ),
        ),
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
                Text(
                  generatingText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                Text(
                  resultText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                )
              ],
            ),
          ),
          Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Image(
                  image: AssetImage('assets/icons/close_icon_sq.webp'),
                  width: 25,
                  height: 25,
                ),
              ))
        ]),
      ),
    );
  }
}
