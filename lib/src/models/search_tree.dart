import 'package:what_is/src/models/search_web_page.dart';

/// 検索情報を親子兄弟で紐づけておくためのクラス
/// ```
/// SearchTree(
///    id: 1
///    searchWebPage: ****,
///    children: [
///       SearchTree(
///         id: 2
///         searchWebPage: ****,
///         children: [
///           SearchTree(id: 5, searchWebPage: ****),
///         ]
///       ),
///       SearchTree(id: 3, searchWebPage: ****),
///       SearchTree(id: 4, searchWebPage: ****),
///    ]
/// )
/// ```
///
///
class SearchTree {

  /// TreeのId（内部的にはIndexedStackに表示する時のIndexが利用されている）
  /// * 外部からは指定できない。
  ///
  final int id;

  /// この階層のWebページ情報
  ///
  final SearchWebPage searchWebPage;

  /// この階層のさらに子階層の情報
  ///
  final List<SearchTree>? children;

  SearchTree({
    required this.searchWebPage,
    this.children
  }) : id = _generateTreeId(searchWebPage.indexedStackIndex);


  // indexedStackIndexをそのままIDに利用するだけのロジックだが、別ロジックでこれを意識させないためのもの
  static _generateTreeId(int indexedStackIndex) {
    return indexedStackIndex;
  }

}
