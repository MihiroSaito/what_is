import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppTheme {

  static final light = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
            color: Color(0xFF333333)
        )
    ),
    iconTheme: const IconThemeData(
        color: Color(0xFF333333)
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }
    ),
  );


  static final dark = ThemeData(
    scaffoldBackgroundColor: darkColor3,
    textTheme: const TextTheme(
        bodyMedium: TextStyle(
            color: Colors.white
        )
    ),
    iconTheme: const IconThemeData(
        color: Colors.white
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        }
    ),
  );


  static bool isDarkMode() {
    var brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }



  static const darkColor1 = Color(0xFF333333);
  static const darkColor2 = Color(0xFF232425);
  static const darkColor3 = Color(0xFF0B0F12);

  static const lightColor1 = Color(0xFFEFF5FA);

}
