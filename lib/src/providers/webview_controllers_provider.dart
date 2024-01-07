import 'package:flutter_inappwebview/flutter_inappwebview.dart' show InAppWebViewController;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import '../models/search_tree.dart';


/// すべてのWebViewのコントローラーをIndexedStackのIndexと紐づけた状態で管理する。
final webViewControllersProvider = NotifierProvider.autoDispose<
    WebViewControllersProvider,
    List<({int searchTreeId, InAppWebViewController controller})>
>(() => WebViewControllersProvider());


class WebViewControllersProvider extends AutoDisposeNotifier<List<({
  int searchTreeId,
  InAppWebViewController controller
})>> {

  @override
  List<({int searchTreeId, InAppWebViewController controller})> build() => [];

  void add(({int searchTreeId, InAppWebViewController controller}) value) {
    state = [...state, value];
  }

}


/// すべてのWebViewControllerの中からSearchTreeIdを使って特定のWebViewControllerを取得する。
final specificWebViewControllerProvider = Provider.autoDispose.family<InAppWebViewController?, int>((ref, searchTreeId) {
  final value = ref.watch(webViewControllersProvider);
  return value.firstWhereOrNull((e) => e.searchTreeId == searchTreeId)?.controller;
});
