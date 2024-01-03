import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/logic/word_history.dart';


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
//
// final wordHistoryProvider = NotifierProvider.autoDispose<WordHistoryNotifier, List<WordHistory>>(() {
//   return WordHistoryNotifier();
// });




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



