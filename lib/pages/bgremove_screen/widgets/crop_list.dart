import 'package:flutter/material.dart';

class CropList extends StatefulWidget {
  const CropList({
    super.key,
  });

  @override
  State<CropList> createState() => _CropListState();
}

class _CropListState extends State<CropList> {
  String selectedCropType = 'crop5';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Row(
          children: [
            Image(
              image: AssetImage('assets/icons/close_icon.webp'),
              width: 10,
              height: 10,
            ),
            Image(
              image: AssetImage('assets/icons/divider_small.webp'),
              width: 25,
              height: 25,
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
        Column(
          children: [
            GestureDetector(
              onTap: () {
                applyCrop('crop1');
              },
              child: const Image(
                image: AssetImage('assets/icons/crop5.webp'),
                width: 25,
                height: 25,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              'Crop',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const Column(
          children: [
            Image(
              image: AssetImage('assets/icons/crop1.webp'),
              width: 25,
              height: 25,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add Text',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const Column(
          children: [
            Image(
              image: AssetImage('assets/icons/crop2.webp'),
              width: 25,
              height: 25,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add Text',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const Column(
          children: [
            Image(
              image: AssetImage('assets/icons/crop3.webp'),
              width: 25,
              height: 25,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add Text',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
        const Column(
          children: [
            Image(
              image: AssetImage('assets/icons/crop4.webp'),
              width: 25,
              height: 25,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Add Text',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ],
    );
  }

  void applyCrop(String cropType) {
    // Add your cropping logic here using the provided crop type
    print('Applying crop with type: $cropType');
    setState(() {
      selectedCropType = cropType;
    });
  }
}
