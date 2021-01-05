class Translation {
  Map<String, Map<String, String>> translations;

  Translation._privateConstructor();

  static final Translation instance = Translation._privateConstructor();

  void fillTranslations() {
    this.translations = Map();

    this.translations["tr"] = {
      "title": "Hayvan Sesleri",
      "attention": "Dikkat",
      "exit_phrase" : "Uygulamadan çıkmak istediğinize emin misiniz?",
      "cancel": "İptal",
      "close": "Kapat"
    };

    this.translations["en"] = {
      "title": "Animal Sounds",
      "attention": "Attention",
      "exit_phrase" : "Exit application?",
      "cancel": "Cancel",
      "close": "Exit"
    };

    this.translations["de"] = {
      "title": "Tiergeräusche",
      "attention": "Beachtung",
      "exit_phrase" : "Möchten Sie die Anwendung wirklich beenden?",
      "cancel": "Stornieren",
      "close": "Schließen"
    };

    this.translations["fr"] = {
      "title": "Sons d'animaux",
      "attention": "Attention",
      "exit_phrase" : "Voulez-vous vraiment quitter l'application?",
      "cancel": "Annuler",
      "close": "Sortie"
    };
  }

}