import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/search_tree.dart';


/// 現在IndexedStackに表示しているWebViewのIndexを管理する
final displayWebPageIndexProvider = NotifierProvider.autoDispose<DisplayWebPageIndexNotifier, int>(() {
  return DisplayWebPageIndexNotifier();
});

class DisplayWebPageIndexNotifier extends AutoDisposeNotifier<int> {

  @override
  int build() => 0;

  void change({required int index}) => state = index;

}
