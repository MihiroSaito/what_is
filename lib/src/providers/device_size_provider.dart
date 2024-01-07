import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../views/home_screen.dart';


/// デバイスのステータスバーやインディケーターバーのエリアのPaddingを取得する。
///
final safeAreaPaddingProvider = Provider<EdgeInsets>((ref) {
  final context = HomeScreen.viewKey.currentContext!;
  return MediaQuery.paddingOf(context);
});


/// デザインのスクリーンサイズを取得する。
///
final screenSizeProvider = Provider<Size>((ref) {
  final context = HomeScreen.viewKey.currentContext!;
  return MediaQuery.sizeOf(context);
});
