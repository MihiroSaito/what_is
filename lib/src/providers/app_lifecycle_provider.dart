import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';



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



