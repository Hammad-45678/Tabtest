import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/language_constants.dart';

class Hd_button extends StatelessWidget {
  const Hd_button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            localeText(
              context,
              'hd',
            ),
            style: const TextStyle(
              color: Color(0xFF8181FF),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Image(
            image: AssetImage('assets/icons/premium_icon.webp'),
            width: 20,
            height: 20,
          )
        ],
      ),
    );
  }
}
