import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/models/search_tree.dart';
import 'package:what_is/src/models/search_web_page.dart';

import '../components/webview.dart';
import '../utils/util.dart';
import 'search_tree_provider.dart';



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
  /// * 返却値に追加したSearchWebPageの情報を渡す
  ///
  SearchWebPage add({
    required int? parentTreeId,
    required String searchWordOrUrl,
    required bool isUrl
  }) {
    final initialUrl = createUrl(searchWordOrUrl, isUrl: isUrl);
    final newIndexedStackIndex = state.length;
    final newSearchTree = SearchTree(
        searchWebPage: SearchWebPage(
            indexedStackIndex: newIndexedStackIndex,
            searchWord: isUrl? null : searchWordOrUrl, // URLの場合は検索ワードがないためNull
            initUrl: initialUrl.toString(),
            webViewWidget: AppWebView(
                initialUrl: initialUrl,
                searchTreeId: SearchTree.generateTreeId(newIndexedStackIndex))
        ),
    );
    ref.read(searchTreeProvider.notifier).add(
        parentTreeId: parentTreeId,
        newSearchTree: newSearchTree
    );
    state = [...state, newSearchTree.searchWebPage];
    return newSearchTree.searchWebPage;
  }


  /// 指定したIndexのWebViewを削除する
  // void remove(int Index) {
  //   ref.watch(searchTreeProvider.notifier).reBuild(searchTree);
  //   state = List.of(state)..removeWhere((e) => e.index == id);
  // }

}
