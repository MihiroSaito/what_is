import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../component/search_again_toast_widget.dart';
import '../component/webivew.dart';

WebUri createUrl(String text) {
  return WebUri('https://www.google.co.jp/search?q=$text とは？');
}



Future<void> showSearchAgainToast(BuildContext context) async {
  final String? text = await getClipboardText(); // 現在のクリップボードにあるワードを取得
  if (text == null) return;
  await context.showFlash(
      transitionDuration: const Duration(milliseconds: 500),
      duration: const Duration(milliseconds: 5500),
      builder: (context, controller) {
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
          content: SearchAgainToastWidget(word: text,),
        );
      }
  );
  await HapticFeedback.heavyImpact();
  await Future.delayed(const Duration(milliseconds: 500));
  await HapticFeedback.heavyImpact();
}



Future<String?> getClipboardText() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text; // 現在のクリップボードにあるワードを取得
}
