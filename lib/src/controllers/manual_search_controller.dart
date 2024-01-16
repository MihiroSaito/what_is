import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/search_textfield.dart';
import 'package:what_is/src/routing/navigator.dart';
import 'package:what_is/src/views/main_screen.dart';

import '../../main.dart';


class ManualSearchController {

  static FlashController<Object?>? _flashController;

  static Future<void> show() async {
    if (_flashController != null) return;
    await App.navigatorKey.currentContext!.showFlash(
        transitionDuration: const Duration(milliseconds: 200),
        builder: (_, controller) {

          _flashController = controller;

          return FlashBar(
            controller: controller,
            behavior: FlashBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            insetAnimationDuration: const Duration(milliseconds: 100),
            insetAnimationCurve: Curves.decelerate,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            padding: EdgeInsets.zero,
            forwardAnimationCurve: Curves.easeInOut,
            content: Consumer(
              builder: (_, ref, __) {
                return SearchTextField(
                  onSubmit: (text) {
                    _flashController!.dismiss();
                    if (text.isNotEmpty) {
                      AppNavigator.toSearchView(ref, searchText: text);
                    }
                  },
                );
              }
            ),
          );
        }
    ).then((value) => _flashController = null);
  }


  static void pop() {
    if (_flashController != null) {
      _flashController?.dismiss();
    }
  }

}
