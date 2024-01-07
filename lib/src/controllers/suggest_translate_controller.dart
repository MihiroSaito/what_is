import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/app_header.dart';
import 'package:what_is/src/components/suggest_transplate_toast_widget.dart';
import 'package:what_is/src/providers/translation_confirmed_page_list.dart';

import '../../main.dart';


class SuggestTranslateController {

  static FlashController<Object?>? _flashController;

  static Future<void> show(WidgetRef ref, {required AlwaysEnabled onEnabled}) async {
    _flashController?.dismiss();
    await App.navigatorKey.currentContext!.showFlash(
        transitionDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 5550000), //TODO: 5500にもどす
        builder: (_, controller) {

          _flashController = controller;

          return FlashBar(
            controller: controller,
            behavior: FlashBehavior.floating,
            position: FlashPosition.top,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            padding: EdgeInsets.zero,
            forwardAnimationCurve: Curves.elasticOut,
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0 + 56),
            content: SuggestTranslateToastWidget(
              onEnabled: (bool alwaysEnabled) {
                onEnabled(alwaysEnabled);
                _flashController?.dismiss();
              },
              onKept: () => _flashController?.dismiss(),
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
