import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/providers/search_tree_provider.dart';
import 'package:what_is/src/views/search_tree.dart';

import '../controllers/search_by_clipboard_controller.dart';
import '../providers/web_pages_provider.dart';
import '../views/webivew.dart';


class AppNavigator {

  void toSearchView(BuildContext context, WidgetRef ref, {required String searchText}) {
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return const SearchViewWidget();
    }));

    ref.watch(webPagesProvider.notifier).add(
        parentTreeId: null,
        searchWord: searchText);

    // クリップボードからコピーするためのポップは非表示にする
    SearchByClipBoardController.pop();
  }


  void tpSearchTreePage() {
    App.navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (_) {
          return const SearchTreePage();
        }
    ));
  }


  void pop() => Navigator.pop(App.navigatorKey.currentContext!);

}
