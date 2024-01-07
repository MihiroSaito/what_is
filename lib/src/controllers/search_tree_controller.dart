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
      title: node.searchWebPage.searchWord,
      searchTreeId: node.id,
      isHomeCard: node.id == 0,
      siteLogo: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRqTcH9zNA5--jcBmb3fBuZ8RMpZSgX-EuUdKAm37L9EfpljQ1C_bQ8j3Xdf0tqOohP5Cw&usqp=CAU'),
      pageThumbnail: null, //TODO: 画像指定する。
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
          return const ConfirmDeleteDialogWidget();
        }
    ) ?? false;
  }

}
