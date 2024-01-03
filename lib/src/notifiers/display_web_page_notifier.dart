import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/models/search_tree.dart';
import 'package:what_is/src/notifiers/web_pages_notifier.dart';

import '../../component/webivew.dart';
import '../models/search_web_page.dart';


/// 現在IndexedStackに表示しているWebViewのIndexを管理する
final displayWebPageIndexProvider = NotifierProvider.autoDispose<DisplayWebPageIndexNotifier, int>(() {
  return DisplayWebPageIndexNotifier();
});


class DisplayWebPageIndexNotifier extends AutoDisposeNotifier<int> {

  @override
  int build() => 0;

  void change({required int index}) => state = index;

}
