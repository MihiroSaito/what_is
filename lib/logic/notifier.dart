import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/webivew.dart';
import 'package:what_is/logic/word_history.dart';

import 'common_logic.dart';


class WordHistoryNotifier extends AutoDisposeNotifier<List<WordHistory>> {
  @override
  List<WordHistory> build() {
    return [];
  }

  void add(WordHistory wordHistory) {
    state = state = [...state, wordHistory];
  }

  void clear() => state = [];

  void clearAndAdd(WordHistory wordHistory) => state = [wordHistory];
}

final wordHistoryProvider = NotifierProvider.autoDispose<WordHistoryNotifier, List<WordHistory>>(() {
  return WordHistoryNotifier();
});




final newWordFromOutsideProvider = StateProvider.autoDispose<String?>((ref) => null);




final appLifecycleProvider = Provider<AppLifecycleState?>((ref) {
  final observer = _AppLifecycleObserver((value) => ref.state = value);
  final binding = WidgetsBinding.instance..addObserver(observer);
  ref.onDispose(() => binding.removeObserver(observer));
  return null;
});



class _AppLifecycleObserver extends WidgetsBindingObserver {
  _AppLifecycleObserver(this._didChangeState);

  final ValueChanged<AppLifecycleState> _didChangeState;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _didChangeState(state);
    super.didChangeAppLifecycleState(state);
  }
}



final latestAppLifeCycleStateProvider = StateProvider<AppLifecycleState?>((ref) => null);


// final currentWebViewControllerProvider = StateProvider.autoDispose<InAppWebViewController?>((ref) => null);

final isLoadingCurrentWebViewProvider = StateProvider.autoDispose<bool>((ref) => true);

// final webViewPagesProvider = StateProvider.autoDispose<List<AppWebView>>((ref) => []);

// final webViewPagesPageControllerProvider = StateProvider.autoDispose<PageController>((ref) => PageController());

//
// final contextMenuProvider = StateProvider.autoDispose.family<ContextMenu, EdgeInsets>((ref, safeAreaPadding) {
//   return ContextMenu(
//     menuItems: [
//       ContextMenuItem(id: 1, title: "さらに検索", action: () async {
//         final selectedText = await ref.watch(currentWebViewControllerProvider)?.getSelectedText();
//         if (selectedText != null) {
//           final pageUrl = createUrl(selectedText);
//           final webViewPages = ref.watch(webViewPagesProvider);
//           final webViewsPageController = ref.watch(webViewPagesPageControllerProvider);
//           final webViewPagesNotifier = ref.read(webViewPagesProvider.notifier);
//           final wordHistoryNotifier = ref.read(wordHistoryProvider.notifier);
//           webViewPagesNotifier.state = [...webViewPages, AppWebView(pageUrl, safeAreaPadding: safeAreaPadding,)];
//           wordHistoryNotifier.add(
//               WordHistory(word: selectedText, url: pageUrl.toString()));
//           webViewsPageController.nextPage(duration: const Duration(milliseconds: 330), curve: Curves.easeInOut);
//         }
//       }),
//       ContextMenuItem(id: 2, title: "あとで検索", action: () async {
//         final selectedText = await ref.watch(currentWebViewControllerProvider)?.getSelectedText();
//         if (selectedText != null) {
//           final pageUrl = createUrl(selectedText);
//           final webViewPages = ref.watch(webViewPagesProvider);
//           final webViewPagesNotifier = ref.read(webViewPagesProvider.notifier);
//           final wordHistoryNotifier = ref.read(wordHistoryProvider.notifier);
//           webViewPagesNotifier.state = [...webViewPages, AppWebView(pageUrl, safeAreaPadding: safeAreaPadding,)];
//           wordHistoryNotifier.add(
//               WordHistory(word: selectedText, url: pageUrl.toString()));
//         }
//       }),
//     ],
//     settings: ContextMenuSettings(
//         hideDefaultSystemContextMenuItems: true
//     ),
//   );
// });



