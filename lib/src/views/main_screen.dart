import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_swipe_action_cell/core/controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:what_is/main.dart';
import 'package:what_is/src/components/squishy_button.dart';
import 'package:what_is/src/config/theme.dart';
import 'package:what_is/src/controllers/how_to_use_controller.dart';
import 'package:what_is/src/controllers/manual_search_controller.dart';
import 'package:what_is/src/providers/app_lifecycle_provider.dart';
import 'package:what_is/src/routing/navigator.dart';
import 'package:what_is/src/utils/util.dart';

import '../components/app_header.dart';
import '../components/history_list_item.dart';
import '../providers/web_pages_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final viewKey = GlobalKey();

  static late BuildContext pageContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: viewKey,
      body: SafeArea(
        child: Column(
          children: [
            const AppHeader(),
            Expanded(
              child: Navigator(onGenerateRoute: (_) => MaterialPageRoute(
                  builder: (_pageContext) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: HookConsumer(
                        builder: (_, ref, __) {

                          pageContext = _pageContext;

                          final copyText = useState<String?>(null);

                          ref.listen(appLifecycleProvider, (previous, next) {
                            final pages = ref.read(webPagesProvider);
                            if (next == AppLifecycleState.resumed && pages.isEmpty) {
                              WidgetsBinding.instance.addPostFrameCallback((_) async {
                                final value = await getClipboardText();
                                if (value != null && copyText.value != value) {
                                  copyText.value = value;
                                  AppNavigator.toSearchView(ref, searchText: value);
                                }
                              });
                            }
                          });

                          final sampleHistory = useState([ //TODO: ちゃんとする。
                            (title: 'マイクロサービスアーキテクチャ', subText: '今日 - 23:20'),
                            (title: 'PDCA', subText: '昨日 - 23:20'),
                            (title: 'クロスプラットフォーム', subText: '1月19日 - 23:20'),
                            (title: 'アジェンダ', subText: '1月19日 - 23:10'),
                            (title: 'マインドフルネス', subText: '2023年12月31日 - 10:20'),
                          ]);

                          final SwipeActionController controller = SwipeActionController();


                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 40.0,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                offset: const Offset(0.0, 2.0),
                                                blurRadius: 16.0
                                            )
                                          ]
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? AppTheme.darkColor3
                                            : Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 24.0,
                                          left: 24.0,
                                          bottom: 8.0
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Text(
                                                '最近の検索',
                                                style: TextStyle(
                                                    fontSize: 22.0,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(right: 16.0),
                                                child: Material(
                                                  color: accentColor.withOpacity(0.1),
                                                  child: InkWell(
                                                    onTap: () {
                                                      AppNavigator().toHistoryScreen();
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                                                      child: Text(
                                                        'もっと見る',
                                                        style: TextStyle(color: accentColor),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 24.0,),
                                          ListView(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            children: [
                                              for (int i = 0; i < sampleHistory.value.length; i++)
                                                HistoryListItem(
                                                  controller: controller,
                                                  title: sampleHistory.value[i].title,
                                                  subText: sampleHistory.value[i].subText,
                                                  onTap: () {

                                                  },
                                                  onDismissed: () {
                                                    sampleHistory.value = List.of(sampleHistory.value)..removeAt(i);
                                                  },
                                                )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32.0,),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    HowToUseController().show();
                                  },
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.help_outline,
                                        size: 18.0,
                                        color: Theme.of(context).iconTheme.color!.withOpacity(0.6),
                                      ),
                                      const SizedBox(width: 4.0,),
                                      Text(
                                        '検索の仕方',
                                        style: TextStyle(
                                          height: 1.0,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.6)
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          );
                        }
                    ),
                  )
              )),
            )
          ],
        ),
      ),
    );
  }
}



