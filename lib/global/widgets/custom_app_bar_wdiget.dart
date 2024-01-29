import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/localization_provider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Widget firstleadingImage;
  final Widget secondleadingImage;
  final Widget title;
  final Widget? trailingImage;
  final VoidCallback onPressed;

  const CustomAppBar({
    super.key,
    required this.height,
    required this.firstleadingImage,
    required this.secondleadingImage,
    required this.title,
    this.trailingImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    double appBarHeight = height - 1;
    return Consumer<LocalizationProvider>(
        builder: (context, localizationProvider, child) {
      return SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: appBarHeight,
              child: PreferredSize(
                preferredSize: Size.fromHeight(height),
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: onPressed,
                            child: localizationProvider.checkIsArOrUr()
                                ? secondleadingImage
                                : firstleadingImage),
                        Expanded(child: Container()),
                        title,
                        Expanded(child: Container()),
                        if (trailingImage != null) trailingImage!,
                      ],
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 1,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.00, 0.00),
                  end: Alignment(1, 0),
                  colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
