import 'package:flutter/material.dart';

class CustomButtonAi extends StatelessWidget {
  final String customImage;
  final String customText;
  final Color containerColor;
  final Color textColor;
  const CustomButtonAi(
      {super.key, required this.customImage,
      required this.customText,
      required this.containerColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 32,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: containerColor),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Image(
              image: AssetImage(customImage),
              width: 20,
              height: 20,
            ),
          ),
          Text(
            customText,
            style: TextStyle(
              color: textColor,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
