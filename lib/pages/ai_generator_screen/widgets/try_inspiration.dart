import 'package:flutter/material.dart';

class TryInspiration extends StatelessWidget {
  const TryInspiration({
    Key? key,
    required this.watchVideoCallback,
    required this.customText,
    required this.customImage,
  }) : super(key: key);

  final VoidCallback watchVideoCallback;

  final String customText;
  final ImageProvider customImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            width: 277.59,
            height: 386,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image(
                    image: customImage, // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
                // Positioned(
                //   bottom: 0,
                //   left: 0,
                //   right: 0,
                //   child: ShaderMask(
                //     shaderCallback: (Rect bounds) {
                //       return const LinearGradient(
                //         begin: Alignment.topCenter,
                //         end: Alignment.bottomCenter,
                //         colors: [
                //           Colors.transparent,
                //           Colors.black,
                //         ],
                //         stops: [
                //           0.9,
                //           1.0
                //         ], // Adjust the stops based on your preference
                //       ).createShader(bounds);
                //     },
                //     blendMode: BlendMode.dstOut,
                //     child: Container(
                //       height: 100,
                //       padding: const EdgeInsets.all(16),
                //       color: const Color(0xFF1E1E1E).withOpacity(0.7),
                //     ),
                //   ),
                // ),
                // Text Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10),
                        child: Text(
                          textAlign: TextAlign.center,
                          customText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10),
                        child: GestureDetector(
                          onTap: watchVideoCallback,
                          child: Container(
                            width: double.infinity,
                            height: 44,
                            decoration: ShapeDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment(-1.00, 0.00),
                                end: Alignment(1, 0),
                                colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: const Center(
                              child: Text(
                                'Try Now',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),
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
                        width: 20,
                        height: 20,
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
