// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:what_is/component/animation.dart';
// import 'package:what_is/component/squishy_button.dart';
// import 'package:what_is/logic/notifier.dart';
//
// import '../logic/common_logic.dart';
// import '../main.dart';
//
//
// class AppWebViewPages extends HookConsumerWidget {
//   const AppWebViewPages({
//     super.key,
//     required this.safeAreaPadding,
//     required this.firstPageWord
//   });
//   final EdgeInsets safeAreaPadding;
//   final String firstPageWord;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     final currentWebViewController = ref.watch(currentWebViewControllerProvider);
//     final isLoadingCurrentWebView = ref.watch(isLoadingCurrentWebViewProvider);
//
//     ref.listen(newWordFromOutsideProvider, (pre, next) {
//       if (pre != next) showSearchAgainToast(context, ref, safeAreaPadding: safeAreaPadding);
//     });
//
//     final pages = ref.watch(webViewPagesProvider);
//
//     useEffect(() {
//       WidgetsBinding.instance.addPostFrameCallback((_){
//         ref.read(webViewPagesProvider.notifier).state = [AppWebView(createUrl(firstPageWord), safeAreaPadding: safeAreaPadding)];
//       });
//       return;
//     }, const []);
//
//     return Stack(
//       children: [
//         Positioned.fill(
//           child: ColoredBox(
//             color: Theme.of(context).scaffoldBackgroundColor,
//           ),
//         ),
//         Column(
//           children: [
//             Expanded(
//               child: PageView.builder(
//                 physics: const NeverScrollableScrollPhysics(),
//                 scrollDirection: Axis.vertical,
//                 controller: ref.watch(webViewPagesPageControllerProvider),
//                 itemCount: pages.length,
//                 itemBuilder: (_, index) {
//                   if (pages.isEmpty) return const SizedBox.shrink();
//                   return pages[index];
//                 },
//               ),
//             ),
//             WebViewBottomBar(
//                 onGoBack: () => currentWebViewController?.goBack(),
//                 onGoForward: () => currentWebViewController?.goForward(),
//                 onShare: () async {
//                   final url = await currentWebViewController?.getOriginalUrl();
//                   if (url == null) return;
//                   Share.share(url.toString());
//                 },
//                 onReload: () => currentWebViewController?.reload(),
//                 isLoading: isLoadingCurrentWebView),
//           ],
//         ),
//       ],
//     );
//   }
//
// }
//
//
//
// class AppWebView extends HookConsumerWidget {
//   const AppWebView(this.url, {
//     super.key,
//     required this.safeAreaPadding});
//
//   final WebUri url;
//   final EdgeInsets safeAreaPadding;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//
//     final webViewController = useState<InAppWebViewController?>(null);
//     final isLoadingNotifier = ref.watch(isLoadingCurrentWebViewProvider.notifier);
//
//     return InAppWebView(
//       initialUrlRequest: URLRequest(url: url),
//       initialSettings: InAppWebViewSettings(
//         transparentBackground: true,
//         javaScriptEnabled: true,
//       ),
//       contextMenu: ref.watch(contextMenuProvider(safeAreaPadding)),
//       onLoadStart: (_, __) => isLoadingNotifier.state = true,
//       onLoadStop: (_, __) => isLoadingNotifier.state = false,
//       onWebViewCreated: (controller) {
//         webViewController.value = controller;
//         ref.read(currentWebViewControllerProvider.notifier).state = controller;
//       },
//       onUpdateVisitedHistory: (controller, __, ___) async {
//         //TODO: 閲覧履歴を取得してデータ活用にする。
//       },
//     );
//   }
// }
//
//
//
//
//
// class WebViewBottomBar extends StatelessWidget {
//   const WebViewBottomBar({
//     super.key,
//     required this.isLoading,
//     required this.onGoBack,
//     required this.onGoForward,
//     required this.onShare,
//     required this.onReload
//   });
//   final bool isLoading;
//   final VoidCallback onGoBack;
//   final VoidCallback onGoForward;
//   final VoidCallback onShare;
//   final VoidCallback onReload;
//
//   static const height = 56.0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         SizedBox(
//           width: double.infinity,
//           height: height,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 3,
//                   child: Row(
//                     children: [
//                       SquishyButton(
//                         onTap: () => onGoBack(),
//                         child: activeButton(context, iconData: CupertinoIcons.arrow_left, enableBG: false),
//                         disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_left),
//                       ),
//                       const Spacer(),
//                       SquishyButton(
//                         onTap: () => onGoForward(),
//                         child: activeButton(context, iconData: CupertinoIcons.arrow_right, enableBG: false),
//                         disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_right),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   flex: 5,
//                   child: Row(
//                     children: [
//                       const Spacer(),
//                       SquishyButton(
//                         onTap: () => onShare(),
//                         child: activeButton(context,
//                             iconData: Platform.isIOS
//                                 ? CupertinoIcons.square_arrow_up
//                                 : Icons.share,
//                             enableBG: false),
//                         disableWidget: disableButton(context, iconData: CupertinoIcons.square_arrow_up),
//                       ),
//                       const Spacer(),
//                       SquishyButton(
//                         onTap: () => onReload(),
//                         padding: EdgeInsets.zero,
//                         child: activeButton(context, iconData: CupertinoIcons.arrow_clockwise),
//                         disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_clockwise),
//                       ),
//                       const SizedBox(width: 8.0,),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 0,
//           right: 0,
//           left: 0,
//           child: LinearProgressIndicator(
//             minHeight: 2.5,
//             backgroundColor: accentColor.withOpacity(0.5),
//             color: accentColor,
//           ),
//         ),
//         if (isLoading == false)
//           Positioned(
//             top: 0,
//             right: 0,
//             left: 0,
//             child: AppAnimation.fadeIn(
//               child: Container(
//                 height: 2.5,
//                 color: Theme.of(context).scaffoldBackgroundColor,
//               ),
//             ),
//           ),
//       ],
//     );
//   }
//
//   Widget activeButton(BuildContext context, {required IconData iconData, bool enableBG = true}) {
//     return Container(
//       decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: enableBG? Colors.blueGrey.withOpacity(0.15) : null
//       ),
//       padding: EdgeInsets.all(enableBG? 8.0 : 0.0),
//       child: Icon(
//         iconData,
//         size: 28.0,
//       ),
//     );
//   }
//
//   Widget disableButton(BuildContext context, {required IconData iconData, bool enableBG = true}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Icon(
//         iconData,
//         size: 28.0,
//         color: Theme.of(context).iconTheme.color!.withOpacity(0.2),
//       ),
//     );
//   }
// }
//
//
