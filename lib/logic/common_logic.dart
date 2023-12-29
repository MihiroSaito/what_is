import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/logic/notifier.dart';
import 'package:what_is/logic/word_history.dart';

import '../component/search_again_toast_widget.dart';
import '../component/webivew.dart';

WebUri createUrl(String text) {
  return WebUri('https://www.google.co.jp/search?q=$text とは？');
}


FlashController<Object?>? _flashController;

Future<void> showSearchAgainToast(BuildContext context, WidgetRef ref, {required EdgeInsets safeAreaPadding}) async {
  final String? text = await getClipboardText(); // 現在のクリップボードにあるワードを取得
  if (text == null) return;
  if (!(_flashController?.controller.isCompleted ?? true)) return;
  await context.showFlash(
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
            safeAreaPadding: safeAreaPadding,
            onTap: () {
              ref.read(webViewPagesProvider.notifier).state = [];
              ref.read(wordHistoryProvider.notifier).clearAndAdd(WordHistory(word: text, url: createUrl(text).toString()));
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (__) => AppWebViewPages(
                    firstPageWord: text,
                    safeAreaPadding: safeAreaPadding,
                  ))
              );
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



Future<String?> getClipboardText() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text; // 現在のクリップボードにあるワードを取得
}
