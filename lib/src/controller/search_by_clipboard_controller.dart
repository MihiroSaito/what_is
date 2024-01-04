import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/routing/navigator.dart';

import '../components/search_again_toast_widget.dart';
import '../../main.dart';
import '../utils/util.dart';
import '../views/webivew.dart';


class SearchByClipBoardController {

  static FlashController<Object?>? _flashController;

  Future<void> show(BuildContext context, WidgetRef ref) async {
    final String? text = await getClipboardText(); // 現在のクリップボードにあるワードを取得
    if (text == null) return;
    if (!(_flashController?.controller.isCompleted ?? true)) return;
    await App.navigatorKey.currentContext!.showFlash(
        transitionDuration: const Duration(milliseconds: 500),
        duration: const Duration(milliseconds: 5500),
        builder: (_, controller) {

          _flashController = controller;

          return FlashBar(
            controller: controller,
            behavior: FlashBehavior.floating,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            padding: EdgeInsets.zero,
            forwardAnimationCurve: Curves.elasticOut,
            margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: WebViewBottomBar.height + 16.0,),
            content: SearchAgainToastWidget(
              word: text,
              onTap: () {
                AppNavigator().toSearchView(context, ref, searchText: text);
                _flashController?.dismiss();
              },
            ),
          );
        }
    ).then((value) => _flashController = null);
  }


  void pop() {
    if (_flashController != null) {
      print('vdsv');
      _flashController?.dismiss();
    }
  }

}
