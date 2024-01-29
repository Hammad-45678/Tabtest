import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.80,
      child: Stack(
        children: [
          Container(
            width: 137,
            height: 26,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Colors.white),
              ),
            ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            child: Image(
              image: AssetImage('assets/icons/close_text.webp'),
              width: 12,
              height: 12,
            ),
          ),
          const Positioned(
            bottom: 0,
            right: 0,
            child: Image(
              image: AssetImage('assets/icons/enlarge_text.webp'),
              width: 12,
              height: 12,
            ),
          ),
        ],
      ),
    );
  }
}
