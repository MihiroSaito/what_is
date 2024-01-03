import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/animation.dart';
import 'package:what_is/component/squishy_button.dart';
import 'package:what_is/logic/notifier.dart';
import 'package:what_is/src/models/search_tree.dart';
import 'package:what_is/src/models/search_web_page.dart';
import 'package:what_is/src/notifiers/current_webview_controller.dart';
import 'package:what_is/src/notifiers/display_web_page_notifier.dart';

import '../../main.dart';
import '../notifiers/content_menu_notifier.dart';
import '../notifiers/web_pages_notifier.dart';


class SearchViewWidget extends HookConsumerWidget {
  const SearchViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final webPages = ref.watch(webPagesProvider);
    final displayWebPageIndex = ref.watch(displayWebPageIndexProvider);
    final currentWebViewController = ref.watch(currentWebViewControllerProvider);

    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: displayWebPageIndex,
                children: webPages.map((e) {
                  return e.webViewWidget;
                }).toList(),
              ),
            ),
            WebViewBottomBar(
                onGoBack: () {
                  //TODO: 実装する。
                },
                onGoForward: () {
                  //TODO: 実装する。
                },
                onShare: () {
                  //TODO: 実装する。
                },
                onReload: () {
                  //TODO: 実装する。
                },
                isLoading: false //TODO: 実装する
              ),
          ],
        ),
      ],
    );
  }

}



class AppWebView extends HookConsumerWidget {
  const AppWebView({
    super.key,
    required this.initialUrl,
    required this.parentSearchTreeId
  });

  final WebUri initialUrl;
  final int? parentSearchTreeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final webViewController = useState<InAppWebViewController?>(null);
    final isLoadingNotifier = ref.watch(isLoadingCurrentWebViewProvider.notifier);

    return InAppWebView(
      initialUrlRequest: URLRequest(url: initialUrl),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        javaScriptEnabled: true,
      ),
      contextMenu: ref.watch(contextMenuProvider(parentSearchTreeId)),
      onLoadStart: (_, __) => isLoadingNotifier.state = true,
      onLoadStop: (_, __) => isLoadingNotifier.state = false,
      onWebViewCreated: (controller) {
        webViewController.value = controller;
        ref.read(currentWebViewControllerProvider.notifier).update(controller);
      },
      onUpdateVisitedHistory: (controller, __, ___) async {
        //TODO: 閲覧履歴を取得してデータ活用にする。
      },
    );
  }
}





class WebViewBottomBar extends StatelessWidget {
  const WebViewBottomBar({
    super.key,
    required this.isLoading,
    required this.onGoBack,
    required this.onGoForward,
    required this.onShare,
    required this.onReload
  });
  final bool isLoading;
  final VoidCallback onGoBack;
  final VoidCallback onGoForward;
  final VoidCallback onShare;
  final VoidCallback onReload;

  static const height = 56.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    children: [
                      SquishyButton(
                        onTap: () => onGoBack(),
                        child: activeButton(context, iconData: CupertinoIcons.arrow_left, enableBG: false),
                        disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_left),
                      ),
                      const Spacer(),
                      SquishyButton(
                        onTap: () => onGoForward(),
                        child: activeButton(context, iconData: CupertinoIcons.arrow_right, enableBG: false),
                        disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_right),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    children: [
                      const Spacer(),
                      SquishyButton(
                        onTap: () => onShare(),
                        child: activeButton(context,
                            iconData: Platform.isIOS
                                ? CupertinoIcons.square_arrow_up
                                : Icons.share,
                            enableBG: false),
                        disableWidget: disableButton(context, iconData: CupertinoIcons.square_arrow_up),
                      ),
                      const Spacer(),
                      SquishyButton(
                        onTap: () => onReload(),
                        padding: EdgeInsets.zero,
                        child: activeButton(context, iconData: CupertinoIcons.arrow_clockwise),
                        disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_clockwise),
                      ),
                      const SizedBox(width: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: LinearProgressIndicator(
            minHeight: 2.5,
            backgroundColor: accentColor.withOpacity(0.5),
            color: accentColor,
          ),
        ),
        if (isLoading == false)
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: AppAnimation.fadeIn(
              child: Container(
                height: 2.5,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget activeButton(BuildContext context, {required IconData iconData, bool enableBG = true}) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enableBG? Colors.blueGrey.withOpacity(0.15) : null
      ),
      padding: EdgeInsets.all(enableBG? 8.0 : 0.0),
      child: Icon(
        iconData,
        size: 28.0,
      ),
    );
  }

  Widget disableButton(BuildContext context, {required IconData iconData, bool enableBG = true}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        iconData,
        size: 28.0,
        color: Theme.of(context).iconTheme.color!.withOpacity(0.2),
      ),
    );
  }
}


