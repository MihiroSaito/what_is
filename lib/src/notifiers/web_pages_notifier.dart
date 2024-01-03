import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/logic/common_logic.dart';
import 'package:what_is/src/models/search_tree.dart';
import 'package:what_is/src/models/search_web_page.dart';
import 'package:what_is/src/notifiers/search_tree_notifier.dart';
import 'package:what_is/src/views/webivew.dart';



/// 検索画面のIndexedStackで状態を保持した状態で管理したいWebViewを管理
///
final webPagesProvider = NotifierProvider.autoDispose<WebPagesNotifier, List<SearchWebPage>>(() {
  return WebPagesNotifier();
});


class WebPagesNotifier extends AutoDisposeNotifier<List<SearchWebPage>> {

  @override
  List<SearchWebPage> build() {
    ref.watch(searchTreeProvider);
    return [];
  }

  /// IndexedStackウィジェットにWebページを追加する。
  /// * 追加したタイミングでサーチツリー（ロジック側）も更新する。
  ///
  void add({required int? parentTreeId, required String searchWord}) {
    final initialUrl = createUrl(searchWord);
    final newSearchWebPage = SearchWebPage(
        indexedStackIndex: state.length + 1,
        searchWord: searchWord,
        initUrl: initialUrl.toString(),
        webViewWidget: AppWebView(
            initialUrl: initialUrl,
            parentSearchTreeId: parentTreeId)
    );
    ref.read(searchTreeProvider.notifier).add(
        parentTreeId: parentTreeId,
        newSearchTree: SearchTree(
            id: newSearchWebPage.indexedStackIndex,
            searchWebPage: newSearchWebPage
        )
    );
    state = [...state, newSearchWebPage];
  }

  /// 指定したIndexのWebViewを削除する
  // void remove(int Index) {
  //   ref.watch(searchTreeProvider.notifier).reBuild(searchTree);
  //   state = List.of(state)..removeWhere((e) => e.index == id);
  // }

}


// /// 検索画面のIndexedStackで状態を保持した状態で管理したいWebViewのListの最後のIndexを取得
// final lastWebPagesIndexProvider = Provider.autoDispose<int>((ref) {
//   return ref.watch(webPagesProvider).length - 1;
// });
