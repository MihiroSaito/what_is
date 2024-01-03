import 'package:flutter_inappwebview/flutter_inappwebview.dart' show WebUri;


WebUri createUrl(String text) {
  return WebUri('https://www.google.co.jp/search?q=$text とは？');
}
