import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//Providers
import '../providers/settings_provider.dart';
import '../providers/app_settings.dart';
import '../language/app_language.dart';

//Widgets
import '../widgets/app_bar_titles.dart';
import '../settings screen/options_buttons.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String nightMode = '0';
  String swipeHorizontal = '0';
  var isLoading = false;

  var _newSettings = AppSettings(
    id: '',
    nightMode: '',
    swipeHorizontal: '',
  );

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Provider.of<SettingsProvider>(context, listen: false)
        .loadAndSetSettings()
        .then((_) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //Load the phone Locale
    //--------------------------------------------------------------------------
    final localeData = Provider.of<LanguageProvider>(context);
    final settingsData = Provider.of<SettingsProvider>(context, listen: false);
    final appSettings = settingsData.appSettings;

    if (appSettings.isNotEmpty) {
      setState(() {
        nightMode = appSettings[0].nightMode.toString();
        swipeHorizontal = appSettings[0].swipeHorizontal.toString();
      });
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: AppBarTitles(
            title: localeData.language[0].settings!.isNotEmpty
                ? localeData.language[0].settings!
                : 'Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titlesText(
                title: localeData.language[0].reading!.isNotEmpty
                    ? localeData.language[0].reading!
                    : 'Reading'),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                if (nightMode == '0') {
                  setState(() {
                    nightMode = '1';
                  });
                } else {
                  setState(() {
                    nightMode = '0';
                  });
                }

                _newSettings = AppSettings(
                  id: appSettings[0].id,
                  nightMode: nightMode,
                  swipeHorizontal: swipeHorizontal,
                );

                await Provider.of<SettingsProvider>(context, listen: false)
                    .updateSettings(appSettings[0].id, _newSettings);
              },
              child: optionsText(
                  localeData.language[0].nightMode!.isNotEmpty
                      ? localeData.language[0].nightMode!
                      : 'Night Mode',
                  nightMode),
            ),
            GestureDetector(
              onTap: () async {
                if (swipeHorizontal == '0') {
                  setState(() {
                    swipeHorizontal = '1';
                  });
                } else {
                  setState(() {
                    swipeHorizontal = '0';
                  });
                }
                _newSettings = AppSettings(
                  id: appSettings[0].id,
                  nightMode: nightMode,
                  swipeHorizontal: swipeHorizontal,
                );
                await Provider.of<SettingsProvider>(context, listen: false)
                    .updateSettings(appSettings[0].id, _newSettings);
              },
              child: optionsText(
                  localeData.language[0].swipeHorizontal!.isNotEmpty
                      ? localeData.language[0].swipeHorizontal!
                      : 'Swipe Horizontal',
                  swipeHorizontal),
            ),
            const SizedBox(height: 20),
            OptionsButtons(
              title: localeData.language[0].about!.isNotEmpty
                  ? localeData.language[0].about!
                  : 'About',
              content: localeData.language[0].aboutContent!.isNotEmpty
                  ? localeData.language[0].aboutContent!
                  : 'Leia os livros sem propagandas em qualquer lugar em um aplicativo leve e bonito.',
              isClickable: false,
            ),
            OptionsButtons(
              title: localeData.language[0].version!.isNotEmpty
                  ? localeData.language[0].version!
                  : 'Version',
              content: '1.0.0',
              isClickable: false,
            ),
            OptionsButtons(
              title: 'Premium',
              content: localeData.language[0].premiumContent!.isNotEmpty
                  ? localeData.language[0].premiumContent!
                  : 'Compre  o Libertee Premium e ajude no desenvolvimento e melhoria do APP.',
              isClickable: true,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget versiontext(String version) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        version,
        style: GoogleFonts.openSans(color: Colors.white),
      ),
    );
  }

  Widget titlesText({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Text(
        title,
        style: GoogleFonts.openSans(
          fontSize: 16,
          color: Colors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget optionsText(String option, String selected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            option,
            style: GoogleFonts.openSans(color: Colors.white),
          ),
          Icon(
            selected == '1'
                ? EneftyIcons.toggle_on_bold
                : EneftyIcons.toggle_off_outline,
            color: selected == '1' ? Colors.orange : Colors.white,
          ),
        ],
      ),
    );
  }
}
