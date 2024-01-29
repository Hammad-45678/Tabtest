import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RadioSelectionBottomSheet extends StatefulWidget {
  const RadioSelectionBottomSheet({super.key});

  @override
  _RadioSelectionBottomSheetState createState() =>
      _RadioSelectionBottomSheetState();
}

class _RadioSelectionBottomSheetState extends State<RadioSelectionBottomSheet> {
  bool ischecked = false;
  int selectedValue = 1; // Default selected value
  late SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _loadSelectedValue();
    });
  }

  Future<void> _loadSelectedValue() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      // Retrieve the stored value or use a default value (1 in this case)
      selectedValue = _prefs.getInt('selectedFormat') ?? 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        color: Color(0xFF222222),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 7),
            child: Center(
              child: Image(
                image: AssetImage('assets/icons/bottomSheetHandle.webp'),
                height: 5,
                width: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 20, right: 10),
            child: Text(
              localeText(
                context,
                'image_settings',
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.48,
              ),
            ),
          ),
          Image.asset(
            'assets/icons/divider.webp',
            width: double.infinity,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 10, bottom: 21, right: 10),
            child: Text(
              localeText(context, 'preferred_format_to_download_images'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: ListTile(
              title: const Text(
                'JPEG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: 0.60,
                ),
              ),
              trailing: Radio(
                value: 1,
                groupValue: selectedValue,
                onChanged: (value) async {
                  setState(() {
                    selectedValue = value as int;
                  });
                  await _prefs.setInt('selectedFormat', selectedValue);
                  print("Selected format saved: $selectedValue");
                },
                activeColor: const Color(0xFF8181FF),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Divider(
              color: Color(0xFF646464),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: ListTile(
              title: const Text(
                'PNG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 0,
                  letterSpacing: 0.60,
                ),
              ),
              trailing: Radio(
                value: 2,
                groupValue: selectedValue,
                onChanged: (value) async {
                  setState(() {
                    selectedValue = value as int;
                  });
                  await _prefs.setInt('selectedFormat', selectedValue);
                  print("Selected format saved: $selectedValue");
                },
                activeColor: const Color(0xFF8181FF),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Divider(
              color: Color(0xFF646464),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: ListTile(
              title: const Text(
                'WEBP',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.60,
                ),
              ),
              trailing: Radio(
                value: 3,
                groupValue: selectedValue,
                onChanged: (value) async {
                  setState(() {
                    selectedValue = value as int;
                  });
                  await _prefs.setInt('selectedFormat', selectedValue);
                  print("Selected format saved: $selectedValue");
                },
                activeColor: const Color(0xFF8181FF),
              ),
            ),
          ),
          const Row(
            children: [
              // child: InkWell(
              //   onTap: () {
              //     setState(() {
              //       ischecked = !ischecked;
              //     });
              //   },
              //   child: ischecked
              //       ? const Icon(
              //           Icons.check,
              //           color: Colors.white,
              //           size: 8,
              //         )
              //       : null,
              // )

              SizedBox(
                width: 5,
              ),
              // const Text(
              //   'Ask when downloading',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 12,
              //     fontWeight: FontWeight.w400,
              //   ),
              // )
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const CancelButton(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context); // Close the BottomSheet
                  },
                  child: const DoneButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 60),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Colors.white),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      child: Center(
        child: Text(
          localeText(
            context,
            'cancel',
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class DoneButton extends StatelessWidget {
  const DoneButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 60),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-1.00, 0.00),
          end: Alignment(1, 0),
          colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      child: Center(
          child: Text(
        localeText(
          context,
          'done',
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      )),
    );
  }
}
