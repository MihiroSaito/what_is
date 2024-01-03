import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/models/search_web_page.dart';
import 'package:what_is/src/notifiers/current_webview_controller.dart';

import '../utils/util.dart';
import '../views/webivew.dart';
import 'web_pages_notifier.dart';


final contextMenuProvider = Provider.autoDispose.family<ContextMenu, int?>((ref, parentTreeId) {
  return ContextMenu(
    menuItems: [
      ContextMenuItem(id: 1, title: "さらに検索", action: () async {
        final selectedText = await ref.watch(currentWebViewControllerProvider)?.getSelectedText();
        if (selectedText != null) {
          final pageUrl = createUrl(selectedText);
          // ref.read(webPagesProvider.notifier).add(
          //     parentTreeId: parentTreeId,
          //     searchWebPage: SearchWebPage(
          //         pageIndex: ref.watch(lastWebPagesIndexProvider) + 1,
          //         searchWord: selectedText,
          //         url: pageUrl.toString(),
          //         webViewWidget: AppWebView(
          //             initialUrl: pageUrl, parentSearchTreeId: parentTreeId ?? 0)
          //     )
          // );
        }
      }),
      ContextMenuItem(id: 2, title: "あとで検索", action: () async {
        final selectedText = await ref.watch(currentWebViewControllerProvider)?.getSelectedText();
        if (selectedText != null) {
          final pageUrl = createUrl(selectedText);
          final webPages = ref.watch(webPagesProvider);
        }
      }),
    ],
    settings: ContextMenuSettings(
        hideDefaultSystemContextMenuItems: true
    ),
  );
});
