import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/animation.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:what_is/src/controllers/suggest_translate_controller.dart';
import 'package:what_is/src/controllers/webview_controller.dart';
import 'package:what_is/src/providers/display_web_page_tree_id_provider.dart';
import 'package:what_is/src/providers/translation_confirmed_page_list.dart';

import '../../main.dart';
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
                  return Column(
                    children: [
                      //TODO: Google検索画面でのみ表示したい。
                      const GoogleSearchOption(),
                      Expanded(child: e.webViewWidget),
                    ],
                  );
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
                final url = await currentWebViewController?.getUrl();
                if (url != null) await Share.share(url.toString());
                //TODO: できたらURLをテキストではなくWebサイトのように共有したい（現在のshare_plusパッケージだと実現できなそう）
              },
              onReload: () async {
                currentWebViewController?.reload();
                final url = await currentWebViewController?.getUrl();
                if (url == null) return;
                // すでに翻訳するか確認していた場合、再度確認するためにリストから削除する。
                ref.read(translationConfirmedPageListProvider.notifier).remove(url.toString());
              },
            ),
          ],
        ),
      ],
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




class GoogleSearchOption extends HookConsumerWidget {
  const GoogleSearchOption({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final instance = ref.watch(Provider(WebViewController.new));
    final webPages = ref.watch(webPagesProvider);
    final displayWebPageIndex = ref.watch(displayWebPageIndexProvider);
    final searchWord = webPages[displayWebPageIndex].searchWord;
    final searchOptions = webPages[displayWebPageIndex].searchOptions;

    if (searchWord == null) return const SizedBox.shrink();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [

          tag(ref,
              label: 'わかりやすく',
              searchWord: searchWord,
              searchOptions: searchOptions,
              instance: instance),

          const SizedBox(width: 8.0,),

          tag(ref,
              label: '使い方',
              searchWord: searchWord,
              searchOptions: searchOptions,
              instance: instance),

          const SizedBox(width: 8.0,),
          SquishyButton(
            disableWidget: const SizedBox.shrink(),
            onTap: () {
              //TODO: カスタマイズできる。
            },
            child: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.3),
            ),
          )
        ],
      ),
    );
  }

  Widget tag(WidgetRef ref, {
    required String label,
    required String searchWord,
    required List<String> searchOptions,
    required WebViewController instance
  }) {

    final isSelected = searchOptions.contains(label);

    return SquishyButton(
      disableWidget: const SizedBox.shrink(),
      padding: EdgeInsets.zero,
      onTap: () {
        if (isSelected) {
          instance.newSearch(ref, searchText: searchWord, options: []);
        } else {
          instance.newSearch(ref, searchText: searchWord, options: [label]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            border: Border.all(width: 1.0, color: Colors.grey)
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Row(
            children: [
              Icon(
                isSelected? CupertinoIcons.minus : CupertinoIcons.add,
                size: 16.0,
              ),
              const SizedBox(width: 2.0,),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 14.0
                ),
              ),
              const SizedBox(width: 4.0,)
            ],
          ),
        ),
      ),
    );
  }
}


