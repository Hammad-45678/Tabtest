import 'package:flutter/material.dart';

class GeneralSettingContainer extends StatefulWidget {
  final String leadingicon;
  final String text;
  final IconData? trailingicon;
  VoidCallback onpressed;
  GeneralSettingContainer(
      {super.key,
      required this.leadingicon,
      required this.text,
      this.trailingicon,
      required this.onpressed});
  @override
  State<GeneralSettingContainer> createState() =>
      _GeneralSettingContainerState();
}

class _GeneralSettingContainerState extends State<GeneralSettingContainer> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth > 600 ? 20 : 12;
    return Column(
      children: [
        GestureDetector(
          onTap: widget.onpressed,
          child: ListTile(
            leading: Image.asset(
              widget.leadingicon,
              height: MediaQuery.of(context).size.width > 600 ? 30 : 20,
            ),
            title: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: 0.60,
              ),
            ),
            trailing: Icon(
              widget.trailingicon,
              color: Colors.white,
              size: 15,
            ),
          ),
        ),
        const Divider(color: Color(0xFF646464))
      ],
    );
  }
}
