import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' show WebUri;


WebUri createUrl(String text, {bool isUrl = false, List<String> option = const []}) {
  if (isUrl) {
    return WebUri(text);
  } else {
    if (option.isNotEmpty) {
      return WebUri('https://www.google.co.jp/search?q=$text とは ${option.first}');
    } else {
      return WebUri('https://www.google.co.jp/search?q=$text とは');
    }
  }
}


Future<String?> getClipboardText() async {
  final data = await Clipboard.getData(Clipboard.kTextPlain);
  return data?.text; // 現在のクリップボードにあるワードを取得
}
