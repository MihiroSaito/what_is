import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/animation.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:what_is/src/controllers/suggest_translate_controller.dart';
import 'package:what_is/src/controllers/webview_controller.dart';
import 'package:what_is/src/providers/display_web_page_tree_id_provider.dart';
import 'package:what_is/src/providers/translation_confirmed_page_list.dart';

import '../../main.dart';
import '../providers/content_menu_provider.dart';
import '../providers/webview_controllers_provider.dart';
import '../providers/display_web_page_index_provider.dart';
import '../providers/loading_webview_provider.dart';
import '../providers/web_pages_provider.dart';


class SearchViewWidget extends HookConsumerWidget {
  const SearchViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final webPages = ref.watch(webPagesProvider);
    final displayWebPageIndex = ref.watch(displayWebPageIndexProvider);
    final currentWebViewController = ref.watch(specificWebViewControllerProvider(ref.watch(displayWebPageTreeIdProvider)));

    //ページを戻ったり進んだりするとずっとローディングになってしまう問題の対策
    void checkNowLoading() {
      Future.delayed(const Duration(milliseconds: 200), () async {
        final isLoading = await currentWebViewController?.isLoading() ?? false;
        ref.read(isLoadingWebViewProvider.notifier).state = isLoading;
      });
    }

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
              onGoBack: () async {
                await currentWebViewController?.goBack();
                checkNowLoading();
                SuggestTranslateController.pop();
              },
              onGoForward: () {
                currentWebViewController?.goForward();
                checkNowLoading();
                SuggestTranslateController.pop();
              },
              onShare: () async {
                final url = await currentWebViewController?.getOriginalUrl();
                if (url != null) await Share.share(url.toString()); //TODO: できたらURLをテキストではなくWebサイトのように共有したい
              },
              onReload: () async {
                currentWebViewController?.reload();
                final url = await currentWebViewController?.getOriginalUrl();
                if (url == null) return;
                // すでに翻訳するか確認していた場合、再度確認する。
                ref.read(translationConfirmedPageListProvider.notifier).remove(url.toString());
              },
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
    required this.searchTreeId
  });

  final WebUri initialUrl;
  final int searchTreeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoadingNotifier = ref.watch(isLoadingWebViewProvider.notifier);

    return InAppWebView(
      initialUrlRequest: URLRequest(url: initialUrl),
      initialSettings: InAppWebViewSettings(
        transparentBackground: true,
        javaScriptEnabled: true,
        allowsLinkPreview: false,
      ),
      contextMenu: ref.watch(contextMenuProvider(searchTreeId)),
      onLoadStart: (_, __) => isLoadingNotifier.state = true,
      onLoadStop: (controller, uri) async {
        isLoadingNotifier.state = false;
        if (uri == null) return;
        WebViewController().translateIfNeeded(ref, controller: controller, uri: uri);
      },
      onWebViewCreated: (controller) {
        ref.read(webViewControllersProvider.notifier).add(
            (searchTreeId: searchTreeId, controller: controller));
      },
      onUpdateVisitedHistory: (controller, __, ___) async {
        //TODO: 閲覧履歴を取得してデータ活用にする。
      },

      shouldOverrideUrlLoading: (_, __) async {
        return NavigationActionPolicy.ALLOW; //deeplinkで勝手にアプリが開いてしまう問題の対処
      },
      // shouldOverrideUrlLoading: (controller, navigationAction) async {
      //   final currentUrl = (await controller.getUrl());
      //   if (currentUrl.toString() == initialUrl.toString()) {
      //     return NavigationActionPolicy.ALLOW;
      //   }
      //   if (navigationAction.isForMainFrame) {
      //     return WebViewController().checkLink(ref,
      //         currentUrl: currentUrl.toString(),
      //         requestUrl: navigationAction.request.url.toString());
      //   } else {
      //     return NavigationActionPolicy.ALLOW;
      //   }
      // },
    );
  }
}





class WebViewBottomBar extends StatelessWidget {
  const WebViewBottomBar({
    super.key,
    required this.onGoBack,
    required this.onGoForward,
    required this.onShare,
    required this.onReload
  });
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
        Consumer(
          builder: (_, ref, __) {
            final isLoading = ref.watch(isLoadingWebViewProvider);
            if (isLoading) return const SizedBox.shrink();
            return Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: AppAnimation.fadeIn(
                child: Container(
                  height: 2.5,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
              ),
            );
          }
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


