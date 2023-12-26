import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/logic/word_history.dart';


class WordHistoryNotifier extends Notifier<List<WordHistory>> {
  @override
  List<WordHistory> build() {
    return [];
  }

  void add(WordHistory wordHistory) {
    state = state = [...state, wordHistory];
  }
}

final wordHistoryProvider = NotifierProvider<WordHistoryNotifier, List<WordHistory>>(() {
  return WordHistoryNotifier();
});




final newWordFromOutsideProvider = StateProvider<String?>((ref) => null);




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

// class _AppLifecycleObserver extends WidgetsBindingObserver {
//   _AppLifecycleObserver(this.ref);
//   final ProviderRef ref;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     final firstWord = ref.watch(wordHistoryProvider).firstOrNull; // 最初に検索したワードを取得
//
//     final latestState = ref.watch(latestAppLifeCycleStateProvider); // 最新のアプリの状態を取得（バックグラウンド？フォアグラウンド？etc..）
//     ref.read(latestAppLifeCycleStateProvider.notifier).state = state; // 最新のアプリの状態を更新
//     if (latestState == null) return; // 最新のアプリの状態がない = 初回起動の場合は以降の処理をスキップ
//
//     if(state == AppLifecycleState.resumed){
//       if (firstWord == null) return;
//       Future(() async {
//         final data = await Clipboard.getData(Clipboard.kTextPlain);
//         final String? text = data?.text; // 現在のクリップボードにあるワードを取得
//         ref.watch(newWordFromOutsideProvider.notifier).state = text; // 取得した2つのワードが別のものだったらフラグを立てる
//       });
//     }
//
//     super.didChangeAppLifecycleState(state);
//   }
// }



final latestAppLifeCycleStateProvider = StateProvider<AppLifecycleState?>((ref) => null);

