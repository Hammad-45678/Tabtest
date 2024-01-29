class Languages {
  int id;
  String name;
  String flag;
  String languageCode;
  Languages(this.id, this.name, this.flag, this.languageCode);

  static List<Languages> languages = [
    Languages(1, "english", "en", "en"),
    Languages(2, "urdu", "ur", "ur"),
    Languages(25, "hindi", "in", "hi"),
    Languages(3, "bengali", "bn", "bn"),
    Languages(4, "arabic", "ar", "ar"),
    Languages(5, "chinese", "cz", "zh"),
    Languages(6, "french", "fr", "fr"),
    Languages(7, "indonesian", "id", "id"),
    Languages(8, "german", "gr", "de"),
    Languages(9, "dutch", "nl", "nl"),
    Languages(10, "italian", "it", "it"),
    Languages(11, "japanese", "ja", "ja"),
    Languages(12, "korean", "ko", "ko"),
    Languages(13, "persian", "fa", "fa"),
    Languages(14, "polish", "pl", "pl"),
    Languages(15, "portuguese", "pt", "pt"),
    Languages(16, "russian", "ru", "ru"),
    Languages(17, "spanish", "es", "es"),
    Languages(19, "swedish", "sv", "sv"),
    Languages(20, "tamil", "ta", "ta"),
    Languages(21, "thai", "th", "th"),
    Languages(22, "turkish", "tr", "tr"),
    Languages(23, "ukrainian", "uk", "uk"),
    Languages(24, "vietnamese", "vi", "vi"),
  ];
}
