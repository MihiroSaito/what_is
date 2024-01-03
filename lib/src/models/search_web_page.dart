import '../views/webivew.dart';

class SearchWebPage {

  /// 検索画面のIndexedStackウィジェットのIndexに使用する値
  ///
  final int indexedStackIndex;

  /// 検索した時のワード
  ///
  final String searchWord;

  /// 検索の最初に利用したURL
  ///
  final String initUrl;

  /// WeViewウィジェット
  ///
  final AppWebView webViewWidget;

  const SearchWebPage({
    required this.indexedStackIndex,
    required this.searchWord,
    required this.initUrl,
    required this.webViewWidget
  });
}
