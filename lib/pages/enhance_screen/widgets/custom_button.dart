import 'package:flutter/material.dart';

class UploadButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final String imagePath;

  const UploadButton({super.key, 
    required this.buttonText,
    required this.onPressed,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 90, // Adjust the height as needed
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF8181FF),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(double.infinity, 45),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,

              height: 30, // Adjust the size of the icon as needed
            ),
            const SizedBox(
                height:
                    5), // Adjust the spacing between icon and text as needed
            Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
