import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/search_again_toast_widget.dart';
import '../../main.dart';
import '../utils/util.dart';
import '../views/webivew.dart';


class SearchByClipBoardController {

  FlashController<Object?>? _flashController;

  Future<void> showSearchAgainToast() async {
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
                //TODO: 検索画面へ画面遷移する
                _flashController?.dismiss();
              },
            ),
          );
        }
    ).then((value) => _flashController = null);
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.heavyImpact();
  }

}
