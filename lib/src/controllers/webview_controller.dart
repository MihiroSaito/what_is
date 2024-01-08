import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/controllers/suggest_translate_controller.dart';

import '../providers/display_web_page_index_provider.dart';
import '../providers/translation_confirmed_page_list.dart';
import '../providers/web_pages_provider.dart';
import '../providers/webview_controllers_provider.dart';

class WebViewController {

  WebViewController(this.ref);
  final Ref ref;

  /// 「さらに検索」機能の実行が必要だったら行う。不要だったらWebViewの挙動にしたがって画面遷移する。
  NavigationActionPolicy moreSearchIfNeeded( {
    required String initialUrl,
    required String currentUrl,
    required String requestUrl,
    required int currentTreeId,
  }) {

    final uri1 = Uri.parse(initialUrl);
    final uri2 = Uri.parse(currentUrl);
    final uri3 = Uri.parse(requestUrl);

    // 最初のGoogle検索からの遷移はWebViewの挙動にしたがって画面遷移する。
    if (_arePathsEqual(uri1, uri2)) return NavigationActionPolicy.ALLOW;

    // URLパスが同じ = 現在のページと同じコンテンツのため「さらに検索」機能に実行をスキップする
    if (_arePathsEqual(uri2, uri3)) {
      return NavigationActionPolicy.ALLOW;
    } else {
      moreSearch(
          currentTreeId: currentTreeId,
          searchWordOrUrl: requestUrl,
          isUrl: true); // パスが違ったら「さらに検索」機能を使ってページを開く
      return NavigationActionPolicy.CANCEL;
    }

  }


  /// パスが一致し、クエリとフラグメントが異なる場合は差分ありと判断し、trueを返す
  bool _arePathsEqual(Uri uri1, Uri uri2) {
    return uri1.path == uri2.path;
  }


  /// Webページを翻訳してくれるWebページを生成する。
  String generateTranslateSiteUrl(String url) {
    return 'https://translate.google.com/translate?sl=auto&tl=ja&hl=ja&u=$url';
  }


  /// 必要であればサイトを翻訳する処理を実行する。
  Future<void> translateIfNeeded({
    required InAppWebViewController controller,
    required WebUri uri
  }) async {
    // WebView内でJavaScriptを実行して言語情報を取得
    const script = '''
              var lang = document.documentElement.lang;
              lang;
            ''';
    final String language = await controller.evaluateJavascript(source: script) ?? "";

    debugPrint('site language: $language');

    final translateSiteUrl = generateTranslateSiteUrl(uri.toString());

    // 何も取得できなかった OR 翻訳するかすでに確認しているサイトの場合スキップする
    final list = ref.read(translationConfirmedPageListProvider);
    if (language.isEmpty || list.contains(uri.toString()) || list.contains(translateSiteUrl)){
      return;
    }

    if (!language.contains('ja')) {
      //TODO: 自動翻訳するかどうかで処理を変える。
      SuggestTranslateController.show(
        onEnabled: (alwaysEnabled) {
          //TODO: 次回から自動保存する設定にする。
          controller.loadUrl(urlRequest: URLRequest(
              url: WebUri(translateSiteUrl)
          ));
        }
      );
      ref.read(translationConfirmedPageListProvider.notifier).add(uri.toString());
      ref.read(translationConfirmedPageListProvider.notifier).add(translateSiteUrl); // 翻訳済みサイトのURLも念の為。
    }

  }


  /// 「さらに検索」機能の処理
  void moreSearch({
    required int currentTreeId,
    required String searchWordOrUrl,
    required bool isUrl
  }) {
    final newPage = ref.read(webPagesProvider.notifier).add(
        parentTreeId: currentTreeId,
        searchWordOrUrl: searchWordOrUrl,
        isUrl: isUrl);
    ref.read(displayWebPageIndexProvider.notifier).change(index: newPage.indexedStackIndex);
  }


  /// 「あとで検索」機能の処理
  void afterSearch({
    required int currentTreeId,
    required String searchWordOrUrl,
    required bool isUrl
  }) {
    if (ref.runtimeType == (AutoDisposeProviderRef<ContextMenu>) || ref.runtimeType == WidgetRef) {
      ref.read(webPagesProvider.notifier).add(
          parentTreeId: currentTreeId,
          searchWordOrUrl: searchWordOrUrl,
          isUrl: isUrl
      );
    }
  }


}
