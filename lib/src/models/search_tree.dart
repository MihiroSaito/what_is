import 'package:what_is/src/models/search_web_page.dart';

/// 検索情報を親子兄弟で紐づけておくためのクラス
/// ```
/// SearchTree(
///    searchWebPage: ****,
///    children: [
///       SearchTree(
///         searchWebPage: ****,
///         children: [
///           SearchTree(searchWebPage: ****),
///         ]
///       ),
///       SearchTree(searchWebPage: ****),
///       SearchTree(searchWebPage: ****),
///    ]
/// )
/// ```
///
///
class SearchTree {

  /// この階層のWebページ情報
  ///
  final SearchWebPage searchWebPage;

  /// この階層のさらに子階層の情報
  ///
  final List<SearchTree>? children;

  const SearchTree({
    required this.searchWebPage,
    this.children
  });
}
