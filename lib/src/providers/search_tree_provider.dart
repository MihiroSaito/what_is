import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/models/search_tree.dart';


final searchTreeProvider = NotifierProvider.autoDispose<SearchTreeNotifier, SearchTree?>(() {
  return SearchTreeNotifier();
});


class SearchTreeNotifier extends AutoDisposeNotifier<SearchTree?> {

  @override
  SearchTree? build() {
    return null;
  }

  /// 【注意】[webPagesProvider]のadd()メソッドでコールされる
  /// サーチツリーを再構築（変更）する
  /// * [changeObjId]には、サーチツリーの変更点のIDを指定する
  /// * あるWebページを削除したり新たに検索する際に利用する
  /// * 初回の検索ならparentTreeIdはNullを指定。それ以外はint型の値が必須
  ///
  void add({required int? parentTreeId, required SearchTree newSearchTree}) {
    SearchTree? wholeSearchTree = state; // 現在のサーチツリーを取得
    if (wholeSearchTree == null) {
      state = newSearchTree; // サーチツリーがまだない=初回の検索 だったらサーチツリーを作成し処理終了
      return;
    }

    if (parentTreeId == null) throw ErrorDescription('ツリーが存在する場合はparentTreeIdにはNullを指定できません');

    // 指定したIDに一致するサーチツリーを取得し、そのツリーのchildrenに値を追加する
    SearchTree? child1 = _findTreeById(wholeSearchTree, parentTreeId);
    if (child1 != null) child1.children = List.of(child1.children)..add(newSearchTree);

    // 新しいサーチツリーを作成
    state = wholeSearchTree;
  }

  //TODO: 特定のサーチツリーを削除できるようにしたい。

  /// サーチツリーを削除する。
  /// 新たに検索しなおしたい時に利用する
  void clear() => state = null;

}



/// 特定のIDに対応するSearchTreeを再帰的に検索する関数
///
SearchTree? _findTreeById(SearchTree node, int targetId) {
  if (node.id == targetId) {
    return node;
  }
  if (node.children.isNotEmpty) {
    for (var child in node.children) {
      var result = _findTreeById(child, targetId);
      if (result != null) {
        return result;
      }
    }
  }
  return null;
}

