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
    required this.searchTreeId
  });

  final WebUri initialUrl;
  final int searchTreeId;


  /// ユーザーがURLリクエストを送った時に行う処理
  NavigationActionPolicy shouldOverrideUrlLoadingProcess({
    required NavigationAction navigationAction,
    required ValueNotifier<WebUri> lastRequestUrl,
    required WebViewController webViewController,
    required ValueNotifier<WebUri> currentUrl
  }) {
    final requestUrl = navigationAction.request.url;
    if (requestUrl == null || lastRequestUrl.value == requestUrl) {
      return NavigationActionPolicy.ALLOW;
    }

    final navigationType = navigationAction.navigationType;
    if (navigationType == null) return NavigationActionPolicy.ALLOW;

    lastRequestUrl.value = requestUrl; // 1回のページ遷移時に同じURLリクエストが2回きてしまうことがあるためそれの回避

    if ([
      NavigationType.BACK_FORWARD,
      NavigationType.RELOAD,
      NavigationType.OTHER,
    ].contains(navigationType)) {
      // ユーザーが「戻る/進む」or「リロード」or「不明なアクション」を行った時はスキップする。
      currentUrl.value = requestUrl;
      return NavigationActionPolicy.ALLOW;
    }

    final navigationActionPolicy = webViewController.moreSearchIfNeeded(
        initialUrl: initialUrl.toString(),
        currentUrl: currentUrl.value.toString(),
        requestUrl: navigationAction.request.url.toString(),
        currentTreeId: searchTreeId);

    if (navigationActionPolicy == NavigationActionPolicy.ALLOW) {
      currentUrl.value = requestUrl;
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
            errorMessage.value = webResourceError.description;
            isLoadingNotifier.state = false;
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
                lastRequestUrl: lastRequestUrl,
                webViewController: instance,
                currentUrl: currentUrl);

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


