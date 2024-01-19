import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

//Screens
import '../screens/home_screen.dart';
import '../screens/all_books_screen.dart';
import '../screens/settings screen.dart';

//Providers
import '../providers/settings_provider.dart';
import '../language/app_language.dart';

class StartScreen extends StatefulWidget {
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  //Get the phone default language
  final String defaultLocale = Platform.localeName;
  bool isLoading = false;
  int pageIndex = 0;

  final screens = [
    HomeScreen(),
    AllBooksScreen(),
    SettingsScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    Provider.of<LanguageProvider>(context, listen: false)
        .setLanguage(defaultLocale);

    Provider.of<SettingsProvider>(context).loadAndSetSettings();

    final settingsData = Provider.of<SettingsProvider>(context, listen: false);

    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (settingsData.appSettings.isEmpty) {
        Provider.of<SettingsProvider>(context, listen: false)
            .addSettings(nightMode: '0', swipeHorizontal: '0');
      }
    });
  }

  void loading() async {}

  @override
  Widget build(BuildContext context) {
    //Load the phone Locale
    //--------------------------------------------------------------------------
    final localeData = Provider.of<LanguageProvider>(context);
    //--------------------------------------------------------------------------

    return WillPopScope(
      onWillPop: () async {
        if (pageIndex == 0) {
          //If the indexs is zero and the user press the andoid back button,
          //the app closes
          SystemNavigator.pop();
        } else {
          //If the page index is not zero and the user press the andoid back button,
          //it will return to page index zero
          setState(() {
            pageIndex = 0;
          });
        }

        return false;
      },
      child: Scaffold(
        extendBody: true,
        body: screens[pageIndex],
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.orange.shade900),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              child: BottomNavigationBar(
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.black,
                unselectedLabelStyle:
                    GoogleFonts.openSans(color: Colors.black, fontSize: 10),
                selectedLabelStyle:
                    GoogleFonts.openSans(color: Colors.white, fontSize: 12),
                elevation: 0,
                currentIndex: pageIndex,
                onTap: (value) {
                  setState(() {
                    pageIndex = value;
                  });
                },
                backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      EneftyIcons.book_outline,
                      color: Colors.black,
                    ),
                    activeIcon: Icon(
                      EneftyIcons.book_bold,
                      color: Colors.white,
                    ),
                    label: localeData.language[0].home!.isNotEmpty
                        ? localeData.language[0].home!
                        : 'Reading',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      EneftyIcons.color_swatch_outline,
                      color: Colors.black,
                    ),
                    activeIcon: Icon(
                      EneftyIcons.color_swatch_bold,
                      color: Colors.white,
                    ),
                    label: localeData.language[0].library!.isNotEmpty
                        ? localeData.language[0].library!
                        : 'Library',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      EneftyIcons.setting_3_outline,
                      color: Colors.black,
                    ),
                    activeIcon: Icon(
                      EneftyIcons.setting_3_bold,
                      color: Colors.white,
                    ),
                    label: localeData.language[0].settings!.isNotEmpty
                        ? localeData.language[0].settings!
                        : 'Settings',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
