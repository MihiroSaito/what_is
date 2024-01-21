import 'package:flutter/material.dart';

import '../../main.dart';
import '../views/how_to_use_screen.dart';

class HowToUseController {

  void show() {
    //TODO: 続きやる
    showModalBottomSheet(
        enableDrag: true,
        context: App.navigatorKey.currentContext!,
        builder: (_) {
          return const HowToUseScreen();
        }
    );
  }

}
