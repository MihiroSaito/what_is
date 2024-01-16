// import 'package:flash/flash.dart';
// import 'package:flash/flash_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:what_is/src/routing/navigator.dart';
//
// import '../components/search_by_clipboard_toast_widget.dart';
// import '../../main.dart';
// import '../utils/util.dart';
//
//
// class SearchByClipBoardController {
//
//   static FlashController<Object?>? _flashController;
//
//   static Future<void> show(BuildContext context, WidgetRef ref) async {
//     _flashController?.dismiss();
//     final String? text = (await Future.wait([
//       getClipboardText(),
//       Future.delayed(const Duration(milliseconds: 300)) //キーボード表示を待つ
//     ])).first; // 現在のクリップボードにあるワードを取得
//     if (text == null) return;
//     if (!(_flashController?.controller.isCompleted ?? true)) return;
//     if (_isURL(text)) {
//       _urlFlash(context, ref, text);
//     } else {
//       _textFlash(context, ref, text);
//     }
//   }
//
//
//   static void pop() {
//     if (_flashController != null) {
//       _flashController?.dismiss();
//     }
//   }
//
//
//   static bool _isURL(String text) {
//     try {
//       final isAbsolute = Uri.parse(text).hasAbsolutePath; //TODO: ここちゃんとできているか確認する
//       return isAbsolute;
//     } catch (e) {
//       return false;
//     }
//   }
//
//
//   static Future<void> _urlFlash(BuildContext context, WidgetRef ref, String text) async {
//     await App.navigatorKey.currentContext!.showFlash(
//         transitionDuration: const Duration(milliseconds: 500),
//         duration: const Duration(milliseconds: 5500),
//         builder: (_, controller) {
//
//           _flashController = controller;
//
//           return FlashBar(
//             controller: controller,
//             behavior: FlashBehavior.floating,
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(40.0)),
//             ),
//             padding: EdgeInsets.zero,
//             forwardAnimationCurve: Curves.elasticOut,
//             margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0,),
//             content: SearchByClipboardUrlToastWidget(
//               word: text,
//               onTap: () {
//                 AppNavigator.toSearchView(context, ref, searchText: text, isDirectUrl: true);
//                 _flashController?.dismiss();
//               },
//             ),
//           );
//         }
//     ).then((value) => _flashController = null);
//   }
//
//
//   static Future<void> _textFlash(BuildContext context, WidgetRef ref, String text) async {
//     await App.navigatorKey.currentContext!.showFlash(
//         transitionDuration: const Duration(milliseconds: 500),
//         duration: const Duration(milliseconds: 5500),
//         builder: (_, controller) {
//
//           _flashController = controller;
//
//           return FlashBar(
//             controller: controller,
//             behavior: FlashBehavior.floating,
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(40.0)),
//             ),
//             padding: EdgeInsets.zero,
//             forwardAnimationCurve: Curves.elasticOut,
//             margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0,),
//             content: SearchByClipboardTextToastWidget(
//               word: text,
//               onTap: () {
//                 AppNavigator.toSearchView(context, ref, searchText: text);
//                 _flashController?.dismiss();
//               },
//             ),
//           );
//         }
//     ).then((value) => _flashController = null);
//   }
//
//
// }
