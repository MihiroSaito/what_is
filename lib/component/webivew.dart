import 'dart:async';

import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/component/animation.dart';
import 'package:what_is/component/squishy_button.dart';
import 'package:what_is/logic/notifier.dart';
import 'package:what_is/theme.dart';

import '../logic/common_logic.dart';
import '../logic/word_history.dart';
import '../main.dart';


class AppWebView extends HookConsumerWidget {
  const AppWebView({super.key, required this.url, required this.safeAreaPadding});

  final WebUri url;
  final EdgeInsets safeAreaPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoading = useState(true);
    final webViewController = useState<InAppWebViewController?>(null);
    final canGoBackStream = StreamController<bool>();
    final canGoForwardStream = StreamController<bool>();

    final contextMenu = _getContextMenu(
        webViewController: webViewController,
        context: context,
        ref: ref,
        safeAreaPadding: safeAreaPadding);

    ref.listen(newWordFromOutsideProvider, (pre, next) {
      if (pre != next) showSearchAgainToast(context);
    });

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
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: url),
                initialSettings: InAppWebViewSettings(
                  transparentBackground: true,
                  javaScriptEnabled: true,
                ),
                contextMenu: contextMenu,
                onLoadStart: (_, __) => isLoading.value = true,
                onLoadStop: (_, __) => isLoading.value = false,
                onWebViewCreated: (controller) => webViewController.value = controller,
                onUpdateVisitedHistory: (controller, __, ___) async {
                  controller.canGoForward().then((value) {
                    canGoForwardStream.sink.add(true);
                  });
                  controller.canGoBack().then((value) {
                    canGoBackStream.sink.add(true);
                  });
                },
              ),
            ),
            WebViewBottomBar(
                canGoBackStream: canGoBackStream,
                canGoForwardStream: canGoForwardStream,
                webViewController: webViewController.value,
                isLoading: isLoading.value),
          ],
        ),
      ],
    );
  }

}




class WebViewBottomBar extends StatelessWidget {
  const WebViewBottomBar({
    super.key,
    required this.canGoBackStream,
    required this.canGoForwardStream,
    required this.webViewController,
    required this.isLoading
  });
  final StreamController<bool> canGoBackStream;
  final StreamController<bool> canGoForwardStream;
  final InAppWebViewController? webViewController;
  final bool isLoading;

  static const height = 56.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    StreamBuilder(
                        stream: canGoBackStream.stream,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return disableButton(context, iconData: CupertinoIcons.arrow_left);
                          }
                          return SquishyButton(
                            onTap: snapshot.data!? () {
                              webViewController?.goBack();
                            } : null,
                            child: activeButton(context, iconData: CupertinoIcons.arrow_left),
                            disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_left),
                          );
                        }
                    ),
                    const Spacer(),
                    StreamBuilder(
                        stream: canGoForwardStream.stream,
                        builder: (_, snapshot) {
                          if (!snapshot.hasData) {
                            return disableButton(context, iconData: CupertinoIcons.arrow_right);
                          }
                          return SquishyButton(
                            onTap: snapshot.data!? () {
                              webViewController?.goForward();
                            } : null,
                            child: activeButton(context, iconData: CupertinoIcons.arrow_right),
                            disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_right),
                          );
                        }
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    const Spacer(),
                    SquishyButton(
                      onTap: () {
                        webViewController?.reload();
                      },
                      child: activeButton(context, iconData: CupertinoIcons.arrow_clockwise),
                      disableWidget: disableButton(context, iconData: CupertinoIcons.arrow_clockwise),
                    ),
                  ],
                ),
              ),
            ],
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
            child: AppFadeAnimate(
              child: Container(
                height: 2.5,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget activeButton(BuildContext context, {required IconData iconData}) {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueGrey.withOpacity(0.15)
      ),
      padding: const EdgeInsets.all(8.0),
      child: Icon(
        iconData,
        size: 28.0,
      ),
    );
  }

  Widget disableButton(BuildContext context, {required IconData iconData}) {
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




ContextMenu _getContextMenu({
  required ValueNotifier<InAppWebViewController?> webViewController,
  required BuildContext context,
  required WidgetRef ref,
  required safeAreaPadding,
}) {
  return ContextMenu(
    menuItems: [
      ContextMenuItem(id: 1, title: "さらに検索", action: () async {

        final selectedText = await webViewController.value?.getSelectedText();
        if (selectedText != null) {
          final pageUrl = createUrl(selectedText);
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => AppWebView(
                  url: pageUrl,
                  safeAreaPadding: safeAreaPadding,
              ))
          );
          ref.watch(wordHistoryProvider.notifier).add(
              WordHistory(word: selectedText, url: pageUrl.toString()));
        }

      })
    ],
    settings: ContextMenuSettings(
        hideDefaultSystemContextMenuItems: true
    ),
  );
}


