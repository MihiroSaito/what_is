import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/components/text_button.dart';
import 'package:collection/collection.dart';
import 'package:what_is/src/routing/navigator.dart';

import '../config/theme.dart';
import '../controllers/webview_controller.dart';
import '../providers/content_menu_provider.dart';
import '../providers/display_web_page_index_provider.dart';
import '../providers/loading_webview_provider.dart';
import '../providers/translation_confirmed_page_list.dart';
import '../providers/web_pages_provider.dart';
import '../providers/webview_controllers_provider.dart';


class AppWebView extends HookConsumerWidget {
  AppWebView({
    super.key,
    required this.initialUrl,
    required this.searchTreeId,
    required this.hasSearchWord,
  }) : title = ValueNotifier(""), favicon = ValueNotifier([]), thumbnail = ValueNotifier(null);

  final WebUri initialUrl;
  final int searchTreeId;

  /// 検索ワードがある = URL直アクセスではない
  final bool hasSearchWord;

  /// サイトのタイトル
  final ValueNotifier<String> title;

  /// サイトのFavicon
  final ValueNotifier<List<Favicon>> favicon;

  final ValueNotifier<String?> thumbnail;

  /// ユーザーがURLリクエストを送った時に行う処理
  NavigationActionPolicy shouldOverrideUrlLoadingProcess({
    required NavigationAction navigationAction,
    required ValueNotifier<WebUri> lastRequestPageUrl,
    required WebViewController webViewController,
    required ValueNotifier<WebUri> currentPageUrl,
    required bool hasSearchWord
  }) {
    // メインフレーム（画面全体を読み込む時 = 新規ページへのアクセス）以外のリクエストは特に何もしない。
    if (!navigationAction.isForMainFrame) return NavigationActionPolicy.ALLOW;

    final requestUrl = navigationAction.request.url;

    //TODO: ホームでの処理なら、Google検索結果画面で再度Google検索していないか確認する、していたらSearchViewを閉じ再度アプリ上で検索する

    // リクエストURLがnull、または最後のメインフレームへのアクセスと現在のメインフレームへのアクセスでURLが一致していたら何もしない。1回のページ遷移時に同じURLリクエストが2回きてしまうことがあるためそれの回避
    if (requestUrl == null || lastRequestPageUrl.value == requestUrl) {
      return NavigationActionPolicy.ALLOW;
    }
    lastRequestPageUrl.value = requestUrl;

    // 画面遷移のタイプがないことはほとんどなさそうだが、そんな時は特に何もしない。
    final navigationType = navigationAction.navigationType;
    if (navigationType == null) return NavigationActionPolicy.ALLOW;

    // ユーザーが「戻る/進む」を行った時は何もしない。ただし、ページURLは切り替わるため「現在のページURL」を変更する
    if (navigationType == NavigationType.BACK_FORWARD) {
      currentPageUrl.value = requestUrl;
      return NavigationActionPolicy.ALLOW;
    }

    //TODO: リダイレクトに対応できないため、仕様を変更する

    //TODO: Androidで戻るボタンを押した時の処理が必要になるかも

    // 「さらに検索」が必要なアクセスなら実行する。hasSearchWordがある = URL直アクセスではない ため初回の「さらに検索」はスキップする
    final navigationActionPolicy = webViewController.moreSearchIfNeeded(
        initialPageUrl: initialUrl.toString(),
        currentPageUrl: currentPageUrl.value.toString(),
        requestPageUrl: navigationAction.request.url.toString(),
        currentTreeId: searchTreeId,
        skipInitNavigation: hasSearchWord);

    // このWebViewでの画面遷移が行われるなら、ページURLが切り替わるため「現在のページURL」を変更する
    if (navigationActionPolicy == NavigationActionPolicy.ALLOW) {
      currentPageUrl.value = requestUrl;
    }

    return navigationActionPolicy;
  }

  static final adUrlFilters = [
    ".*.doubleclick.net/.*",
    ".*.ads.pubmatic.com/.*",
    ".*.googlesyndication.com/.*",
    ".*.google-analytics.com/.*",
    ".*.adservice.google.*/.*",
    ".*.adbrite.com/.*",
    ".*.exponential.com/.*",
    ".*.quantserve.com/.*",
    ".*.scorecardresearch.com/.*",
    ".*.zedo.com/.*",
    ".*.adsafeprotected.com/.*",
    ".*.teads.tv/.*",
    ".*.outbrain.com/.*"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final isLoadingNotifier = ref.watch(isLoadingWebViewProvider.notifier);
    ref.watch(translationConfirmedPageListProvider);
    final instance = ref.watch(Provider(WebViewController.new));
    final currentUrl = useState(initialUrl);
    final lastRequestUrl = useState(initialUrl);
    final errorMessage = useState<String?>(null);
    final contentBlockers = useState(<ContentBlocker>[]);

    useEffect(() {
      contentBlockers.value = getContentsBlockers();
      return;
    }, const []);

    return Stack(
      children: [
        Column(
          children: [
            if (currentUrl.value.toString().contains('google.co.jp/search'))
              const GoogleSearchOption(),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: initialUrl),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  allowsLinkPreview: false,
                  contentBlockers: contentBlockers.value
                ),
                contextMenu: ref.watch(contextMenuProvider(searchTreeId)),
                onLoadStart: (controller, __) {
                  isLoadingNotifier.state = true;
                  errorMessage.value = null;
                },
                onLoadStop: (controller, uri) {
                  isLoadingNotifier.state = false;
                  if (uri == null) return;
                  instance.translateIfNeeded(controller: controller, uri: uri);
                },
                onReceivedError: (_, __, webResourceError) {
                  // リロードしまくったり素早くブラウザバックした時に起こるエラーは無視
                  if (webResourceError.type != WebResourceErrorType.CANCELLED) {
                    debugPrint('webResourceError.type: ${webResourceError.type}');
                    errorMessage.value = webResourceError.description;
                    isLoadingNotifier.state = false;
                  }
                },
                onWebViewCreated: (controller) async {
                  ref.read(webViewControllersProvider.notifier).add(
                      (searchTreeId: searchTreeId, controller: controller));
                },
                onUpdateVisitedHistory: (controller, __, ___) async {
                  //TODO: 閲覧履歴を取得してデータ活用にする。
                },
                onLoadResource: (controller, aa) async {
                  try {
                    title.value = await controller.getTitle() ?? "";
                    favicon.value = await controller.getFavicons();
                    final matas = await controller.getMetaTags();
                    for (final v in matas) {
                      final aa = v.attrs?.firstWhereOrNull((e) => e.value =='og:image');
                      if (aa != null) {
                        thumbnail.value = v.content;
                      }
                    }
                  } catch (e) {
                    debugPrint('AppWebView in onLoadResource: $e');
                  }
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return shouldOverrideUrlLoadingProcess(
                      navigationAction: navigationAction,
                      lastRequestPageUrl: lastRequestUrl,
                      webViewController: instance,
                      currentPageUrl: currentUrl,
                      hasSearchWord: hasSearchWord);

                },
              ),
            ),
          ],
        ),


        if (errorMessage.value != null)
          _ErrorView(errorMessage: errorMessage.value!, onTapBackButton: () {

          }),

      ],
    );
  }


  List<ContentBlocker> getContentsBlockers() {
    final contentBlockersList = <ContentBlocker>[];
    for (final adUrlFilter in adUrlFilters) {
      contentBlockersList.add(ContentBlocker(
          trigger: ContentBlockerTrigger(
            urlFilter: adUrlFilter,
          ),
          action: ContentBlockerAction(
            type: ContentBlockerActionType.BLOCK,
          )));
    }

    contentBlockersList.add(ContentBlocker(
        trigger: ContentBlockerTrigger(
          urlFilter: ".*",
        ),
        action: ContentBlockerAction(
            type: ContentBlockerActionType.CSS_DISPLAY_NONE,
            selector:
            ".banner, .banners, .ads, .ad, .advert, .widget-ads, .ad-unit")));

    return contentBlockersList;
  }

}





class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.errorMessage, required this.onTapBackButton});
  final String errorMessage;
  final VoidCallback onTapBackButton;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.xmark_circle_fill,
                color: AppTheme.red.withOpacity(0.8),
                size: 48,
              ),
              const SizedBox(height: 16.0,),
              const Text(
                'このページにアクセスできません',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              AppTextButton(
                  '詳細を見る',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Theme.of(context).textTheme.bodyMedium!.color!,
                  ),
                  onTap: () {
                    showDialog(context: context, builder: (_) {
                      return Center(
                        child: Container(
                          width: 240,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Theme.of(context).scaffoldBackgroundColor
                          ),
                          child: SelectableText(errorMessage, textAlign: TextAlign.center,),
                        ),
                      );
                    });
                  }
              ),
            ],
          ),
        ),
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
              AppNavigator().toSearchOptionSettingScreen();
            },
            child: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.8),
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


