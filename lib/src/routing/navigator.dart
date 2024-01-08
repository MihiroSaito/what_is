import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/providers/content_menu_provider.dart';
import 'package:what_is/src/providers/display_web_page_index_provider.dart';
import 'package:what_is/src/providers/display_web_page_tree_id_provider.dart';
import 'package:what_is/src/providers/loading_webview_provider.dart';
import 'package:what_is/src/providers/search_tree_provider.dart';
import 'package:what_is/src/providers/translation_confirmed_page_list.dart';
import 'package:what_is/src/providers/webview_controllers_provider.dart';
import 'package:what_is/src/views/search_tree_screen.dart';

import '../controllers/search_by_clipboard_controller.dart';
import '../providers/web_pages_provider.dart';
import '../views/about_app_screen.dart';
import '../views/webivew.dart';


class AppNavigator {

  static BuildContext? searchViewContext;

  static void toSearchView(BuildContext context, WidgetRef ref, {
    required String searchText,
    bool isDirectUrl = false
  }) {
    searchViewContext = context;
    Navigator.push(context, MaterialPageRoute(builder: (_) {
      return const SearchViewWidget();
    }));

    ref.watch(webPagesProvider.notifier).add(
        parentTreeId: null,
        searchWord: searchText,
        isDirectUrl: isDirectUrl);

    // クリップボードからコピーするためのポップは非表示にする
    SearchByClipBoardController.pop();
  }

  static popSearchView(WidgetRef ref) {
    if (searchViewContext == null) return;
    if (searchViewContext!.mounted) {
      ref.invalidate(webPagesProvider);
      ref.invalidate(searchTreeProvider);
      ref.invalidate(isLoadingWebViewProvider);
      ref.invalidate(webViewControllersProvider);
      ref.invalidate(displayWebPageTreeIdProvider);
      ref.invalidate(displayWebPageIndexProvider);
      ref.invalidate(contextMenuProvider);
      ref.invalidate(translationConfirmedPageListProvider);
      Navigator.pop(searchViewContext!);
    }
  }



  void toSearchTreePage() {
    App.navigatorKey.currentState!.push(
        MaterialPageRoute(builder: (_) {
          return const SearchTreeScreen();
        }
    ));
  }


  void toAboutAppScreen() {
    App.navigatorKey.currentState!.push(
      CupertinoPageRoute(builder: (_) {
        return const AboutAppScreen();
      })
    );
  }


  void pop() => Navigator.pop(App.navigatorKey.currentContext!);

}
