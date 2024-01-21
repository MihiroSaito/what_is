import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/views/main_screen.dart';

import 'firebase_options.dart';
import 'src/config/theme.dart';
import 'src/utils/util.dart';


Color accentColor = const Color(0xFF001AFF);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: App()));
}



class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'what is',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      supportedLocales: const [Locale('ja', 'JP')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      navigatorKey: navigatorKey,
      home: const MainScreen(),
    );
  }
}
