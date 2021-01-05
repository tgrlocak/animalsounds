class Language {
  String code;
  String name;

  Language({
    this.code,
    this.name
  });

  static List<Language> languages() {
    return [
      Language(code: 'tr', name: 'Türkçe'),
      Language(code: 'en', name: 'English'),
      // Language(code: 'de', name: 'Deutsch'),
      // Language(code: 'fr', name: 'French'),
    ];
  }
}