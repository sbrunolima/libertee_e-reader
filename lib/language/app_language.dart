import 'package:flutter/foundation.dart';

class Language {
  final String? locale;
  final String? home;
  final String? library;
  final String? settings;
  final String? reading;
  final String? nightMode;
  final String? swipeHorizontal;
  final String? about;
  final String? version;
  final String? progress;
  final String? aboutContent;
  final String? premiumContent;
  final String? deleteContent;
  final String? deleteButton;
  final String? cancelButton;

  Language({
    required this.locale,
    required this.home,
    required this.library,
    required this.settings,
    required this.reading,
    required this.nightMode,
    required this.swipeHorizontal,
    required this.about,
    required this.version,
    required this.progress,
    required this.aboutContent,
    required this.premiumContent,
    required this.deleteContent,
    required this.deleteButton,
    required this.cancelButton,
  });
}

class LanguageProvider with ChangeNotifier {
  List<Language> _language = [];

  List<Language> get language {
    return [..._language];
  }

  Future<void> setLanguage(String selectedLang) async {
    final List<Language> loadedLanguage = [];
    if (selectedLang == 'pt_BR') {
      loadedLanguage.add(
        Language(
          locale: "pt_BR",
          home: "Lendo",
          library: 'Biblioteca',
          settings: "Configuração",
          reading: "Leitura",
          nightMode: 'Modo Noturno',
          swipeHorizontal: 'Deslize Horizontal',
          about: 'Sobre',
          version: 'Versão',
          progress: 'Progresso',
          aboutContent:
              'Leia os livros sem propagandas em qualquer lugar em um aplicativo leve e bonito.',
          premiumContent: 'Obrigado por adquirir a versão Premium.',
          deleteContent: 'Deletar PDF?',
          deleteButton: 'Deletar',
          cancelButton: 'Cancelar',
        ),
      );
    } else {
      loadedLanguage.add(
        Language(
          locale: "en_US",
          home: "Reading",
          library: 'Library',
          settings: "Settings",
          reading: "Reading",
          nightMode: 'Night Mode',
          swipeHorizontal: 'Horizontal Swipe',
          about: 'About',
          version: 'Version',
          progress: 'Progress',
          aboutContent:
              'Read books without annoying advertisements anywhere in a light and beautiful application.',
          premiumContent: 'Thank you for purchasing the Premium version.',
          deleteContent: 'Delete PDF?',
          deleteButton: 'Delete',
          cancelButton: 'Cancel',
        ),
      );
    }

    _language = loadedLanguage.toList();
    notifyListeners();
  }
}
