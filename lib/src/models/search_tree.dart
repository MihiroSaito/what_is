import 'package:what_is/src/models/search_web_page.dart';

/// 検索した言葉や概念をキャッチアップしている中で検索した別の言葉や概念を紐づけて管理するためのモデル
/// TODO: SearchWebPageTreeという名前にしてidは不要かも
class SearchTree {
  final int id;
  final SearchWebPage searchWebPage;
  final List<SearchTree>? children;
  const SearchTree({
    required this.id,
    required this.searchWebPage,
    this.children
  });
}
