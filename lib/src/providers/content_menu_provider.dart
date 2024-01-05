import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/providers/display_web_page_provider.dart';
import 'package:what_is/src/providers/search_tree_provider.dart';

import 'current_webview_controller_provider.dart';
import 'web_pages_provider.dart';


final contextMenuProvider = Provider.autoDispose.family<ContextMenu, int?>((ref, currentTreeId) {
  return ContextMenu(
    menuItems: [

      ContextMenuItem(id: 1, title: "さらに検索", action: () async {
        final selectedText = await ref.watch(currentWebViewControllerProvider)?.getSelectedText();
        if (selectedText == null) return;
        final newPage = ref.read(webPagesProvider.notifier).add(
            parentTreeId: currentTreeId,
            searchWord: selectedText);
        ref.read(displayWebPageIndexProvider.notifier).change(index: newPage.indexedStackIndex);
      }),

      ContextMenuItem(id: 2, title: "あとで検索", action: () async {
        final selectedText = await ref.watch(currentWebViewControllerProvider)?.getSelectedText();
        if (selectedText == null) return;
        ref.read(webPagesProvider.notifier).add(
            parentTreeId: currentTreeId,
            searchWord: selectedText);
        //TODO: Loadingアニメーションが発生してしまうのが違和感あるため修正する。
      }),

    ],
    settings: ContextMenuSettings(
        hideDefaultSystemContextMenuItems: true
    ),
  );
});



