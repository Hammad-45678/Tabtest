import 'dart:ui';
import 'package:hive/hive.dart';

class LocaleAdapter extends TypeAdapter<Locale> {
  @override
  final typeId = 2;

  @override
  Locale read(BinaryReader reader) {
    final languageCode = reader.read();
    final countryCode = reader.read();
    return Locale(languageCode, countryCode);
  }

  @override
  void write(BinaryWriter writer, Locale obj) {
    writer.write(obj.languageCode);
    writer.write(obj.countryCode);
  }
}
