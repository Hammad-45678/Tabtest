import 'package:flutter/material.dart';

class AdLoading extends StatelessWidget {
  const AdLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(10)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.blueGrey,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
            child: Text(
              'Loading Ad..',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        ],
      ),
    );
  }
}
