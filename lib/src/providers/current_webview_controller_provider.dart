import 'package:flutter_inappwebview/flutter_inappwebview.dart' show InAppWebViewController;
import 'package:hooks_riverpod/hooks_riverpod.dart';


/// 現在検索画面に表示しているWebViewのControllerを管理する
final currentWebViewControllerProvider = NotifierProvider.autoDispose<
    CurrentWeViewControllerProvider,
    InAppWebViewController?
>(() => CurrentWeViewControllerProvider());


class CurrentWeViewControllerProvider extends AutoDisposeNotifier<InAppWebViewController?> {

  @override
  InAppWebViewController? build() => null;

  void update(InAppWebViewController controller) => state = controller;

}
