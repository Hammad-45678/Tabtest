import 'package:flutter/material.dart';
import 'package:picstar/translation_manager/language_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeBottomSheet extends StatefulWidget {
  const ThemeBottomSheet({super.key});

  @override
  State<ThemeBottomSheet> createState() => _ThemeBottomSheetState();
}

class _ThemeBottomSheetState extends State<ThemeBottomSheet> {
  int selectedValue = 1;
  late SharedPreferences _prefs;
  @override
  void initState() {
    super.initState();
    // Initialize SharedPreferences
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      // Retrieve the stored value or use a default value (1 in this case)
      selectedValue = _prefs.getInt('selectedTheme') ?? 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
              'app_theme',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 0,
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
            localeText(context, 'select_theme_of_your_app_which_you_prefer'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60),
          child: ListTile(
            title: Text(
              localeText(
                context,
                'system_default',
              ),
              style: const TextStyle(
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
              onChanged: (value) {
                setState(() {
                  _prefs.setInt('selectedTheme', selectedValue);
                  selectedValue = value as int;
                });
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
            title: Text(
              localeText(
                context,
                'light',
              ),
              style: const TextStyle(
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
              onChanged: (value) {
                setState(() {
                  _prefs.setInt('selectedTheme', selectedValue);
                  selectedValue = value as int;
                });
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
            title: Text(
              localeText(context, 'dark'),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 0,
                letterSpacing: 0.60,
              ),
            ),
            trailing: Radio(
              focusColor: Colors.white,
              value: 3,
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  _prefs.setInt('selectedTheme', selectedValue);
                  selectedValue = value as int;
                });
              },
              activeColor: const Color(0xFF8181FF),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                padding: EdgeInsets.symmetric(horizontal: 60),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: Colors.white),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context); // Close the BottomSheet
                },
                child: Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(horizontal: 60),
                  decoration: ShapeDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(-1.00, 0.00),
                      end: Alignment(1, 0),
                      colors: [Color(0xFF8181FF), Color(0xFFC74EC8)],
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
