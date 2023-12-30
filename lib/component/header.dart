import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_is/component/animation.dart';
import 'package:what_is/component/squishy_button.dart';
import 'package:what_is/component/word_history.dart';

import '../logic/common_logic.dart';
import '../logic/const.dart';
import '../logic/notifier.dart';
import '../logic/word_history.dart';
import '../theme.dart';

class AppHeader extends HookConsumerWidget {
  const AppHeader({super.key, required this.initText, required this.safeAreaPaddingTop});
  final String? initText;
  final double safeAreaPaddingTop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final history = ref.watch(wordHistoryProvider);

    final scaleKey = useState(GlobalKey());

    ref.listen(wordHistoryProvider, (previous, next) {
      WidgetsBinding.instance.addPostFrameCallback((_){
        if (previous != next) scaleKey.value = GlobalKey();
      });
    });

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_){
        if (initText != null) {
          ref.watch(wordHistoryProvider.notifier).add(
              WordHistory(
                  word: initText!,
                  url: createUrl(initText!).toString()));
        }
      });
      return;
    }, const []);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12.0),
            child: Row(
              children: [
                SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: Image.asset('assets/images/icon_transparent_mini.png')
                ),
                const Spacer(),
                if (history.length > 1)
                  AppAnimation.scale(
                    key: scaleKey.value, //初回or値が変わってbuildされた時のみアニメーションする
                    child: Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: SquishyButton(
                        disableWidget: const SizedBox.shrink(),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => const WordHistoryScreen(),
                              transitionDuration: const Duration(milliseconds: 150),
                              transitionsBuilder:
                                  (context, animation, secondaryAnimation, child) {
                                return FadeTransition(child: child, opacity: animation);
                              },
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            Icon(
                              CupertinoIcons.flowchart,
                              size: 24,
                              shadows: [
                                BoxShadow(
                                    color: Colors.white.withOpacity(0.25),
                                    blurRadius: 40,
                                    offset: const Offset(0.0, 0.0)
                                )
                              ],
                            ),
                            Transform.translate(
                              offset: const Offset(13, -10),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight,
                                    colors: [Color(0xFF00dbde), Color(0xFFfc00ff)],
                                    stops: [0.0, 1.0],
                                  ),
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 2.5, color: Theme.of(context).scaffoldBackgroundColor)
                                ),
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  '${history.length - 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 16.0,),
                SquishyButton(
                  onTap: () {
                    _showMenu(context, safeAreaPaddingTop);
                  },
                  disableWidget: const SizedBox.shrink(),
                  child: const Icon(
                    CupertinoIcons.ellipsis_circle,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 1.0,
          width: double.infinity,
          color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.15),
        ),
      ],
    );
  }


  void _showMenu(BuildContext context, double safeAreaPaddingTop) {
    showDialog(useSafeArea: false,context: context, builder: (_) {
      return AppAnimation.scale(
        alignment: Alignment.topRight,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: () => Navigator.pop(context),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 208,
              margin: EdgeInsets.only(top: safeAreaPaddingTop + 48, right: 8.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(4.0),
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    offset: const Offset(0.0, 4.0)
                  )
                ],
                color: AppTheme.isDarkMode()? const Color(0xFF222222) : Colors.white
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 2.0,),
                  _item(context,
                      label: '検索履歴',
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14.0),
                        topRight: Radius.circular(2.0),
                      ),
                      onTap: () {
                        //TODO: 検索履歴を表示する。
                      }
                  ),
                  _line(context, bold: true),
                  _item(context, label: 'お問い合わせ',
                      onTap: () {
                        //TODO: お問い合わせフォームへ
                      }),
                  _line(context),
                  _item(context, label: 'アプリを評価する',
                      onTap: () {
                        //TODO: Storeへ遷移
                      }),
                  _line(context),
                  _item(context, label: '利用規約',
                      onTap: () {
                        launchUrl(Uri.parse(AppConst.termUrl), mode: LaunchMode.externalApplication);
                        Navigator.pop(context);
                      }),
                  _line(context),
                  _item(context, label: 'プライバシーポリシー',
                      onTap: () {
                        launchUrl(Uri.parse(AppConst.privacyPolicy), mode: LaunchMode.externalApplication);
                        Navigator.pop(context);
                      }),
                  _line(context),
                  _item(context,
                      label: 'ライセンス情報',
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(14.0),
                        bottomLeft: Radius.circular(14.0),
                      ),
                      onTap: () async {
                        final info = await PackageInfo.fromPlatform();
                        showLicensePage(
                          context: context,
                          applicationName: info.appName,
                          applicationVersion: info.version,
                          applicationIcon: SizedBox(
                              height: 72,
                              width: 72,
                              child: Image.asset('assets/images/icon_transparent_mini.png')),
                        );
                      }
                  ),
                  const SizedBox(height: 2.0,),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _item(BuildContext context, {
    required String label,
    BorderRadius borderRadius = BorderRadius.zero,
    required VoidCallback onTap
  }) {
    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14.0),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  fontSize: 15.0,
                  color: Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.8)
                ),
                strutStyle: const StrutStyle(
                  height: 1.2
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(BuildContext context, {bool bold = false}) {
    return SizedBox(
      width: double.infinity,
      height: bold? 4.0 : 1.0,
      child: ColoredBox(
        color: AppTheme.isDarkMode()
            ? Colors.white.withOpacity(bold? 0.08 : 0.05)
            : Colors.black.withOpacity(bold? 0.08 : 0.05),
      ),
    );
  }
}
