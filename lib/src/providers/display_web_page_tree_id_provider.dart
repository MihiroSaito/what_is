import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/search_tree.dart';
import 'display_web_page_index_provider.dart';


/// 現在IndexedStackに表示しているWebViewのTreeIdを管理する
final displayWebPageTreeIdProvider = Provider.autoDispose<int>((ref) {
  return SearchTree.generateTreeId(ref.watch(displayWebPageIndexProvider));
});
