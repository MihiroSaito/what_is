import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' show WebUri;


WebUri createUrl(String text, {bool isDirectUrl = false}) {
  if (isDirectUrl) {
    return WebUri(text);
  } else {
    return WebUri('https://www.google.co.jp/search?q=$text とは？');
  }
}


Future<String?> getClipboardText() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text; // 現在のクリップボードにあるワードを取得
}
