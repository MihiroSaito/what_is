import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/components/text_button.dart';
import 'package:what_is/src/config/theme.dart';

import '../controllers/webview_controller.dart';
import '../providers/content_menu_provider.dart';
import '../providers/loading_webview_provider.dart';
import '../providers/translation_confirmed_page_list.dart';
import '../providers/webview_controllers_provider.dart';

class AppWebView extends HookConsumerWidget {
  const AppWebView({
    super.key,
    required this.initialUrl,
    required this.searchTreeId,
    required this.hasSearchWord
  });

  final WebUri initialUrl;
  final int searchTreeId;

  /// 検索ワードがある = URL直アクセスではない
  final bool hasSearchWord;

  /// ユーザーがURLリクエストを送った時に行う処理
  NavigationActionPolicy shouldOverrideUrlLoadingProcess({
    required NavigationAction navigationAction,
    required ValueNotifier<WebUri> lastRequestPageUrl,
    required WebViewController webViewController,
    required ValueNotifier<WebUri> currentPageUrl,
    required bool hasSearchWord
  }) {
    // メインフレーム（画面全体を読み込む時 = 新規ページへのアクセス）以外のリクエストは特に何もしない。
    if (!navigationAction.isForMainFrame) return NavigationActionPolicy.ALLOW;

    final requestUrl = navigationAction.request.url;

    //TODO: ホームでの処理なら、Google検索結果画面で再度Google検索していないか確認する、していたらSearchViewを閉じ再度アプリ上で検索する

    // リクエストURLがnull、または最後のメインフレームへのアクセスと現在のメインフレームへのアクセスでURLが一致していたら何もしない。1回のページ遷移時に同じURLリクエストが2回きてしまうことがあるためそれの回避
    if (requestUrl == null || lastRequestPageUrl.value == requestUrl) {
      return NavigationActionPolicy.ALLOW;
    }
    lastRequestPageUrl.value = requestUrl;

    // 画面遷移のタイプがないことはほとんどなさそうだが、そんな時は特に何もしない。
    final navigationType = navigationAction.navigationType;
    if (navigationType == null) return NavigationActionPolicy.ALLOW;

    // ユーザーが「戻る/進む」を行った時は何もしない。ただし、ページURLは切り替わるため「現在のページURL」を変更する
    if (navigationType == NavigationType.BACK_FORWARD) {
      currentPageUrl.value = requestUrl;
      return NavigationActionPolicy.ALLOW;
    }

    //TODO: リダイレクトに対応できないため、仕様を変更する

    //TODO: Androidで戻るボタンを押した時の処理が必要になるかも

    // 「さらに検索」が必要なアクセスなら実行する。hasSearchWordがある = URL直アクセスではない ため初回の「さらに検索」はスキップする
    final navigationActionPolicy = webViewController.moreSearchIfNeeded(
        initialPageUrl: initialUrl.toString(),
        currentPageUrl: currentPageUrl.value.toString(),
        requestPageUrl: navigationAction.request.url.toString(),
        currentTreeId: searchTreeId,
        skipInitNavigation: hasSearchWord);

    // このWebViewでの画面遷移が行われるなら、ページURLが切り替わるため「現在のページURL」を変更する
    if (navigationActionPolicy == NavigationActionPolicy.ALLOW) {
      currentPageUrl.value = requestUrl;
    }

    return navigationActionPolicy;
  }



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoadingNotifier = ref.watch(isLoadingWebViewProvider.notifier);
    ref.watch(translationConfirmedPageListProvider);
    final instance = ref.watch(Provider(WebViewController.new));
    final currentUrl = useState(initialUrl);
    final lastRequestUrl = useState(initialUrl);
    final errorMessage = useState<String?>(null);

    return Stack(
      children: [
        InAppWebView(
          initialUrlRequest: URLRequest(url: initialUrl),
          initialSettings: InAppWebViewSettings(
            transparentBackground: true,
            javaScriptEnabled: true,
            allowsLinkPreview: false,
          ),
          contextMenu: ref.watch(contextMenuProvider(searchTreeId)),
          onLoadStart: (_, __) {
            isLoadingNotifier.state = true;
            errorMessage.value = null;
          },
          onLoadStop: (controller, uri) async {
            isLoadingNotifier.state = false;
            if (uri == null) return;
            instance.translateIfNeeded(controller: controller, uri: uri);
          },
          onReceivedError: (_, __, webResourceError) {
            // リロードしまくったり素早くブラウザバックした時に起こるエラーは無視
            if (webResourceError.type != WebResourceErrorType.CANCELLED) {
              debugPrint('webResourceError.type: ${webResourceError.type}');
              errorMessage.value = webResourceError.description;
              isLoadingNotifier.state = false;
            }
          },
          onWebViewCreated: (controller) {
            ref.read(webViewControllersProvider.notifier).add(
                (searchTreeId: searchTreeId, controller: controller));
          },
          onUpdateVisitedHistory: (controller, __, ___) async {
            //TODO: 閲覧履歴を取得してデータ活用にする。
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            return shouldOverrideUrlLoadingProcess(
                navigationAction: navigationAction,
                lastRequestPageUrl: lastRequestUrl,
                webViewController: instance,
                currentPageUrl: currentUrl,
                hasSearchWord: hasSearchWord);

          },
        ),


        if (errorMessage.value != null)
          _ErrorView(errorMessage: errorMessage.value!, onTapBackButton: () {

          }),

      ],
    );
  }

}





class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.errorMessage, required this.onTapBackButton});
  final String errorMessage;
  final VoidCallback onTapBackButton;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.xmark_circle_fill,
                color: const Color(0xFFEB3535).withOpacity(0.8),
                size: 48,
              ),
              const SizedBox(height: 16.0,),
              const Text(
                'このページにアクセスできません',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              AppTextButton(
                  '詳細を見る',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                  onTap: () {
                    showDialog(context: context, builder: (_) {
                      return Center(
                        child: Container(
                          width: 240,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: SelectableText(errorMessage, textAlign: TextAlign.center,),
                        ),
                      );
                    });
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}


