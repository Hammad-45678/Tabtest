import 'package:flutter/material.dart';
import 'package:picstar/pages/home_screen/pages/home_page.dart';
import 'package:picstar/translation_manager/language_constants.dart';

class ObjectRemoveWidget extends StatelessWidget {
  const ObjectRemoveWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 18 : 12;
    return Container(
      height: getContainerHeight2(context),
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          side: BorderSide(
            width: 1, // Border width
            color: Colors.transparent, // Transparent color for the border
            style: BorderStyle.solid,
          ),
        ),
        gradient: LinearGradient(
          begin: Alignment(-1.00, 0.00),
          end: Alignment(1, 0),
          colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
        ),
      ),
      child: Stack(children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              'assets/images/moreoptimized.gif',
              height: getContainerHeight2(context),
              fit: BoxFit.cover,
            )),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              height: MediaQuery.of(context).size.height > 600 ? 20 : 15,
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.5),
                  child: Text(
                    localeText(
                      context,
                      'object_remover',
                    ),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w800,
                      height: 0.22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
