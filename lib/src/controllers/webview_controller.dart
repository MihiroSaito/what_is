import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/controllers/suggest_translate_controller.dart';

import '../providers/translation_confirmed_page_list.dart';

class WebViewController {


  NavigationActionPolicy checkLink(WidgetRef ref, {
    required String currentUrl,
    required String requestUrl,
  }) {
    final uri1 = Uri.parse(currentUrl);
    final uri2 = Uri.parse(requestUrl);

    if (_arePathsEqual(uri1, uri2)) {
      return NavigationActionPolicy.ALLOW;
    } else {
      print('違う記事へ遷移しようとしている');
      return NavigationActionPolicy.CANCEL; //TODO: ここの判断がむずいためどうにかする。
    }

  }


  /// パスが一致し、クエリとフラグメントが異なる場合は差分ありと判断し、trueを返す
  bool _arePathsEqual(Uri uri1, Uri uri2) {
    return uri1.path == uri2.path &&
        uri1.query == uri2.query &&
        uri1.fragment == uri2.fragment;
  }



  /// 必要であればサイトを翻訳する処理を実行する。
  Future<void> translateIfNeeded(WidgetRef ref, {
    required InAppWebViewController controller,
    required WebUri uri
  }) async {
    // WebView内でJavaScriptを実行して言語情報を取得
    String script = '''
              var lang = document.documentElement.lang;
              lang;
            ''';
    final language = await controller.evaluateJavascript(source: script);

    // 翻訳するかすでに確認しているサイトの場合スキップする
    if (ref.watch(translationConfirmedPageListProvider).contains(uri.toString())){
      return;
    }
    if (language != 'ja') {
      //TODO: 自動翻訳するかどうかで処理を変える。
      SuggestTranslateController.show(ref,
        onEnabled: (alwaysEnabled) {
          //TODO: 次回から自動保存する設定にする。
          controller.loadUrl(urlRequest: URLRequest(
              url: WebUri('https://translate.google.com/translate?sl=auto&tl=ja&hl=ja&u=$uri')
          ));
        }
      );
      ref.read(translationConfirmedPageListProvider.notifier).add(uri.toString());
    }

  }


}
