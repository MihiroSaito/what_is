import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/controllers/webview_controller.dart';

import 'webview_controllers_provider.dart';


final contextMenuProvider = Provider.autoDispose.family<ContextMenu, int>((ref, currentTreeId) {
  return ContextMenu(
    menuItems: [

      ContextMenuItem(id: 1, title: "あとで検索", action: () async {
        final currentWebViewController = ref.watch(specificWebViewControllerProvider(currentTreeId));
        final selectedText = await currentWebViewController?.getSelectedText();
        if (selectedText == null) return;
        WebViewController(ref).afterSearch(
            currentTreeId: currentTreeId,
            searchWordOrUrl: selectedText,
            isUrl: false
        );
        //TODO: Loadingアニメーションが発生してしまうのが違和感あるため修正する。
      }),

      ContextMenuItem(id: 2, title: "すぐに検索", action: () async {
        final currentWebViewController = ref.watch(specificWebViewControllerProvider(currentTreeId));
        final selectedText = await currentWebViewController?.getSelectedText();
        if (selectedText == null) return;
        WebViewController(ref).immediatelySearch(
            currentTreeId: currentTreeId,
            searchWordOrUrl: selectedText,
            isUrl: false
        );
      }),

    ],
    settings: ContextMenuSettings(
        hideDefaultSystemContextMenuItems: true
    ),
  );
});



