import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoadingNotifier = ref.watch(isLoadingWebViewProvider.notifier);
    ref.watch(translationConfirmedPageListProvider);
    final webViewController = ref.watch(Provider(WebViewController.new));
    final currentUrl = useState(initialUrl);

    return InAppWebView(
      initialUrlRequest: URLRequest(url: initialUrl),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        javaScriptEnabled: true,
        allowsLinkPreview: false,
      ),
      contextMenu: ref.watch(contextMenuProvider(searchTreeId)),
      onLoadStart: (_, __) => isLoadingNotifier.state = true,
      onLoadStop: (controller, uri) async {
        isLoadingNotifier.state = false;
        if (uri == null) return;
        webViewController.translateIfNeeded(controller: controller, uri: uri);
      },
      onWebViewCreated: (controller) {
        ref.read(webViewControllersProvider.notifier).add(
            (searchTreeId: searchTreeId, controller: controller));
      },
      onUpdateVisitedHistory: (controller, __, ___) async {
        //TODO: 閲覧履歴を取得してデータ活用にする。
      },
      shouldOverrideUrlLoading: (controller, navigationAction) async {
        final requestUrl = navigationAction.request.url;
        if (requestUrl == null) return NavigationActionPolicy.ALLOW;
        if (!navigationAction.isForMainFrame) return NavigationActionPolicy.ALLOW;

        final navigationActionPolicy = webViewController.moreSearchIfNeeded(
            initialUrl: initialUrl.toString(),
            currentUrl: currentUrl.value.toString(),
            requestUrl: navigationAction.request.url.toString(),
            currentTreeId: searchTreeId);

        if (navigationActionPolicy == NavigationActionPolicy.ALLOW) {
          currentUrl.value = requestUrl;
        }

        return navigationActionPolicy;

      },
    );
  }
}
