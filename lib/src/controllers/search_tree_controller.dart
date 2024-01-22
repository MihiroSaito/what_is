import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/components/confirm_delete_dialog_widget.dart';
import 'package:what_is/src/providers/device_size_provider.dart';
import 'package:what_is/src/providers/search_tree_provider.dart';

import '../models/search_tree.dart';
import '../views/search_tree_screen.dart';


class SearchTreeController {

  Widget createSearchTreeWidget(SearchTree? node) {
    if (node == null) return const SizedBox.shrink();

    return SearchTreeWidget(
      key: GlobalKey(),
      title: node.searchWebPage.searchWord ?? node.searchWebPage.initUrl, // 検索ワードがない（検索を飛ばしURL直アクセス）だったらアクセスしたURLを使用する
      searchTreeId: node.id,
      isHomeCard: node.id == 0,
      faviconUrl: node.searchWebPage.webViewWidget.favicon.value.lastOrNull?.url.toString(),
      pageThumbnailUrl: node.searchWebPage.webViewWidget.thumbnail.value,
      siteName: node.searchWebPage.webViewWidget.title.value,
      children: node.children.map((child) {
        return createSearchTreeWidget(child);
      }).toList(),
    );
  }


  Future<void> removeSearchTreeIfConfirmationOK(WidgetRef ref, {
    required int targetTreeId,
    required bool isHome
  }) async {
    final ok = await _canDeleteCard();
    if (ok == false) return;
    //TODO: OKだったら指定したツリーとその配下を全て消す。
    //TODO: もしHomeカードを消したなら、searchViewも閉じる。
    // ref.read(searchTreeProvider.notifier).remove(targetTreeId);
  }


  Future<bool> _canDeleteCard() async {
    return await showDialog(
        context: App.navigatorKey.currentContext!,
        useRootNavigator: true,
        builder: (_) {
          return const ConfirmDeleteDialogWidget(
            title: '紐づいている検索も完全に削除されます。',
            text: 'この操作は元に戻せません。',
          );
        }
    ) ?? false;
  }

}
