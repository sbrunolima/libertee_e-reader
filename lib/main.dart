import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Screens
import './screens/start_screen.dart';

//Providers
import './providers/documents_provider.dart';
import './providers/settings_provider.dart';
import './language/app_language.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => DocumentsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => LanguageProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StartScreen(),
      ),
    );
  }
}
