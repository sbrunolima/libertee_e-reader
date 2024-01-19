import 'package:flutter/foundation.dart';

//Objects
import 'app_settings.dart';
import '../helpers/settings_db.dart';

class SettingsProvider with ChangeNotifier {
  List<AppSettings> _appSettings = [];

  List<AppSettings> get appSettings {
    return [..._appSettings];
  }

  Future<void> addSettings(
      {required String nightMode, required String swipeHorizontal}) async {
    final timestamp = DateTime.now();

    SettingsDB.insertData(
      'app_settings',
      {
        'id': timestamp.toString().toLowerCase(),
        'nightMode': nightMode,
        'swipeHorizontal': swipeHorizontal,
      },
    );

    print('CREATED');
  }

  Future<void> loadAndSetSettings() async {
    final dataList = await SettingsDB.getData('app_settings');
    _appSettings = dataList
        .map(
          (settings) => AppSettings(
            id: settings['id'].toString().toLowerCase(),
            nightMode: settings['nightMode'].toString(),
            swipeHorizontal: settings['swipeHorizontal'].toString(),
          ),
        )
        .toList();

    notifyListeners();
  }

  Future<void> updateSettings(String id, AppSettings editedSettings) async {
    final settingsIndex =
        _appSettings.indexWhere((settings) => settings.id == id);
    if (settingsIndex >= 0) {
      SettingsDB.insertData(
        'app_settings',
        {
          'id': editedSettings.id.toString().toLowerCase(),
          'nightMode': editedSettings.nightMode.toString(),
          'swipeHorizontal': editedSettings.swipeHorizontal.toString(),
        },
      );

      print('EDITED');
      _appSettings[settingsIndex] = editedSettings;

      notifyListeners();
    } else {
      return;
    }
  }
}
